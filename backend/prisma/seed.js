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
      description: 'Hewan peliharaan yang lucu dan menggemaskan dengan bulu lembut.',
      funFact: 'Kucing menghabiskan sekitar 70% dari hidupnya untuk tidur.',
      drawingTips: [
        'Mulai dengan bentuk lingkaran untuk kepala dan oval untuk badan.',
        'Gunakan dua segitiga kecil untuk telinga di atas kepala.',
        'Tambahkan kumis panjang di area pipi agar terlihat lebih nyata.'
      ],
      difficulty: 'easy'
    },
    {
      name: 'Sapi',
      description: 'Hewan herbivora bertubuh besar yang menghasilkan susu segar.',
      funFact: 'Sapi memiliki memori yang sangat baik dan bisa mengingat teman-teman mereka.',
      drawingTips: [
        'Gambar bentuk kotak atau persegi panjang tumpul untuk badannya.',
        'Tambahkan corak belang-belang asimetris khas sapi perah.',
        'Jangan lupa gambar moncong hidung yang besar dan ekor dengan ujung berbulu.'
      ],
      difficulty: 'medium'
    },
    {
      name: 'Bebek',
      description: 'Unggas air yang pandai berenang dengan kakinya yang berselaput.',
      funFact: 'Bulu bebek dilapisi minyak khusus yang membuatnya tahan air.',
      drawingTips: [
        'Bentuk dasar bebek menyerupai angka dua (2).',
        'Gambarkan paruh yang pipih dan memanjang ke depan.',
        'Buat kakinya berselaput dengan bentuk tiga jari menyatu.'
      ],
      difficulty: 'easy'
    },
    {
      name: 'Ikan',
      description: 'Hewan air yang bernapas dengan insang dan memiliki sisik.',
      funFact: 'Beberapa spesies ikan mas bisa hidup hingga puluhan tahun.',
      drawingTips: [
        'Buat bentuk oval memanjang untuk badan utamanya.',
        'Tambahkan sirip segitiga di punggung, bawah badan, dan ekor.',
        'Gambarkan sisik menggunakan garis-garis melengkung (seperti huruf C).'
      ],
      difficulty: 'easy'
    },
    {
      name: 'Lumba-lumba',
      description: 'Mamalia laut yang sangat cerdas, lincah, dan ramah terhadap manusia.',
      funFact: 'Lumba-lumba berkomunikasi satu sama lain menggunakan siulan yang unik.',
      drawingTips: [
        'Gunakan bentuk melengkung seperti pisang untuk badannya.',
        'Buat sirip punggung melengkung dan paruh hidung yang sedikit menonjol.',
        'Gambar garis mulut yang terlihat seperti selalu tersenyum.'
      ],
      difficulty: 'medium'
    },
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
      await prisma.animal.update({
        where: { id: existing.id },
        data: {
          funFact: animalData.funFact,
          drawingTips: animalData.drawingTips,
          difficulty: animalData.difficulty,
        }
      });
      console.log(`ℹ️ Animal already exists (updated fields): ${animalData.name}`);
    }
  }



  // 3. Create Dummy Users (Players)
  const realisticPlayers = [
    { username: 'BudiSantoso', displayName: 'Budi Santoso' },
    { username: 'SitiAisyah', displayName: 'Siti Aisyah' },
    { username: 'AhmadFauzi', displayName: 'Ahmad Fauzi' },
    { username: 'RinaWijaya', displayName: 'Rina Wijaya' },
    { username: 'DimasPratama', displayName: 'Dimas Pratama' },
  ];

  const dummyPlayers = [];
  for (const p of realisticPlayers) {
    const playerEmail = `${p.username.toLowerCase()}@animaldrawing.com`;
    let player = await prisma.user.findFirst({ where: { email: playerEmail } });
    if (!player) {
      player = await prisma.user.create({
        data: {
          username: p.username,
          email: playerEmail,
          passwordHash,
          role: 'USER',
          displayName: p.displayName,
          totalPoint: Math.floor(Math.random() * 2000) + 500,
          avatarUrl: `https://api.dicebear.com/7.x/avataaars/svg?seed=${p.username}`
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
    { name: 'Dark Mode Theme', description: 'Elegan dan ramah di mata untuk bermain malam hari', price: 100, category: 'THEME', rarity: 'COMMON', imageUrl: 'https://api.dicebear.com/7.x/shapes/svg?seed=dark' },
    { name: 'Ocean Blue Theme', description: 'Tema laut biru yang menyegarkan pikiran', price: 200, category: 'THEME', rarity: 'RARE', imageUrl: 'https://api.dicebear.com/7.x/shapes/svg?seed=ocean' },
    { name: 'Cute Cat Avatar', description: 'Avatar kucing lucu yang cocok untuk profilmu', price: 500, category: 'AVATAR', rarity: 'EPIC', imageUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Cat' },
    { name: 'Fierce Tiger Avatar', description: 'Tunjukkan jiwa petarungmu dengan avatar ini', price: 750, category: 'AVATAR', rarity: 'EPIC', imageUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Tiger' },
    { name: 'Golden Dragon Frame', description: 'Bingkai naga emas yang melegenda', price: 1000, category: 'FRAME', rarity: 'LEGENDARY', imageUrl: 'https://api.dicebear.com/7.x/icons/svg?seed=Dragon' },
    { name: 'Wooden Classic Frame', description: 'Bingkai kayu klasik yang estetik', price: 150, category: 'FRAME', rarity: 'COMMON', imageUrl: 'https://api.dicebear.com/7.x/icons/svg?seed=Wood' }
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
