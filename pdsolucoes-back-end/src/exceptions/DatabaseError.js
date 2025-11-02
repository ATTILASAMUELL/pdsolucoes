const AppError = require('./AppError');

class DatabaseError extends AppError {
  constructor(errorCode, path = null, originalError = null) {
    super(errorCode, path, { originalError });
    this.isOperational = false;
    this.name = 'DatabaseError';
    this.originalError = originalError;
  }
}

module.exports = DatabaseError;

