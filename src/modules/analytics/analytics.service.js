'use strict';

const prisma = require('../../config/database');

const getOverview = async () => {
  const [totalUsers, totalSessions, stats] = await Promise.all([
    prisma.user.count({ where: { role: 'USER' } }),
    prisma.gameSession.count(),
    prisma.gameSession.aggregate({
      _avg: {
        gameScore: true,
        focusScore: true,
      },
    }),
  ]);

  return {
    totalUsers,
    totalSessions,
    avgScore: stats._avg.gameScore || 0,
    avgFocus: stats._avg.focusScore || 0,
  };
};

const getAnimalsAnalytics = async () => {
  const animalStats = await prisma.gameSession.groupBy({
    by: ['animalId'],
    _count: {
      id: true,
    },
    _avg: {
      gameScore: true,
      confidenceScore: true,
    },
    orderBy: {
      _count: {
        id: 'desc',
      },
    },
  });

  const animalIds = animalStats.map((stat) => stat.animalId);
  const animals = await prisma.animal.findMany({
    where: { id: { in: animalIds } },
    select: { id: true, name: true, thumbnailUrl: true },
  });

  const mappedStats = animalStats.map((stat) => {
    const animal = animals.find((a) => a.id === stat.animalId);
    return {
      animalId: stat.animalId,
      animalName: animal?.name || 'Unknown',
      thumbnailUrl: animal?.thumbnailUrl || null,
      totalPlayed: stat._count.id,
      avgScore: stat._avg.gameScore || 0,
      avgConfidence: stat._avg.confidenceScore || 0,
    };
  });

  return {
    mostPopular: mappedStats[0] || null,
    leastPopular: mappedStats[mappedStats.length - 1] || null,
    stats: mappedStats,
  };
};

const getFocusDistribution = async () => {
  // To get distribution, we fetch all non-null focus scores and categorize them
  // Or we can query using raw SQL if necessary, but fetching is easier if dataset isn't huge.
  // Assuming dataset is manageable for now:
  const sessions = await prisma.gameSession.findMany({
    where: { focusScore: { not: null } },
    select: { focusScore: true, createdAt: true },
    orderBy: { createdAt: 'asc' },
  });

  const distribution = {
    '0.0 - 0.2': 0,
    '0.2 - 0.4': 0,
    '0.4 - 0.6': 0,
    '0.6 - 0.8': 0,
    '0.8 - 1.0': 0,
  };

  sessions.forEach((s) => {
    const f = s.focusScore;
    if (f <= 0.2) distribution['0.0 - 0.2']++;
    else if (f <= 0.4) distribution['0.2 - 0.4']++;
    else if (f <= 0.6) distribution['0.4 - 0.6']++;
    else if (f <= 0.8) distribution['0.6 - 0.8']++;
    else distribution['0.8 - 1.0']++;
  });

  return {
    distribution,
    totalTracked: sessions.length,
  };
};

const getUserAnalytics = async (userId) => {
  const [user, totalGames, stats] = await Promise.all([
    prisma.user.findUnique({ where: { id: userId }, select: { displayName: true, username: true } }),
    prisma.gameSession.count({ where: { userId } }),
    prisma.userStatistic.findUnique({ where: { userId } }),
  ]);

  if (!user) {
    const error = new Error('User not found');
    error.statusCode = 404;
    throw error;
  }

  const favoriteAnimalStat = await prisma.gameSession.groupBy({
    by: ['animalId'],
    where: { userId },
    _count: { id: true },
    orderBy: { _count: { id: 'desc' } },
    take: 1,
  });

  let favoriteAnimal = null;
  if (favoriteAnimalStat.length > 0) {
    favoriteAnimal = await prisma.animal.findUnique({
      where: { id: favoriteAnimalStat[0].animalId },
      select: { id: true, name: true },
    });
  }

  // Trend (last 10 sessions)
  const recentSessions = await prisma.gameSession.findMany({
    where: { userId },
    select: { gameScore: true, focusScore: true, createdAt: true },
    orderBy: { createdAt: 'desc' },
    take: 10,
  });

  return {
    user,
    totalGames,
    totalDrawingTime: stats?.totalDrawingTime || 0,
    averageScore: stats?.totalGames > 0 ? Math.round(stats.totalScore / stats.totalGames) : 0,
    averageFocus: stats?.averageFocus || 0,
    highestScore: stats?.highestScore || 0,
    favoriteAnimal,
    recentTrend: recentSessions.reverse(), // oldest to newest in the last 10
  };
};

