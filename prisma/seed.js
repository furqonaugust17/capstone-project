require("dotenv").config();

const { PrismaClient } = require('../src/generated/prisma/client');
const { PrismaPg } = require('@prisma/adapter-pg');
const bcrypt = require('bcrypt');

const adapter = new PrismaPg({ connectionString: process.env.DATABASE_URL });
const prisma = new PrismaClient({ adapter: adapter });

async function main() {
  console.log('🌱 Start seeding...');

  // 1. Create Admin User
  const adminEmail = 'admin@animaldrawing.com';
  const adminPassword = 'adminpassword123';
  const passwordHash = await bcrypt.hash(adminPassword, 10);

  const adminUser = await prisma.user.upsert({
    where: { email: adminEmail },
    update: {},
    create: {
      username: 'admin',
      email: adminEmail,
      passwordHash,
      role: 'ADMIN',
      displayName: 'System Admin',
    },
  });
  console.log(`✅ Admin user created/verified: ${adminUser.email}`);

  // 2. Create Sample Animals
  const animals = [
    {
      name: 'Kucing',
      description: 'Kucing peliharaan dengan bulu yang lembut.',
    },
    {
      name: 'Sapi',
      description: 'Hewan ternak herbivora penghasil susu dan daging.',
    },
    {
      name: 'Bebek',
      description: 'Unggas air berkaki selaput yang pandai berenang.',
    },
    {
      name: 'Ikan',
      description: 'Hewan air yang bernapas menggunakan insang.',
    },
    {
      name: 'Lumba-lumba',
      description: 'Mamalia laut yang sangat cerdas dan ramah.',
    }
  ];

  for (const animalData of animals) {
    const existing = await prisma.animal.findFirst({
      where: { name: animalData.name }
    });

    if (!existing) {
      await prisma.animal.create({
        data: animalData,
      });
      console.log(`✅ Animal created: ${animalData.name}`);
    } else {
      console.log(`ℹ️ Animal already exists: ${animalData.name}`);
    }
  }

  // 3. Create Dummy Users (Players)
  const dummyPlayers = [];
  for (let i = 1; i <= 5; i++) {
    const playerEmail = `player${i}@animaldrawing.com`;
    let player = await prisma.user.findFirst({ where: { email: playerEmail } });
    if (!player) {
      player = await prisma.user.create({
        data: {
          username: `player${i}`,
          email: playerEmail,
          passwordHash, // using same password hash as admin for simplicity
          role: 'USER',
          displayName: `Player ${i}`,
          totalPoint: Math.floor(Math.random() * 1000) + 200,
        }
      });
      console.log(`✅ Dummy player created: ${player.username}`);
    }
    dummyPlayers.push(player);
  }

  // 4. Create Dummy ML Model
  let activeModel = await prisma.mLModel.findFirst({ where: { isActive: true } });
  if (!activeModel) {
    activeModel = await prisma.mLModel.create({
      data: {
        name: 'CNN Sketch Animal',
        version: '1.0.0',
        fileUrl: 'https://example.com/dummy.tflite',
        accuracy: 92.5,
        inputSize: 224,
        isActive: true,
      }
    });
    console.log(`✅ Dummy ML Model created`);
  }

  // 5. Create Dummy Game Sessions (for Charts)
  const existingSessions = await prisma.gameSession.count();
  if (existingSessions < 20) {
    const allAnimals = await prisma.animal.findMany();
    
    // Create random sessions for the past 7 days
    if (allAnimals.length > 0 && dummyPlayers.length > 0) {
      for (let i = 0; i < 50; i++) {
        const randomPlayer = dummyPlayers[Math.floor(Math.random() * dummyPlayers.length)];
        const randomAnimal = allAnimals[Math.floor(Math.random() * allAnimals.length)];
        
        const randomDaysAgo = Math.floor(Math.random() * 7); // 0 to 6 days ago
        const sessionDate = new Date();
        sessionDate.setDate(sessionDate.getDate() - randomDaysAgo);
        sessionDate.setHours(Math.floor(Math.random() * 24), Math.floor(Math.random() * 60));

        await prisma.gameSession.create({
          data: {
            userId: randomPlayer.id,
            animalId: randomAnimal.id,
            modelId: activeModel.id,
            predictionLabel: randomAnimal.name,
            confidenceScore: (Math.random() * 0.4 + 0.6), // 0.6 to 1.0
            gameScore: Math.floor(Math.random() * 50) + 50, // 50 to 100
            focusScore: (Math.random() * 0.5 + 0.5), // 0.5 to 1.0
            drawingDuration: Math.floor(Math.random() * 60) + 15, // 15 to 75 seconds
            startedAt: new Date(sessionDate.getTime() - 60000), // 1 min before finished
            finishedAt: sessionDate,
            createdAt: sessionDate,
          }
        });
      }
      console.log(`✅ 50 Dummy Game Sessions created for chart visualization`);
    }
  }

  // 6. Create Dummy Shop Items
  const shopItems = [
    { name: 'Red Theme', description: 'Red app theme', price: 100, category: 'THEME', rarity: 'COMMON' },
    { name: 'Blue Theme', description: 'Blue app theme', price: 200, category: 'THEME', rarity: 'RARE' },
    { name: 'Cat Avatar', description: 'Cute cat avatar', price: 500, category: 'AVATAR', rarity: 'EPIC' },
    { name: 'Golden Frame', description: 'Gold profile frame', price: 1000, category: 'FRAME', rarity: 'LEGENDARY' }
  ];

  for (const item of shopItems) {
    const existing = await prisma.shopItem.findFirst({ where: { name: item.name } });
    if (!existing) {
      await prisma.shopItem.create({ data: item });
      console.log(`✅ Shop Item created: ${item.name}`);
    } else {
      console.log(`ℹ️ Shop Item already exists: ${item.name}`);
    }
  }

  console.log('✨ Seeding completed!');
}

main()
  .catch((e) => {
    console.error('❌ Seeding failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
