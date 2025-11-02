const request = require('supertest');
const app = require('../../src/app');
const prisma = require('../../src/prisma/client');

describe('Employee Routes - Integration Tests', () => {
  let authToken;
  let testSquadId;
  let testEmployeeId;

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
      .send({ name: 'Test Squad for Employees' });

    testSquadId = squadResponse.body.data.id;
  });

  afterAll(async () => {
    await prisma.employee.deleteMany({
      where: { name: { contains: 'Test Employee' } },
    });
    await prisma.squad.deleteMany({
      where: { name: 'Test Squad for Employees' },
    });
    await prisma.$disconnect();
  });

  describe('POST /api/employees', () => {
    it('deve criar um novo employee', async () => {
      const newEmployee = {
        name: 'Test Employee John',
        estimatedHours: 8,
        squadId: testSquadId,
      };

      const response = await request(app)
        .post('/api/v1/employees')
        .set('Authorization', `Bearer ${authToken}`)
        .send(newEmployee)
        .expect(201);

      expect(response.body.success).toBe(true);
      expect(response.body.data.name).toBe(newEmployee.name);
      expect(response.body.data.estimatedHours).toBe(newEmployee.estimatedHours);
      expect(response.body.data.squadId).toBe(testSquadId);

      testEmployeeId = response.body.data.id;
    });

    it('deve retornar erro para estimatedHours inválido', async () => {
      const invalidEmployee = {
        name: 'Test Employee Invalid',
        estimatedHours: 15,
        squadId: testSquadId,
      };

      const response = await request(app)
        .post('/api/v1/employees')
        .set('Authorization', `Bearer ${authToken}`)
        .send(invalidEmployee)
        .expect(400);

      expect(response.body.success).toBe(false);
      expect(response.body.message).toContain('estimatedHours deve estar entre 1 e 12');
    });

    it('deve retornar erro para squad inexistente', async () => {
      const invalidEmployee = {
        name: 'Test Employee Invalid Squad',
        estimatedHours: 8,
        squadId: '123e4567-e89b-12d3-a456-426614174000',
      };

      const response = await request(app)
        .post('/api/v1/employees')
        .set('Authorization', `Bearer ${authToken}`)
        .send(invalidEmployee)
        .expect(404);

      expect(response.body.success).toBe(false);
    });
  });

  describe('GET /api/employees', () => {
    it('deve listar todos os employees', async () => {
      const response = await request(app)
        .get('/api/v1/employees')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(Array.isArray(response.body.data)).toBe(true);
    });
  });

  describe('GET /api/employees/:id', () => {
    it('deve retornar um employee específico', async () => {
      const response = await request(app)
        .get(`/api/v1/employees/${testEmployeeId}`)
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data.id).toBe(testEmployeeId);
      expect(response.body.data.squad).toBeDefined();
    });
  });

  describe('PUT /api/employees/:id', () => {
    it('deve atualizar um employee', async () => {
      const updatedData = {
        name: 'Test Employee John Updated',
        estimatedHours: 10,
      };

      const response = await request(app)
        .put(`/api/v1/employees/${testEmployeeId}`)
        .set('Authorization', `Bearer ${authToken}`)
        .send(updatedData)
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data.name).toBe(updatedData.name);
      expect(response.body.data.estimatedHours).toBe(updatedData.estimatedHours);
    });
  });

  describe('DELETE /api/employees/:id', () => {
    it('deve deletar um employee', async () => {
      const response = await request(app)
        .delete(`/api/v1/employees/${testEmployeeId}`)
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(response.body.success).toBe(true);
    });
  });
});

