const env = require('../config/env');
const { AppError, InternalServerError } = require('../exceptions');
const ErrorHandler = require('../utils/errorHandler');
const ErrorCodes = require('../constants/errorCodes');

const errorMiddleware = (err, req, res, next) => {
  let error = err;

  const requestPath = `${req.method} ${req.path}`;

  if (error.code && error.code.startsWith('P')) {
    error = ErrorHandler.handlePrismaError(error, requestPath);
  }

  if (error.name === 'JsonWebTokenError' || error.name === 'TokenExpiredError') {
    error = ErrorHandler.handleJWTError(error, requestPath);
  }

  if (error.name === 'ValidationError' && !error.statusCode) {
    error = ErrorHandler.handleValidationError(error, requestPath);
  }

  if (!(error instanceof AppError)) {
    error = new InternalServerError(requestPath);
  }

  ErrorHandler.logError(error, req);

  const response = {
    success: false,
    status: error.status,
    errorCode: error.errorCode,
    timestamp: error.timestamp,
  };

  if (env.NODE_ENV === 'development') {
    response.message = error.message;
    response.path = error.path;
    response.stack = error.stack;
    if (error.errors) {
      response.errors = error.errors;
    }
    if (error.field) {
      response.field = error.field;
    }
  }

  res.status(error.statusCode).json(response);
};

module.exports = errorMiddleware;


