const { PrismaClient } = require('./src/generated/prisma/client');
const prisma = new PrismaClient({ datasourceUrl: process.env.DATABASE_URL || 'postgresql://postgres:%40Furqon_123@localhost:5433/capstone_project?schema=public' });

async function main() {
  await prisma.userAchievement.deleteMany();
  await prisma.achievement.deleteMany();
}

main().catch(console.error).finally(() => prisma.$disconnect());
