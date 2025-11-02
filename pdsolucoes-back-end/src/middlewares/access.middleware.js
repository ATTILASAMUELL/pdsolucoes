const logger = require('../utils/logger');

const accessLogger = (req, res, next) => {
  const startTime = Date.now();

  res.on('finish', () => {
    const responseTime = Date.now() - startTime;

    logger.access({
      method: req.method,
      url: req.originalUrl || req.url,
      statusCode: res.statusCode,
      responseTime,
      userId: req.user?.id || null,
      userEmail: req.user?.email || null,
      ip: req.ip || req.connection.remoteAddress,
      userAgent: req.get('user-agent'),
      referer: req.get('referer'),
    });
  });

  next();
};

module.exports = accessLogger;




