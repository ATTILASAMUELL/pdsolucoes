const prisma = require('../prisma/client');

class Logger {
  constructor() {
    this.environment = process.env.NODE_ENV || 'development';
    this.appVersion = process.env.npm_package_version || '1.0.0';
    this.nodeVersion = process.version;
    this.serverInstance = process.env.SERVER_INSTANCE || 'default';
  }

  async error(errorCode, message, context = {}) {
    const logData = {
      level: 'ERROR',
      errorCode: errorCode || 'UNKNOWN',
      message,
      path: context.path || null,
      layer: this.extractLayer(context.path),

      httpMethod: context.method || null,
      httpUrl: context.url || null,
      httpStatusCode: context.statusCode || 500,
      responseTime: context.responseTime || null,

      userId: context.userId || null,
      userEmail: context.userEmail || null,
      userName: context.userName || null,

      ip: context.ip || null,
      userAgent: context.userAgent || null,
      referer: context.referer || null,
      origin: context.origin || null,
      acceptLanguage: context.acceptLanguage || null,

      requestHeaders: context.requestHeaders || null,
      requestBody: context.requestBody || null,
      requestParams: context.requestParams || null,
      requestQuery: context.requestQuery || null,
      responseBody: context.responseBody || null,

      stack: context.stack || null,
      errorName: context.errorName || null,
      errorMessage: context.errorMessage || message,
      isOperational: context.isOperational !== false,

      environment: this.environment,
      serverInstance: this.serverInstance,
      nodeVersion: this.nodeVersion,
      appVersion: this.appVersion,

      additionalData: context.additionalData || null,
    };

    console.error('🔴 ERROR:', {
      errorCode: logData.errorCode,
      message: logData.message,
      path: logData.path,
      layer: logData.layer,
      method: logData.httpMethod,
      url: logData.httpUrl,
    });

    try {
      await prisma.log.create({ data: logData });
    } catch (err) {
      console.error('❌ Falha ao salvar log no banco:', err);
    }

    return logData;
  }

  async warn(message, context = {}) {
    const logData = {
      level: 'WARN',
      message,
      path: context.path || null,
      layer: this.extractLayer(context.path),

      httpMethod: context.method || null,
      httpUrl: context.url || null,
      httpStatusCode: context.statusCode || null,

      userId: context.userId || null,
      userEmail: context.userEmail || null,
      userName: context.userName || null,

      ip: context.ip || null,
      userAgent: context.userAgent || null,

      requestBody: context.requestBody || null,
      requestParams: context.requestParams || null,
      requestQuery: context.requestQuery || null,

      environment: this.environment,
      serverInstance: this.serverInstance,
      nodeVersion: this.nodeVersion,
      appVersion: this.appVersion,

      additionalData: context.additionalData || null,
    };

    console.warn('⚠️  WARN:', { message: logData.message, path: logData.path });

    try {
      await prisma.log.create({ data: logData });
    } catch (err) {
      console.error('❌ Falha ao salvar log no banco:', err);
    }

    return logData;
  }

  async info(message, context = {}) {
    const logData = {
      level: 'INFO',
      message,
      path: context.path || null,
      layer: this.extractLayer(context.path),

      httpMethod: context.method || null,
      httpUrl: context.url || null,
      httpStatusCode: context.statusCode || null,

      userId: context.userId || null,

      environment: this.environment,
      serverInstance: this.serverInstance,

      additionalData: context.additionalData || null,
    };

    console.log('ℹ️  INFO:', { message: logData.message, path: logData.path });

    try {
      await prisma.log.create({ data: logData });
    } catch (err) {
      console.error('❌ Falha ao salvar log no banco:', err);
    }

    return logData;
  }

  async debug(message, context = {}) {
    if (this.environment !== 'production') {
      const logData = {
        level: 'DEBUG',
        message,
        path: context.path || null,
        layer: this.extractLayer(context.path),

        httpMethod: context.method || null,
        httpUrl: context.url || null,

        userId: context.userId || null,

        requestBody: context.requestBody || null,
        requestParams: context.requestParams || null,
        requestQuery: context.requestQuery || null,

        environment: this.environment,

        additionalData: context.additionalData || null,
      };

      console.log('🐛 DEBUG:', { message: logData.message, path: logData.path });

      try {
        await prisma.log.create({ data: logData });
      } catch (err) {
        console.error('❌ Falha ao salvar log no banco:', err);
      }

      return logData;
    }
  }

  async access(context = {}) {
    const logData = {
      level: 'ACCESS',
      message: `${context.method} ${context.url} ${context.statusCode}`,

      httpMethod: context.method,
      httpUrl: context.url,
      httpStatusCode: context.statusCode,
      responseTime: context.responseTime,

      userId: context.userId || null,
      userEmail: context.userEmail || null,

      ip: context.ip,
      userAgent: context.userAgent,
      referer: context.referer || null,

      environment: this.environment,
      serverInstance: this.serverInstance,
    };

    try {
      await prisma.log.create({ data: logData });
    } catch (err) {
      console.error('❌ Falha ao salvar log no banco:', err);
    }

    return logData;
  }

  extractLayer(path) {
    if (!path) return null;
    
    if (path.includes('Controller')) return 'Controller';
    if (path.includes('Service')) return 'Service';
    if (path.includes('Middleware')) return 'Middleware';
    if (path.includes('Route')) return 'Route';
    if (path.includes('Util')) return 'Util';
    
    return 'Unknown';
  }
}

module.exports = new Logger();

