const AppError = require('./AppError');

class ConflictError extends AppError {
  constructor(errorCode, path = null, field = null) {
    super(errorCode, path, { field });
    this.name = 'ConflictError';
    this.field = field;
  }
}

module.exports = ConflictError;

