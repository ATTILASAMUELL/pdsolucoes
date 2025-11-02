const swaggerJsdoc = require('swagger-jsdoc');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'PD Hours Control API',
      version: '1.0.0',
      description: 'Sistema de controle de horas para gerenciamento de atividades de funcionários organizados em squads\n\n**Versão Atual:** v1\n\n**Base URL:** `/api/v1`',
      contact: {
        name: 'API Support',
        email: 'support@pdsolucoes.com'
      },
    },
    servers: [
      {
        url: 'http://localhost:3000/api/v1',
        description: 'Development server v1',
      },
      {
        url: 'https://api.pdsolucoes.com/api/v1',
        description: 'Production server v1',
      },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
        },
      },
      schemas: {
        User: {
          type: 'object',
          properties: {
            id: { type: 'string', example: '507f1f77bcf86cd799439011' },
            email: { type: 'string', format: 'email', example: 'user@example.com' },
            name: { type: 'string', example: 'João Silva' },
            createdAt: { type: 'string', format: 'date-time' },
            updatedAt: { type: 'string', format: 'date-time' },
          },
        },
        Squad: {
          type: 'object',
          properties: {
            id: { type: 'string', example: '507f1f77bcf86cd799439011' },
            name: { type: 'string', example: 'Squad Alpha' },
            createdAt: { type: 'string', format: 'date-time' },
            updatedAt: { type: 'string', format: 'date-time' },
          },
        },
        Employee: {
          type: 'object',
          properties: {
            id: { type: 'string', example: '507f1f77bcf86cd799439011' },
            name: { type: 'string', example: 'João Silva' },
            estimatedHours: { type: 'integer', minimum: 1, maximum: 12, example: 8 },
            squadId: { type: 'string', example: '507f1f77bcf86cd799439011' },
            createdAt: { type: 'string', format: 'date-time' },
            updatedAt: { type: 'string', format: 'date-time' },
          },
        },
        Report: {
          type: 'object',
          properties: {
            id: { type: 'string', example: '507f1f77bcf86cd799439011' },
            description: { type: 'string', example: 'Desenvolvimento de feature X' },
            employeeId: { type: 'string', example: '507f1f77bcf86cd799439011' },
            spentHours: { type: 'integer', example: 6 },
            createdAt: { type: 'string', format: 'date-time' },
            updatedAt: { type: 'string', format: 'date-time' },
          },
        },
        Error: {
          type: 'object',
          properties: {
            success: { type: 'boolean', example: false },
            message: { type: 'string', example: 'Erro ao processar requisição' },
          },
        },
      },
    },
    tags: [
      { name: 'Auth', description: 'Autenticação e autorização' },
      { name: 'Squads', description: 'Gerenciamento de squads' },
      { name: 'Employees', description: 'Gerenciamento de funcionários' },
      { name: 'Reports', description: 'Relatórios e controle de horas' },
    ],
  },
  apis: ['./src/routes/*.js'],
};

const swaggerSpec = swaggerJsdoc(options);

module.exports = swaggerSpec;

