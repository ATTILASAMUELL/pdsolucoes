require('dotenv').config();

process.env.NODE_ENV = 'test';
process.env.JWT_SECRET = process.env.JWT_SECRET || 'test_secret_key';
process.env.DATABASE_URL = process.env.DATABASE_URL || 'postgresql://admin:admin123@localhost:5432/pdsolucoes?schema=public';
process.env.REDIS_URL = process.env.REDIS_URL || 'redis://localhost:6379';
process.env.FRONTEND_URL = process.env.FRONTEND_URL || 'http://localhost:3001';
process.env.EMAIL_HOST = process.env.EMAIL_HOST || 'localhost';
process.env.EMAIL_PORT = process.env.EMAIL_PORT || '1025';
process.env.EMAIL_FROM = process.env.EMAIL_FROM || 'noreply@pdsolucoes.com';

