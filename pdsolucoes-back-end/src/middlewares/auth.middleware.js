const tokenUtil = require('../utils/token.util');
const prisma = require('../prisma/client');
const { UnauthorizedError, ForbiddenError } = require('../exceptions');
const asyncHandler = require('../utils/asyncHandler');
const ErrorCodes = require('../constants/errorCodes');

class AuthMiddleware {
  protect = asyncHandler(async (req, res, next) => {
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      throw new UnauthorizedError(ErrorCodes.AUTH_002, 'AuthMiddleware.protect');
    }
    
    const token = authHeader.substring(7);
    const decoded = tokenUtil.verifyToken(token);
    
    if (!decoded) {
      throw new UnauthorizedError(ErrorCodes.AUTH_003, 'AuthMiddleware.protect');
    }
    
    const user = await prisma.user.findUnique({
      where: { id: decoded.userId },
      select: {
        id: true,
        email: true,
        name: true,
      },
    });
    
    if (!user) {
      throw new UnauthorizedError(ErrorCodes.AUTH_006, 'AuthMiddleware.protect');
    }
    
    req.user = user;
    next();
  });

  restrictTo(...roles) {
    return (req, res, next) => {
      if (!roles.includes(req.user.role)) {
        throw new ForbiddenError(ErrorCodes.FORBIDDEN_002, 'AuthMiddleware.restrictTo');
      }
      next();
    };
  }
}

module.exports = new AuthMiddleware();


