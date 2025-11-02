const AppError = require('./AppError');
const ErrorCodes = require('../constants/errorCodes');

class InternalServerError extends AppError {
  constructor(path = null) {
    super(ErrorCodes.INTERNAL_001, path);
    this.isOperational = false;
    this.name = 'InternalServerError';
  }
}

module.exports = InternalServerError;

