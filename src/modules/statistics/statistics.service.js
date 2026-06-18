'use strict';
const prisma = require('../../config/database');

const getOverview = async () => {
  const [totalUsers, totalGames, activeModels, scoreAgg] = await Promise.all([
    prisma.user.count({ where: { role: 'USER' } }),
    prisma.gameSession.count(),
    prisma.mLModel.count({ where: { isActive: true } }),
    prisma.gameSession.aggregate({
      _avg: { gameScore: true }
    })
  ]);

  return {
    totalUsers,
    totalGames,
    avgScore: Math.round(scoreAgg._avg.gameScore || 0),
    activeModels,
  };
};

const getChartsData = async () => {
  // Activity over the last 7 days
  const sevenDaysAgo = new Date();
  sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
  sevenDaysAgo.setHours(0, 0, 0, 0);

  const sessions = await prisma.gameSession.findMany({
    where: {
      startedAt: {
        gte: sevenDaysAgo,
      }
    },
    select: {
      startedAt: true,
    }
  });

  const sessionChart = {};
  for (let i = 0; i < 7; i++) {
    const d = new Date();
    d.setDate(d.getDate() - i);
    const dateStr = d.toISOString().split('T')[0];
    sessionChart[dateStr] = 0;
  }

  sessions.forEach(session => {
    const dateStr = session.startedAt.toISOString().split('T')[0];
    if (sessionChart[dateStr] !== undefined) {
      sessionChart[dateStr]++;
    }
  });

  const formattedSessionChart = Object.keys(sessionChart)
    .sort() // Sort ascending by date
    .map(date => ({
      date,
      count: sessionChart[date]
    }));

  return {
    sessionsOverTime: formattedSessionChart
  };
};

const getDetailedStatistics = async () => {
  // Top users by points
  const topUsers = await prisma.user.findMany({
    where: { role: 'USER' },
    orderBy: { totalPoint: 'desc' },
    take: 5,
    select: { id: true, username: true, displayName: true, totalPoint: true }
  });

  // Top animals drawn
  const animals = await prisma.animal.findMany({
    include: {
      _count: {
        select: { gameSessions: true }
      }
    }
  });

  const topAnimals = animals
    .map(a => ({
      id: a.id,
      name: a.name,
      sessionCount: a._count.gameSessions
    }))
    .sort((a, b) => b.sessionCount - a.sessionCount)
    .slice(0, 5);

  return {
    topUsers,
    topAnimals
  };
};

module.exports = {
  getOverview,
  getChartsData,
  getDetailedStatistics,
};