const updateLearningProfile = async (userId, sessionData) => {
  const { animalId, gameScore, confidenceScore } = sessionData;

  const profile = await prisma.learningProfile.findUnique({
    where: { userId_animalId: { userId, animalId } },
  });

  if (profile) {
    const newAttemptCount = profile.attemptCount + 1;
    const newAvgScore = ((profile.avgScore * profile.attemptCount) + gameScore) / newAttemptCount;
    const newAvgConfidence = ((profile.avgConfidence * profile.attemptCount) + confidenceScore) / newAttemptCount;

    await prisma.learningProfile.update({
      where: { id: profile.id },
      data: {
        attemptCount: newAttemptCount,
        avgScore: newAvgScore,
        avgConfidence: newAvgConfidence,
        lastPlayedAt: new Date(),
      },
    });
  } else {
    await prisma.learningProfile.create({
      data: {
        userId,
        animalId,
        attemptCount: 1,
        avgScore: gameScore,
        avgConfidence: confidenceScore,
      },
    });
  }
};

const getRecommendations = async (userId, limit = 3) => {
  // 1. Dapatkan hewan yang belum pernah dimainkan (attemptCount = 0 atau tidak ada di learningProfile)
  const allAnimals = await prisma.animal.findMany({ where: { isActive: true } });
  const playedProfiles = await prisma.learningProfile.findMany({ where: { userId } });
  
  const playedAnimalIds = playedProfiles.map(p => p.animalId);
  const unplayedAnimals = allAnimals.filter(a => !playedAnimalIds.includes(a.id));

  // 2. Hewan yang skornya rendah (butuh latihan)
  const lowScoreProfiles = playedProfiles.filter(p => p.avgScore < 60).sort((a, b) => a.avgScore - b.avgScore);
  
  // 3. Hewan yang sudah lama tidak dimainkan
  const oldProfiles = [...playedProfiles].sort((a, b) => a.lastPlayedAt.getTime() - b.lastPlayedAt.getTime());

  // Gabungkan rekomendasi
  const recommendations = [];
  
  // Prioritas 1: Unplayed
  for (const animal of unplayedAnimals) {
    if (recommendations.length >= limit) break;
    recommendations.push({ ...animal, reason: 'NEW_CHALLENGE' });
  }

  // Prioritas 2: Low score
  for (const profile of lowScoreProfiles) {
    if (recommendations.length >= limit) break;
    if (!recommendations.some(r => r.id === profile.animalId)) {
      const animal = allAnimals.find(a => a.id === profile.animalId);
      if (animal) recommendations.push({ ...animal, reason: 'NEEDS_PRACTICE', avgScore: profile.avgScore });
    }
  }

  // Prioritas 3: Lama tidak dimainkan
  for (const profile of oldProfiles) {
    if (recommendations.length >= limit) break;
    if (!recommendations.some(r => r.id === profile.animalId)) {
      const animal = allAnimals.find(a => a.id === profile.animalId);
      if (animal) recommendations.push({ ...animal, reason: 'REVIEW_TIME', lastPlayed: profile.lastPlayedAt });
    }
  }

  return recommendations;
};

module.exports = {
  getOverview,
  getAnimalsAnalytics,
  getFocusDistribution,
  getUserAnalytics,
  updateLearningProfile,
  getRecommendations,
};
