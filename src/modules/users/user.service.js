'use strict';
const prisma = require('../../config/database');

const getAllUsers = async (page = 1, limit = 10, search = '') => {
  const skip = (page - 1) * limit;

  // Base query: Only regular users
  const where = {
    role: 'USER',
  };

  if (search) {
    where.OR = [
      { username: { contains: search, mode: 'insensitive' } },
      { email: { contains: search, mode: 'insensitive' } },
      { displayName: { contains: search, mode: 'insensitive' } },
    ];
  }

  const [total, data] = await Promise.all([
    prisma.user.count({ where }),
    prisma.user.findMany({
      where,
      select: {
        id: true,
        username: true,
        email: true,
        displayName: true,
        totalPoint: true,
        avatarUrl: true,
        createdAt: true,
      },
      orderBy: { createdAt: 'desc' },
      skip,
      take: limit,
    })
  ]);

  return {
    data,
    meta: { total, page, limit, totalPages: Math.ceil(total / limit) }
  };
};

const getUserById = async (id) => {
  const user = await prisma.user.findUnique({
    where: { id }
  })

  if (!user) {
    const error = new Error('User not found')
    error.statusCode = 404;
    throw error;
  }

  return user;

}

const deleteUser = async (id) => {
  const user = await prisma.user.findUnique({ where: { id, role: 'USER' } });
  if (!user) {
    const error = new Error('User not found');
    error.statusCode = 404;
    throw error;
  }

  // Prisma relation cascade will automatically clean up game sessions and refresh tokens
  await prisma.user.delete({ where: { id } });
};

module.exports = {
  getAllUsers,
  getUserById,
  deleteUser
};
