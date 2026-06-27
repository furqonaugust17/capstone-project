'use strict';
const prisma = require('../../config/database');

const getMyInventory = async (userId, page = 1, limit = 10) => {
  const skip = (page - 1) * limit;

  const [total, data] = await Promise.all([
    prisma.userInventory.count({ where: { userId } }),
    prisma.userInventory.findMany({
      where: { userId },
      include: {
        shopItem: true,
      },
      orderBy: { acquiredAt: 'desc' },
      skip,
      take: limit,
    })
  ]);

  return { data, meta: { total, page, limit, totalPages: Math.ceil(total / limit) } };
};

const getPurchaseHistory = async (userId, page = 1, limit = 10) => {
  const skip = (page - 1) * limit;

  const [total, data] = await Promise.all([
    prisma.purchaseHistory.count({ where: { userId } }),
    prisma.purchaseHistory.findMany({
      where: { userId },
      include: {
        shopItem: true,
      },
      orderBy: { purchasedAt: 'desc' },
      skip,
      take: limit,
    })
  ]);

  return { data, meta: { total, page, limit, totalPages: Math.ceil(total / limit) } };
};

const equipItem = async (userId, itemId, category) => {
  const inventoryItem = await prisma.userInventory.findUnique({
    where: {
      userId_itemId: {
        userId,
        itemId
      }
    },
    include: {
      shopItem: true
    }
  });

  if (!inventoryItem) {
    const error = new Error('Item not found in inventory');
    error.statusCode = 404;
    throw error;
  }

  if (inventoryItem.shopItem.category.toLowerCase() !== category.toLowerCase()) {
    const error = new Error(`Item is not of category ${category}`);
    error.statusCode = 400;
    throw error;
  }

  const updateData = {};
  if (category.toLowerCase() === 'avatar') {
    updateData.equippedAvatarId = itemId;
  } else if (category.toLowerCase() === 'frame') {
    updateData.equippedFrameId = itemId;
  } else if (category.toLowerCase() === 'theme') {
    updateData.equippedThemeId = itemId;
  }

  await prisma.user.update({
    where: { id: userId },
    data: updateData
  });

  return { message: 'Item equipped successfully' };
};

const unequipItem = async (userId, category) => {
  const updateData = {};
  if (category.toLowerCase() === 'avatar') {
    updateData.equippedAvatarId = null;
  } else if (category.toLowerCase() === 'frame') {
    updateData.equippedFrameId = null;
  } else if (category.toLowerCase() === 'theme') {
    updateData.equippedThemeId = null;
  }

  await prisma.user.update({
    where: { id: userId },
    data: updateData
  });

  return { message: 'Item unequiped successfully' };
};

module.exports = {
  getMyInventory,
  getPurchaseHistory,
  equipItem,
  unequipItem,
};
