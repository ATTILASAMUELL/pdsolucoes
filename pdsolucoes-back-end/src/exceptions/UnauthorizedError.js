const AppError = require('./AppError');

class UnauthorizedError extends AppError {
  constructor(errorCode, path = null) {
    super(errorCode, path);
    this.name = 'UnauthorizedError';
  }
}

module.exports = UnauthorizedError;

