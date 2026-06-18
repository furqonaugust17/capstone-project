'use strict';
const prisma = require('../../config/database');

const createSession = async (userId, data) => {
  // Use a Prisma transaction to ensure both operations succeed or fail together
  return await prisma.$transaction(async (tx) => {
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

    return session;
  });
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
