const AppError = require('./AppError');
const ErrorCodes = require('../constants/errorCodes');

class NotFoundError extends AppError {
  constructor(errorCode, path = null) {
    super(errorCode, path);
    this.name = 'NotFoundError';
  }
}

module.exports = NotFoundError;

