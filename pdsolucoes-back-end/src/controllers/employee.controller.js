const prisma = require('../prisma/client');
const cacheService = require('../services/cache.service');
const { NotFoundError, ValidationError, BadRequestError } = require('../exceptions');
const asyncHandler = require('../utils/asyncHandler');
const ApiResponse = require('../utils/apiResponse');
const ErrorCodes = require('../constants/errorCodes');

const CACHE_TTL = 300;

class EmployeeController {
  getAllEmployees = asyncHandler(async (req, res) => {
    const { search } = req.query;
    
    const cacheKey = search ? `employees:search:${search}` : 'employees:all';
    
    const cachedData = await cacheService.get(cacheKey);
    if (cachedData) {
      return ApiResponse.cached(res, cachedData);
    }

    const whereClause = search 
      ? {
          name: {
            contains: search,
            mode: 'insensitive',
          },
        }
      : {};

    const employees = await prisma.employee.findMany({
      where: whereClause,
      include: {
        squad: true,
      },
      orderBy: {
        name: 'asc',
      },
    });
    
    await cacheService.set(cacheKey, employees, CACHE_TTL);
    
    return ApiResponse.success(res, employees);
  });

  getEmployeeById = asyncHandler(async (req, res) => {
    const { id } = req.params;
    const cacheKey = `employee:${id}`;
    
    const cachedData = await cacheService.get(cacheKey);
    if (cachedData) {
      return ApiResponse.cached(res, cachedData);
    }

    const employee = await prisma.employee.findUnique({
      where: { id },
      include: {
        squad: true,
      },
    });
    
    if (!employee) {
      throw new NotFoundError(ErrorCodes.EMPLOYEE_001, 'EmployeeController.getEmployeeById');
    }
    
    await cacheService.set(cacheKey, employee, CACHE_TTL);
    
    return ApiResponse.success(res, employee);
  });

  createEmployee = asyncHandler(async (req, res) => {
    const { name, estimatedHours, squadId } = req.body;
    
    if (!name || !estimatedHours || !squadId) {
      throw new ValidationError(ErrorCodes.EMPLOYEE_002, 'EmployeeController.createEmployee');
    }

    if (estimatedHours < 1 || estimatedHours > 12) {
      throw new BadRequestError(ErrorCodes.EMPLOYEE_003, 'EmployeeController.createEmployee');
    }

    const squadExists = await prisma.squad.findUnique({
      where: { id: squadId },
    });

    if (!squadExists) {
      throw new NotFoundError(ErrorCodes.SQUAD_001, 'EmployeeController.createEmployee');
    }

    const employee = await prisma.employee.create({
      data: {
        name,
        estimatedHours,
        squadId,
      },
      include: {
        squad: true,
      },
    });
    
    await cacheService.deletePattern('employees:*');
    await cacheService.deletePattern('squads:*');
    await cacheService.deletePattern('dashboard:*');
    
    return ApiResponse.created(res, employee, 'Funcionário criado com sucesso');
  });

  updateEmployee = asyncHandler(async (req, res) => {
    const { id } = req.params;
    const { name, estimatedHours, squadId } = req.body;

    if (estimatedHours && (estimatedHours < 1 || estimatedHours > 12)) {
      throw new BadRequestError(ErrorCodes.EMPLOYEE_003, 'EmployeeController.updateEmployee');
    }
    
    const employee = await prisma.employee.update({
      where: { id },
      data: {
        ...(name && { name }),
        ...(estimatedHours && { estimatedHours }),
        ...(squadId && { squadId }),
      },
      include: {
        squad: true,
      },
    });
    
    await cacheService.delete(`employee:${id}`);
    await cacheService.deletePattern('employees:*');
    await cacheService.deletePattern('squads:*');
    await cacheService.deletePattern('reports:*');
    
    return ApiResponse.success(res, employee, 'Funcionário atualizado com sucesso');
  });

  deleteEmployee = asyncHandler(async (req, res) => {
    const { id } = req.params;
    
    await prisma.employee.delete({
      where: { id },
    });
    
    await cacheService.delete(`employee:${id}`);
    await cacheService.deletePattern('employees:*');
    await cacheService.deletePattern('squads:*');
    await cacheService.deletePattern('reports:*');
    await cacheService.deletePattern('dashboard:*');
    
    return ApiResponse.noContent(res, 'Funcionário deletado com sucesso');
  });
}

module.exports = new EmployeeController();

