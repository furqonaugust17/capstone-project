'use strict';
const prisma = require('../../config/database');

const getLiveLeaderboard = async (limit = 100) => {
  const topUsers = await prisma.userStatistic.findMany({
    orderBy: {
      totalScore: 'desc',
    },
    take: limit,
    include: {
      user: {
        select: {
          id: true,
          username: true,
          displayName: true,
          avatarUrl: true,
        }
      }
    }
  });

  return topUsers.map((stat, index) => ({
    rank: index + 1,
    userId: stat.userId,
    username: stat.user.username,
    displayName: stat.user.displayName,
    avatarUrl: stat.user.avatarUrl,
    totalScore: stat.totalScore,
    totalGames: stat.totalGames,
  }));
};

const getSnapshotLeaderboard = async (period, periodLabel) => {
  const snapshot = await prisma.leaderboardSnapshot.findFirst({
    where: {
      period,
      periodLabel,
    },
    orderBy: {
      generatedAt: 'desc',
    }
  });

  if (!snapshot) {
    const error = new Error('Leaderboard snapshot not found');
    error.statusCode = 404;
    throw error;
  }

  return snapshot;
};

const generateSnapshot = async (period, periodLabel, limit = 100) => {
  const rankings = await getLiveLeaderboard(limit);

  const snapshot = await prisma.leaderboardSnapshot.create({
    data: {
      period,
      periodLabel,
      rankings,
    }
  });

  return snapshot;
};

const getMyRank = async (userId) => {
  const stat = await prisma.userStatistic.findUnique({
    where: { userId },
    include: {
      user: { select: { username: true, displayName: true, avatarUrl: true } }
    }
  });

  if (!stat) return null;

  const countHigher = await prisma.userStatistic.count({
    where: {
      totalScore: {
        gt: stat.totalScore
      }
    }
  });

  return {
    rank: countHigher + 1,
    userId: stat.userId,
    username: stat.user.username,
    displayName: stat.user.displayName,
    avatarUrl: stat.user.avatarUrl,
    totalScore: stat.totalScore,
    totalGames: stat.totalGames,
  };
};

module.exports = {
  getLiveLeaderboard,
  getSnapshotLeaderboard,
  generateSnapshot,
  getMyRank,
};
