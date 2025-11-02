class AppError extends Error {
  constructor(errorCode, path = null, additionalData = {}) {
    super(errorCode.message);
    
    this.errorCode = errorCode.code;
    this.message = errorCode.message;
    this.statusCode = errorCode.statusCode;
    this.isOperational = true;
    this.status = `${errorCode.statusCode}`.startsWith('4') ? 'fail' : 'error';
    this.timestamp = new Date().toISOString();
    this.path = path;
    this.additionalData = additionalData;
    
    Error.captureStackTrace(this, this.constructor);
  }
}

module.exports = AppError;

