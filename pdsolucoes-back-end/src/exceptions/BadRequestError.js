const AppError = require('./AppError');

class BadRequestError extends AppError {
  constructor(errorCode, path = null) {
    super(errorCode, path);
    this.name = 'BadRequestError';
  }
}

module.exports = BadRequestError;

