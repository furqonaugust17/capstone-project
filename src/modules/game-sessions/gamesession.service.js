'use strict';
const prisma = require('../../config/database');
const { checkAchievements } = require('../achievements/achievement.checker');

const createSession = async (userId, data) => {
  // Use a Prisma transaction to ensure both operations succeed or fail together
  const sessionResult = await prisma.$transaction(async (tx) => {
    // 1. Create the game session
    const session = await tx.gameSession.create({
      data: {
        userId,
        animalId: data.animalId,
        modelId: data.modelId,
        predictionLabel: data.predictionLabel,
        confidenceScore: data.confidenceScore,
        gameScore: data.gameScore,
        focusScore: data.focusScore,
        drawingDuration: data.drawingDuration,
        startedAt: new Date(data.startedAt),
      },
    });

    // 2. Add the gameScore to the user's totalPoint
    await tx.user.update({
      where: { id: userId },
      data: {
        totalPoint: {
          increment: data.gameScore,
        },
      },
    });

    // 3. Update UserStatistic
    const userStat = await tx.userStatistic.findUnique({ where: { userId } });
    if (userStat) {
      const newTotalGames = userStat.totalGames + 1;
      const newTotalScore = userStat.totalScore + data.gameScore;
      const newHighestScore = Math.max(userStat.highestScore, data.gameScore);
      const newTotalDrawingTime = userStat.totalDrawingTime + data.drawingDuration;
      const focus = data.focusScore || 0;
      const newAverageFocus = ((userStat.averageFocus * userStat.totalGames) + focus) / newTotalGames;

      await tx.userStatistic.update({
        where: { userId },
        data: {
          totalGames: newTotalGames,
          totalScore: newTotalScore,
          highestScore: newHighestScore,
          totalDrawingTime: newTotalDrawingTime,
          averageFocus: newAverageFocus,
        }
      });
    } else {
      await tx.userStatistic.create({
        data: {
          userId,
          totalGames: 1,
          totalScore: data.gameScore,
          highestScore: data.gameScore,
          totalDrawingTime: data.drawingDuration,
          averageFocus: data.focusScore || 0,
        }
      });
    }

    // 4. Check achievements
    await checkAchievements(userId, tx);

    return session;
  });

  // Call adaptive learning logic after successful transaction
  try {
    const analyticsService = require('../analytics/analytics.service');
    await analyticsService.updateLearningProfile(userId, {
      animalId: data.animalId,
      gameScore: data.gameScore,
      confidenceScore: data.confidenceScore,
    });
  } catch (err) {
    // We don't want to fail the session creation if analytics fails
    const logger = require('../../utils/logger');
    logger.error('Failed to update learning profile:', err);
  }

  return sessionResult;
};

const getMySessions = async (userId, page = 1, limit = 10) => {
  const skip = (page - 1) * limit;
  const [total, data] = await Promise.all([
    prisma.gameSession.count({ where: { userId } }),
    prisma.gameSession.findMany({
      where: { userId },
      include: {
        animal: {
          select: { id: true, name: true, thumbnailUrl: true },
        },
        model: {
          select: { id: true, name: true, version: true },
        },
      },
      orderBy: { createdAt: 'desc' },
      skip,
      take: limit,
    })
  ]);
  return { data, meta: { total, page, limit, totalPages: Math.ceil(total / limit) } };
};

const getSessionById = async (id, userId) => {
  const session = await prisma.gameSession.findUnique({
    where: { id },
    include: {
      animal: true,
      model: true,
    },
  });

  if (!session) {
    const error = new Error('Game session not found');
    error.statusCode = 404;
    throw error;
  }

  if (session.userId !== userId) {
    const error = new Error('Forbidden: This session does not belong to you');
    error.statusCode = 403;
    throw error;
  }

  return session;
};

module.exports = {
  createSession,
  getMySessions,
  getSessionById,
};
