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

module.exports = {
  getMyInventory,
  getPurchaseHistory,
};
