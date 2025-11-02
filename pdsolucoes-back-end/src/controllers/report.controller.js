const prisma = require('../prisma/client');
const cacheService = require('../services/cache.service');
const { NotFoundError, ValidationError, BadRequestError } = require('../exceptions');
const asyncHandler = require('../utils/asyncHandler');
const ApiResponse = require('../utils/apiResponse');
const ErrorCodes = require('../constants/errorCodes');

const CACHE_TTL_SHORT = 180;
const CACHE_TTL_LONG = 600;

class ReportController {
  getAllReports = asyncHandler(async (req, res) => {
    const cacheKey = 'reports:all';
    
    const cachedData = await cacheService.get(cacheKey);
    if (cachedData) {
      return ApiResponse.cached(res, cachedData);
    }

    const reports = await prisma.report.findMany({
      include: {
        employee: {
          include: {
            squad: true,
          },
        },
      },
      orderBy: {
        createdAt: 'desc',
      },
    });
    
    await cacheService.set(cacheKey, reports, CACHE_TTL_SHORT);
    
    return ApiResponse.success(res, reports);
  });

  createReport = asyncHandler(async (req, res) => {
    const { description, employeeId, spentHours } = req.body;

    if (!description || !employeeId || !spentHours) {
      throw new ValidationError(ErrorCodes.REPORT_002, 'ReportController.createReport');
    }

    const employeeExists = await prisma.employee.findUnique({
      where: { id: employeeId },
    });

    if (!employeeExists) {
      throw new NotFoundError(ErrorCodes.EMPLOYEE_001, 'ReportController.createReport');
    }

    const report = await prisma.report.create({
      data: {
        description,
        employeeId,
        spentHours,
      },
      include: {
        employee: {
          include: {
            squad: true,
          },
        },
      },
    });

    await cacheService.deletePattern('reports:*');
    await cacheService.deletePattern('dashboard:*');

    return ApiResponse.created(res, report, 'Report criado com sucesso');
  });

  getSquadMemberHours = asyncHandler(async (req, res) => {
    const { squadId } = req.params;
    const { startDate, endDate } = req.query;

    if (!startDate || !endDate) {
      throw new BadRequestError(ErrorCodes.REPORT_003, 'ReportController.getSquadMemberHours');
    }

    const cacheKey = `reports:squad:${squadId}:member-hours:${startDate}:${endDate}`;
    
    const cachedData = await cacheService.get(cacheKey);
    if (cachedData) {
      return ApiResponse.cached(res, cachedData);
    }

    const start = new Date(startDate);
    start.setHours(0, 0, 0, 0);
    
    const end = new Date(endDate);
    end.setHours(23, 59, 59, 999);

    const employees = await prisma.employee.findMany({
      where: { squadId },
      include: {
        reports: {
          where: {
            createdAt: {
              gte: start,
              lte: end,
            },
          },
        },
        squad: true,
      },
    });

    const result = employees.map(employee => ({
      id: employee.id,
      name: employee.name,
      estimatedHours: employee.estimatedHours,
      totalSpentHours: employee.reports.reduce((sum, report) => sum + report.spentHours, 0),
      reports: employee.reports,
    }));

    await cacheService.set(cacheKey, result, CACHE_TTL_SHORT);

    return ApiResponse.success(res, result);
  });

  getSquadTotalHours = asyncHandler(async (req, res) => {
    const { squadId } = req.params;
    const { startDate, endDate } = req.query;

    if (!startDate || !endDate) {
      throw new BadRequestError(ErrorCodes.REPORT_003, 'ReportController.getSquadTotalHours');
    }

    const cacheKey = `reports:squad:${squadId}:total-hours:${startDate}:${endDate}`;
    
    const cachedData = await cacheService.get(cacheKey);
    if (cachedData) {
      return ApiResponse.cached(res, cachedData);
    }

    const start = new Date(startDate);
    start.setHours(0, 0, 0, 0);
    
    const end = new Date(endDate);
    end.setHours(23, 59, 59, 999);

    const squad = await prisma.squad.findUnique({
      where: { id: squadId },
      include: {
        employees: {
          include: {
            reports: {
              where: {
                createdAt: {
                  gte: start,
                  lte: end,
                },
              },
            },
          },
        },
      },
    });

    if (!squad) {
      throw new NotFoundError(ErrorCodes.SQUAD_001, 'ReportController.getSquadTotalHours');
    }

    const totalHours = squad.employees.reduce((total, employee) => {
      return total + employee.reports.reduce((sum, report) => sum + report.spentHours, 0);
    }, 0);

    const result = {
      squadId: squad.id,
      squadName: squad.name,
      period: { startDate, endDate },
      totalHours,
    };

    await cacheService.set(cacheKey, result, CACHE_TTL_SHORT);

    return ApiResponse.success(res, result);
  });

  getSquadAverageHoursPerDay = asyncHandler(async (req, res) => {
    const { squadId } = req.params;
    const { startDate, endDate } = req.query;

    if (!startDate || !endDate) {
      throw new BadRequestError(ErrorCodes.REPORT_003, 'ReportController.getSquadAverageHoursPerDay');
    }

    const cacheKey = `reports:squad:${squadId}:average-hours:${startDate}:${endDate}`;
    
    const cachedData = await cacheService.get(cacheKey);
    if (cachedData) {
      return ApiResponse.cached(res, cachedData);
    }

    const start = new Date(startDate);
    start.setHours(0, 0, 0, 0);
    
    const end = new Date(endDate);
    end.setHours(23, 59, 59, 999);

    const squad = await prisma.squad.findUnique({
      where: { id: squadId },
      include: {
        employees: {
          include: {
            reports: {
              where: {
                createdAt: {
                  gte: start,
                  lte: end,
                },
              },
            },
          },
        },
      },
    });

    if (!squad) {
      throw new NotFoundError(ErrorCodes.SQUAD_001, 'ReportController.getSquadAverageHoursPerDay');
    }

    const totalHours = squad.employees.reduce((total, employee) => {
      return total + employee.reports.reduce((sum, report) => sum + report.spentHours, 0);
    }, 0);

    const daysDiff = Math.ceil((end - start) / (1000 * 60 * 60 * 24)) + 1;
    const averageHoursPerDay = daysDiff > 0 ? totalHours / daysDiff : 0;

    const result = {
      squadId: squad.id,
      squadName: squad.name,
      period: { startDate, endDate },
      totalHours,
      totalDays: daysDiff,
      averageHoursPerDay: parseFloat(averageHoursPerDay.toFixed(2)),
    };

    await cacheService.set(cacheKey, result, CACHE_TTL_SHORT);

    return ApiResponse.success(res, result);
  });

  getDashboardData = asyncHandler(async (req, res) => {
    const cacheKey = 'dashboard:stats';
    
    const cachedData = await cacheService.get(cacheKey);
    if (cachedData) {
      return ApiResponse.cached(res, cachedData);
    }

    const [totalEmployees, totalSquads, totalReports] = await Promise.all([
      prisma.employee.count(),
      prisma.squad.count(),
      prisma.report.count(),
    ]);
    
    const result = {
      totalEmployees,
      totalSquads,
      totalReports,
    };

    await cacheService.set(cacheKey, result, CACHE_TTL_LONG);
    
    return ApiResponse.success(res, result);
  });
}

module.exports = new ReportController();

