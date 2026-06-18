'use strict';
const prisma = require('../../config/database');

const getAllAchievements = async () => {
  return await prisma.achievement.findMany({
    where: { isActive: true },
    orderBy: { rewardPoint: 'asc' },
  });
};

const getMyAchievements = async (userId) => {
  const userAchievements = await prisma.userAchievement.findMany({
    where: { userId },
    include: {
      achievement: true,
    },
    orderBy: { unlockedAt: 'desc' },
  });

  return userAchievements.map(ua => ({
    unlockedAt: ua.unlockedAt,
    ...ua.achievement,
  }));
};

const createAchievement = async (data, file) => {
  let iconUrl = null;
  if (file) {
    const { uploadToR2 } = require('../../utils/cloudflare');
    const path = require('path');
    const ext = path.extname(file.originalname);
    const key = `achievements/${Date.now()}${ext}`;
    iconUrl = await uploadToR2(file.buffer, key, file.mimetype);
  }

  return await prisma.achievement.create({
    data: {
      ...data,
      iconUrl,
    },
  });
};

const updateAchievement = async (id, data, file) => {
  const existing = await prisma.achievement.findUnique({ where: { id } });
  if (!existing) {
    const error = new Error('Achievement not found');
    error.statusCode = 404;
    throw error;
  }

  let iconUrl = existing.iconUrl;
  if (file) {
    const { uploadToR2, deleteFromR2 } = require('../../utils/cloudflare');
    const { env } = require('../../config/env');
    const path = require('path');
    
    if (iconUrl) {
      const oldKey = iconUrl.replace(`${env.R2_PUBLIC_URL}/`, '');
      await deleteFromR2(oldKey).catch(() => {});
    }

    const ext = path.extname(file.originalname);
    const key = `achievements/${id}${ext}`;
    iconUrl = await uploadToR2(file.buffer, key, file.mimetype);
  }

  return await prisma.achievement.update({
    where: { id },
    data: {
      ...data,
      iconUrl,
    },
  });
};

const deleteAchievement = async (id) => {
  const existing = await prisma.achievement.findUnique({ where: { id } });
  if (!existing) {
    const error = new Error('Achievement not found');
    error.statusCode = 404;
    throw error;
  }

  await prisma.achievement.update({
    where: { id },
    data: { isActive: false },
  });
};

module.exports = {
  getAllAchievements,
  getMyAchievements,
  createAchievement,
  updateAchievement,
  deleteAchievement,
};
