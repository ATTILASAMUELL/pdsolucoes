const prisma = require('../prisma/client');
const cacheService = require('../services/cache.service');
const { NotFoundError, ValidationError } = require('../exceptions');
const asyncHandler = require('../utils/asyncHandler');
const ApiResponse = require('../utils/apiResponse');
const ErrorCodes = require('../constants/errorCodes');

const CACHE_TTL = 300;

class SquadController {
  getAllSquads = asyncHandler(async (req, res) => {
    const { search } = req.query;
    
    const cacheKey = search ? `squads:search:${search}` : 'squads:all';
    
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

    const squads = await prisma.squad.findMany({
      where: whereClause,
      include: {
        employees: true,
      },
      orderBy: {
        name: 'asc',
      },
    });
    
    await cacheService.set(cacheKey, squads, CACHE_TTL);
    
    return ApiResponse.success(res, squads);
  });

  getSquadById = asyncHandler(async (req, res) => {
    const { id } = req.params;
    const cacheKey = `squad:${id}`;
    
    const cachedData = await cacheService.get(cacheKey);
    if (cachedData) {
      return ApiResponse.cached(res, cachedData);
    }

    const squad = await prisma.squad.findUnique({
      where: { id },
      include: {
        employees: true,
      },
    });
    
    if (!squad) {
      throw new NotFoundError(ErrorCodes.SQUAD_001, 'SquadController.getSquadById');
    }
    
    await cacheService.set(cacheKey, squad, CACHE_TTL);
    
    return ApiResponse.success(res, squad);
  });

  createSquad = asyncHandler(async (req, res) => {
    const { name } = req.body;

    if (!name) {
      throw new ValidationError(ErrorCodes.SQUAD_002, 'SquadController.createSquad');
    }

    const squad = await prisma.squad.create({
      data: { name },
      include: {
        employees: true,
      },
    });
    
    await cacheService.deletePattern('squads:*');
    
    return ApiResponse.created(res, squad, 'Squad criado com sucesso');
  });

  updateSquad = asyncHandler(async (req, res) => {
    const { id } = req.params;
    const { name } = req.body;
    
    const squad = await prisma.squad.update({
      where: { id },
      data: { name },
      include: {
        employees: true,
      },
    });
    
    await cacheService.delete(`squad:${id}`);
    await cacheService.deletePattern('squads:*');
    await cacheService.deletePattern('employees:*');
    
    return ApiResponse.success(res, squad, 'Squad atualizado com sucesso');
  });

  deleteSquad = asyncHandler(async (req, res) => {
    const { id } = req.params;
    
    await prisma.squad.delete({
      where: { id },
    });
    
    await cacheService.delete(`squad:${id}`);
    await cacheService.deletePattern('squads:*');
    await cacheService.deletePattern('employees:*');
    
    return ApiResponse.noContent(res, 'Squad deletado com sucesso');
  });
}

module.exports = new SquadController();

