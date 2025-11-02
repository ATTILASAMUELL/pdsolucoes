const bcrypt = require('bcryptjs');
const prisma = require('./client');

const defaultUsers = [
  {
    name: 'Admin User',
    email: 'admin@pdsolucoes.com',
    password: 'admin123',
  },
];

async function seed() {
  console.log('🌱 Iniciando seed...');

  try {
    for (const userData of defaultUsers) {
      const existingUser = await prisma.user.findUnique({
        where: { email: userData.email },
      });

      if (existingUser) {
        console.log(`✓ Usuário ${userData.email} já existe`);
        continue;
      }

      const hashedPassword = await bcrypt.hash(userData.password, 10);

      const user = await prisma.user.create({
        data: {
          name: userData.name,
          email: userData.email,
          password: hashedPassword,
        },
      });

      console.log(`✓ Usuário criado: ${user.email}`);
    }

    console.log('✅ Seed concluído com sucesso!');
  } catch (error) {
    console.error('❌ Erro no seed:', error);
    throw error;
  }
}

seed()
  .catch((error) => {
    console.error(error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });





