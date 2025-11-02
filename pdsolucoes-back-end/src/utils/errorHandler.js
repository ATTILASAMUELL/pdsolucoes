const {
  AppError,
  ValidationError,
  NotFoundError,
  UnauthorizedError,
  ConflictError,
  DatabaseError,
} = require('../exceptions');
const ErrorCodes = require('../constants/errorCodes');
const logger = require('./logger');

class ErrorHandler {
  static handlePrismaError(error, path = null) {
    const { code, meta } = error;

    switch (code) {
      case 'P2002':
        return new ConflictError(ErrorCodes.DB_001, path, meta?.target);

      case 'P2025':
        return new NotFoundError(ErrorCodes.DB_002, path);

      case 'P2003':
        return new ValidationError(ErrorCodes.DB_003, path);

      case 'P2014':
        return new ValidationError(ErrorCodes.DB_004, path);

      case 'P2021':
      case 'P2022':
      default:
        return new DatabaseError(ErrorCodes.DB_005, path, error);
    }
  }

  static handleJWTError(error, path = null) {
    if (error.name === 'JsonWebTokenError') {
      return new UnauthorizedError(ErrorCodes.AUTH_003, path);
    }
    if (error.name === 'TokenExpiredError') {
      return new UnauthorizedError(ErrorCodes.AUTH_004, path);
    }
    return error;
  }

  static handleValidationError(error, path = null) {
    const errors = Object.values(error.errors).map(err => ({
      field: err.path,
      message: err.message,
    }));

    return new ValidationError(ErrorCodes.VALIDATION_001, path, errors);
  }

  static isOperationalError(error) {
    if (error instanceof AppError) {
      return error.isOperational;
    }
    return false;
  }

  static logError(error, req) {
    const context = {
      path: error.path || `${req.method} ${req.path}`,
      method: req.method,
      url: req.originalUrl || req.url,
      statusCode: error.statusCode,
      
      userId: req.user?.id || null,
      userEmail: req.user?.email || null,
      userName: req.user?.name || null,

      ip: req.ip || req.connection.remoteAddress,
      userAgent: req.get('user-agent'),
      referer: req.get('referer'),
      origin: req.get('origin'),
      acceptLanguage: req.get('accept-language'),

      requestHeaders: req.headers,
      requestBody: req.body,
      requestParams: req.params,
      requestQuery: req.query,

      stack: error.stack,
      errorName: error.name,
      errorMessage: error.message,
      isOperational: error.isOperational,

      additionalData: error.additionalData,
    };

    logger.error(error.errorCode || 'UNKNOWN', error.message, context);
  }
}

module.exports = ErrorHandler;

