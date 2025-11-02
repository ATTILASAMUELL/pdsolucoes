const redis = require('redis');
const env = require('../config/env');

class CacheService {
  constructor() {
    this.client = null;
    this.isConnected = false;
    this.connect();
  }

  async connect() {
    try {
      this.client = redis.createClient({
        url: env.REDIS_URL,
      });

      this.client.on('error', (err) => {
        console.error('❌ Redis Client Error:', err);
        this.isConnected = false;
      });

      this.client.on('connect', () => {
        console.log('✅ Conectado ao Redis');
        this.isConnected = true;
      });

      await this.client.connect();
    } catch (error) {
      console.error('❌ Erro ao conectar ao Redis:', error);
      this.isConnected = false;
    }
  }

  async get(key) {
    if (!this.isConnected) return null;
    
    try {
      const data = await this.client.get(key);
      if (data) {
        console.log(`📦 Cache HIT: ${key}`);
        return JSON.parse(data);
      }
      console.log(`📭 Cache MISS: ${key}`);
      return null;
    } catch (error) {
      console.error(`Erro ao buscar cache ${key}:`, error);
      return null;
    }
  }

  async set(key, value, ttl = 300) {
    if (!this.isConnected) return false;
    
    try {
      await this.client.setEx(key, ttl, JSON.stringify(value));
      console.log(`💾 Cache SET: ${key} (TTL: ${ttl}s)`);
      return true;
    } catch (error) {
      console.error(`Erro ao salvar cache ${key}:`, error);
      return false;
    }
  }

  async delete(key) {
    if (!this.isConnected) return false;
    
    try {
      await this.client.del(key);
      console.log(`🗑️  Cache DELETE: ${key}`);
      return true;
    } catch (error) {
      console.error(`Erro ao deletar cache ${key}:`, error);
      return false;
    }
  }

  async deletePattern(pattern) {
    if (!this.isConnected) return false;
    
    try {
      const keys = await this.client.keys(pattern);
      if (keys.length > 0) {
        await this.client.del(keys);
        console.log(`🗑️  Cache DELETE Pattern: ${pattern} (${keys.length} keys)`);
      }
      return true;
    } catch (error) {
      console.error(`Erro ao deletar pattern ${pattern}:`, error);
      return false;
    }
  }

  async clear() {
    if (!this.isConnected) return false;
    
    try {
      await this.client.flushAll();
      console.log('🗑️  Cache LIMPO completamente');
      return true;
    } catch (error) {
      console.error('Erro ao limpar cache:', error);
      return false;
    }
  }
}

module.exports = new CacheService();





