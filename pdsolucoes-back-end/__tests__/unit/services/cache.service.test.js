const cacheService = require('../../../src/services/cache.service');

jest.mock('redis', () => ({
  createClient: jest.fn(() => ({
    connect: jest.fn(),
    get: jest.fn(),
    setEx: jest.fn(),
    del: jest.fn(),
    keys: jest.fn(),
    flushAll: jest.fn(),
    on: jest.fn(),
  })),
}));

describe('CacheService - Unit Tests', () => {
  describe('get', () => {
    it('deve retornar dados do cache quando existir', async () => {
      const mockData = { id: '123', name: 'Test Squad' };
      cacheService.client.get = jest.fn().mockResolvedValue(JSON.stringify(mockData));
      cacheService.isConnected = true;

      const result = await cacheService.get('test-key');

      expect(result).toEqual(mockData);
      expect(cacheService.client.get).toHaveBeenCalledWith('test-key');
    });

    it('deve retornar null quando cache não existir', async () => {
      cacheService.client.get = jest.fn().mockResolvedValue(null);
      cacheService.isConnected = true;

      const result = await cacheService.get('non-existent-key');

      expect(result).toBeNull();
    });

    it('deve retornar null quando Redis não estiver conectado', async () => {
      cacheService.isConnected = false;

      const result = await cacheService.get('test-key');

      expect(result).toBeNull();
    });
  });

  describe('set', () => {
    it('deve salvar dados no cache com TTL', async () => {
      const mockData = { id: '123', name: 'Test Squad' };
      cacheService.client.setEx = jest.fn().mockResolvedValue('OK');
      cacheService.isConnected = true;

      const result = await cacheService.set('test-key', mockData, 300);

      expect(result).toBe(true);
      expect(cacheService.client.setEx).toHaveBeenCalledWith(
        'test-key',
        300,
        JSON.stringify(mockData)
      );
    });

    it('deve retornar false quando Redis não estiver conectado', async () => {
      cacheService.isConnected = false;

      const result = await cacheService.set('test-key', {}, 300);

      expect(result).toBe(false);
    });
  });

  describe('delete', () => {
    it('deve deletar chave do cache', async () => {
      cacheService.client.del = jest.fn().mockResolvedValue(1);
      cacheService.isConnected = true;

      const result = await cacheService.delete('test-key');

      expect(result).toBe(true);
      expect(cacheService.client.del).toHaveBeenCalledWith('test-key');
    });
  });

  describe('deletePattern', () => {
    it('deve deletar múltiplas chaves por pattern', async () => {
      const mockKeys = ['squad:1', 'squad:2', 'squad:3'];
      cacheService.client.keys = jest.fn().mockResolvedValue(mockKeys);
      cacheService.client.del = jest.fn().mockResolvedValue(3);
      cacheService.isConnected = true;

      const result = await cacheService.deletePattern('squad:*');

      expect(result).toBe(true);
      expect(cacheService.client.keys).toHaveBeenCalledWith('squad:*');
      expect(cacheService.client.del).toHaveBeenCalledWith(mockKeys);
    });
  });
});





