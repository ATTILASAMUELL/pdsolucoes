const request = require('supertest');
const app = require('../../src/app');
const prisma = require('../../src/prisma/client');

describe('Squad Routes - Integration Tests', () => {
  let authToken;
  let testSquadId;

  beforeAll(async () => {
    await prisma.$connect();

    const loginResponse = await request(app)
      .post('/api/v1/auth/login')
      .send({
        email: 'admin@pdsolucoes.com',
        password: 'admin123',
      });

    authToken = loginResponse.body.data.token;
  });

  afterAll(async () => {
    await prisma.squad.deleteMany({
      where: { name: { contains: 'Test Squad' } },
    });
    await prisma.$disconnect();
  });

  describe('POST /api/squads', () => {
    it('deve criar um novo squad', async () => {
      const newSquad = {
        name: 'Test Squad Alpha',
      };

      const response = await request(app)
        .post('/api/v1/squads')
        .set('Authorization', `Bearer ${authToken}`)
        .send(newSquad)
        .expect(201);

      expect(response.body.success).toBe(true);
      expect(response.body.data.name).toBe(newSquad.name);
      expect(response.body.data.id).toBeDefined();

      testSquadId = response.body.data.id;
    });

    it('deve retornar erro sem autenticação', async () => {
      const newSquad = {
        name: 'Test Squad Beta',
      };

      const response = await request(app)
        .post('/api/v1/squads')
        .send(newSquad)
        .expect(401);

      expect(response.body.success).toBe(false);
    });

    it('deve retornar erro sem campo name', async () => {
      const response = await request(app)
        .post('/api/v1/squads')
        .set('Authorization', `Bearer ${authToken}`)
        .send({})
        .expect(400);

      expect(response.body.success).toBe(false);
    });
  });

  describe('GET /api/squads', () => {
    it('deve listar todos os squads', async () => {
      const response = await request(app)
        .get('/api/v1/squads')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(Array.isArray(response.body.data)).toBe(true);
      expect(response.body.data.length).toBeGreaterThan(0);
    });

    it('deve incluir campo cached na resposta', async () => {
      const response = await request(app)
        .get('/api/v1/squads')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(response.body.cached).toBeDefined();
      expect(typeof response.body.cached).toBe('boolean');
    });
  });

  describe('GET /api/squads/:id', () => {
    it('deve retornar um squad específico', async () => {
      const response = await request(app)
        .get(`/api/v1/squads/${testSquadId}`)
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data.id).toBe(testSquadId);
      expect(response.body.data.name).toBe('Test Squad Alpha');
    });

    it('deve retornar 404 para squad não existente', async () => {
      const fakeId = '123e4567-e89b-12d3-a456-426614174000';

      const response = await request(app)
        .get(`/api/v1/squads/${fakeId}`)
        .set('Authorization', `Bearer ${authToken}`)
        .expect(404);

      expect(response.body.success).toBe(false);
    });
  });

  describe('PUT /api/squads/:id', () => {
    it('deve atualizar um squad', async () => {
      const updatedData = {
        name: 'Test Squad Alpha Updated',
      };

      const response = await request(app)
        .put(`/api/v1/squads/${testSquadId}`)
        .set('Authorization', `Bearer ${authToken}`)
        .send(updatedData)
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data.name).toBe(updatedData.name);
    });
  });

  describe('DELETE /api/squads/:id', () => {
    it('deve deletar um squad', async () => {
      const response = await request(app)
        .delete(`/api/v1/squads/${testSquadId}`)
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(response.body.success).toBe(true);

      const checkResponse = await request(app)
        .get(`/api/v1/squads/${testSquadId}`)
        .set('Authorization', `Bearer ${authToken}`)
        .expect(404);

      expect(checkResponse.body.success).toBe(false);
    });
  });
});

