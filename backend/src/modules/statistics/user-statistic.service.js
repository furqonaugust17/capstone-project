'use strict';
const prisma = require('../../config/database');

const getUserStatistic = async (userId) => {
  const stat = await prisma.userStatistic.findUnique({
    where: { userId },
  });

  if (!stat) {
    // If not found, create a default one for the user
    return await prisma.userStatistic.create({
      data: { userId },
    });
  }

  return stat;
};

module.exports = {
  getUserStatistic,
};
