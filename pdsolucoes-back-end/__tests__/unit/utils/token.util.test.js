const tokenUtil = require('../../../src/utils/token.util');
const jwt = require('jsonwebtoken');

jest.mock('../../../src/config/env', () => ({
  JWT_SECRET: 'test-secret',
  JWT_EXPIRES_IN: '1h',
}));

describe('TokenUtil - Unit Tests', () => {
  describe('generateToken', () => {
    it('deve gerar um token JWT válido', () => {
      const userId = '123e4567-e89b-12d3-a456-426614174000';
      const token = tokenUtil.generateToken(userId);

      expect(token).toBeDefined();
      expect(typeof token).toBe('string');

      const decoded = jwt.verify(token, 'test-secret');
      expect(decoded.userId).toBe(userId);
    });
  });

  describe('verifyToken', () => {
    it('deve verificar um token válido', () => {
      const userId = '123e4567-e89b-12d3-a456-426614174000';
      const token = jwt.sign({ userId }, 'test-secret', { expiresIn: '1h' });

      const result = tokenUtil.verifyToken(token);

      expect(result).toBeDefined();
      expect(result.userId).toBe(userId);
    });

    it('deve retornar null para token inválido', () => {
      const result = tokenUtil.verifyToken('invalid-token');

      expect(result).toBeNull();
    });

    it('deve retornar null para token expirado', () => {
      const userId = '123e4567-e89b-12d3-a456-426614174000';
      const expiredToken = jwt.sign({ userId }, 'test-secret', { expiresIn: '0s' });

      setTimeout(() => {
        const result = tokenUtil.verifyToken(expiredToken);
        expect(result).toBeNull();
      }, 100);
    });
  });

  describe('generateResetToken', () => {
    it('deve gerar um token de reset único', () => {
      const token1 = tokenUtil.generateResetToken();
      const token2 = tokenUtil.generateResetToken();

      expect(token1).toBeDefined();
      expect(token2).toBeDefined();
      expect(token1).not.toBe(token2);
      expect(token1.length).toBe(64);
    });
  });
});





