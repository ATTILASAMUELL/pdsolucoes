const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient({
  log: process.env.NODE_ENV === 'test' ? [] : ['query', 'info', 'warn', 'error'],
});

if (process.env.NODE_ENV !== 'test') {
  prisma.$connect()
    .then(() => {
      console.log('✅ Conectado ao banco de dados');
    })
    .catch((error) => {
      console.error('❌ Erro ao conectar ao banco de dados:', error);
      process.exit(1);
    });
}

process.on('beforeExit', async () => {
  await prisma.$disconnect();
});

module.exports = prisma;





