const request = require('supertest');
const app = require('../../src/app');
const prisma = require('../../src/prisma/client');

describe('Report Routes - Integration Tests', () => {
  let authToken;
  let testSquadId;
  let testEmployeeId;
  let testReportId;

  beforeAll(async () => {
    await prisma.$connect();

    const loginResponse = await request(app)
      .post('/api/v1/auth/login')
      .send({
        email: 'admin@pdsolucoes.com',
        password: 'admin123',
      });

    authToken = loginResponse.body.data.token;

    const squadResponse = await request(app)
      .post('/api/v1/squads')
      .set('Authorization', `Bearer ${authToken}`)
      .send({ name: 'Test Squad for Reports' });

    testSquadId = squadResponse.body.data.id;

    const employeeResponse = await request(app)
      .post('/api/v1/employees')
      .set('Authorization', `Bearer ${authToken}`)
      .send({
        name: 'Test Employee for Reports',
        estimatedHours: 8,
        squadId: testSquadId,
      });

    testEmployeeId = employeeResponse.body.data.id;
  });

  afterAll(async () => {
    await prisma.report.deleteMany({
      where: { description: { contains: 'Test Report' } },
    });
    await prisma.employee.deleteMany({
      where: { name: 'Test Employee for Reports' },
    });
    await prisma.squad.deleteMany({
      where: { name: 'Test Squad for Reports' },
    });
    await prisma.$disconnect();
  });

  describe('POST /api/v1/reports', () => {
    it('deve criar um novo report', async () => {
      const newReport = {
        description: 'Test Report - Development',
        employeeId: testEmployeeId,
        spentHours: 5,
      };

      const response = await request(app)
        .post('/api/v1/reports')
        .set('Authorization', `Bearer ${authToken}`)
        .send(newReport)
        .expect(201);

      expect(response.body.success).toBe(true);
      expect(response.body.data.description).toBe(newReport.description);
      expect(response.body.data.spentHours).toBe(newReport.spentHours);
      expect(response.body.data.employeeId).toBe(testEmployeeId);

      testReportId = response.body.data.id;
    });

    it('deve retornar erro para campos obrigatórios faltando', async () => {
      const invalidReport = {
        description: 'Test Report Incomplete',
      };

      const response = await request(app)
        .post('/api/v1/reports')
        .set('Authorization', `Bearer ${authToken}`)
        .send(invalidReport)
        .expect(400);

      expect(response.body.success).toBe(false);
      expect(response.body.errorCode).toBe('REPORT_002');
    });

    it('deve retornar erro para employee inexistente', async () => {
      const invalidReport = {
        description: 'Test Report Invalid Employee',
        employeeId: '123e4567-e89b-12d3-a456-426614174000',
        spentHours: 5,
      };

      const response = await request(app)
        .post('/api/v1/reports')
        .set('Authorization', `Bearer ${authToken}`)
        .send(invalidReport)
        .expect(404);

      expect(response.body.success).toBe(false);
      expect(response.body.errorCode).toBe('EMPLOYEE_001');
    });
  });

  describe('GET /api/v1/reports', () => {
    it('deve listar todos os reports', async () => {
      const response = await request(app)
        .get('/api/v1/reports')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(Array.isArray(response.body.data)).toBe(true);
      expect(response.body.data.length).toBeGreaterThan(0);
    });

    it('deve incluir campo cached na resposta', async () => {
      const response = await request(app)
        .get('/api/v1/reports')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(response.body.cached).toBeDefined();
      expect(typeof response.body.cached).toBe('boolean');
    });
  });

  describe('GET /api/v1/reports/squad/:squadId/member-hours', () => {
    it('deve retornar horas por membro do squad', async () => {
      const startDate = new Date();
      startDate.setDate(startDate.getDate() - 7);
      const endDate = new Date();

      const response = await request(app)
        .get(`/api/v1/reports/squad/${testSquadId}/member-hours`)
        .set('Authorization', `Bearer ${authToken}`)
        .query({
          startDate: startDate.toISOString().split('T')[0],
          endDate: endDate.toISOString().split('T')[0],
        })
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(Array.isArray(response.body.data)).toBe(true);
    });

    it('deve retornar erro sem parâmetros de data', async () => {
      const response = await request(app)
        .get(`/api/v1/reports/squad/${testSquadId}/member-hours`)
        .set('Authorization', `Bearer ${authToken}`)
        .expect(400);

      expect(response.body.success).toBe(false);
      expect(response.body.errorCode).toBe('REPORT_003');
    });
  });

  describe('GET /api/v1/reports/squad/:squadId/total-hours', () => {
    it('deve retornar total de horas do squad', async () => {
      const startDate = new Date();
      startDate.setDate(startDate.getDate() - 7);
      const endDate = new Date();

      const response = await request(app)
        .get(`/api/v1/reports/squad/${testSquadId}/total-hours`)
        .set('Authorization', `Bearer ${authToken}`)
        .query({
          startDate: startDate.toISOString().split('T')[0],
          endDate: endDate.toISOString().split('T')[0],
        })
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data.squadId).toBe(testSquadId);
      expect(response.body.data.totalHours).toBeDefined();
    });

    it('deve retornar erro para squad inexistente', async () => {
      const fakeId = '123e4567-e89b-12d3-a456-426614174000';
      const startDate = new Date();
      startDate.setDate(startDate.getDate() - 7);
      const endDate = new Date();

      const response = await request(app)
        .get(`/api/v1/reports/squad/${fakeId}/total-hours`)
        .set('Authorization', `Bearer ${authToken}`)
        .query({
          startDate: startDate.toISOString().split('T')[0],
          endDate: endDate.toISOString().split('T')[0],
        })
        .expect(404);

      expect(response.body.success).toBe(false);
      expect(response.body.errorCode).toBe('SQUAD_001');
    });
  });

  describe('GET /api/v1/reports/squad/:squadId/average-hours', () => {
    it('deve retornar média de horas do squad', async () => {
      const startDate = new Date();
      startDate.setDate(startDate.getDate() - 7);
      const endDate = new Date();

      const response = await request(app)
        .get(`/api/v1/reports/squad/${testSquadId}/average-hours`)
        .set('Authorization', `Bearer ${authToken}`)
        .query({
          startDate: startDate.toISOString().split('T')[0],
          endDate: endDate.toISOString().split('T')[0],
        })
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data.squadId).toBe(testSquadId);
      expect(response.body.data.averageHoursPerDay).toBeDefined();
      expect(typeof response.body.data.averageHoursPerDay).toBe('number');
    });
  });

  describe('GET /api/v1/reports/dashboard', () => {
    it('deve retornar dados do dashboard', async () => {
      const response = await request(app)
        .get('/api/v1/reports/dashboard')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data.totalEmployees).toBeDefined();
      expect(response.body.data.totalSquads).toBeDefined();
      expect(response.body.data.totalReports).toBeDefined();
    });

    it('deve usar cache na segunda chamada', async () => {
      const firstResponse = await request(app)
        .get('/api/v1/reports/dashboard')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      const secondResponse = await request(app)
        .get('/api/v1/reports/dashboard')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(secondResponse.body.cached).toBe(true);
    });
  });
});

