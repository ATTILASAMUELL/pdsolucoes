const AppError = require('./AppError');

class ValidationError extends AppError {
  constructor(errorCode, path = null, errors = []) {
    super(errorCode, path, { errors });
    this.name = 'ValidationError';
    this.errors = errors;
  }
}

module.exports = ValidationError;

