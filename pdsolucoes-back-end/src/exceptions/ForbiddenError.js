const AppError = require('./AppError');

class ForbiddenError extends AppError {
  constructor(errorCode, path = null) {
    super(errorCode, path);
    this.name = 'ForbiddenError';
  }
}

module.exports = ForbiddenError;

