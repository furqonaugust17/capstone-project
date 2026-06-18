'use strict';

const prisma = require('../../config/database');
const bcrypt = require('bcrypt');
const { generateAccessToken, generateRefreshToken, verifyRefreshToken } = require('../../utils/jwt');

const register = async (data) => {
  const existingUser = await prisma.user.findFirst({
    where: {
      OR: [
        { email: data.email },
        { username: data.username },
      ],
    },
  });

  if (existingUser) {
    const error = new Error('Email or username already exists');
    error.statusCode = 409;
    throw error;
  }

  const passwordHash = await bcrypt.hash(data.password, 10);

  const newUser = await prisma.user.create({
    data: {
      username: data.username,
      email: data.email,
      passwordHash,
      displayName: data.displayName,
    },
  });

  const { passwordHash: _, ...userWithoutPassword } = newUser;
  return userWithoutPassword;
};

const login = async (email, password) => {
  const user = await prisma.user.findUnique({ where: { email } });
  if (!user) {
    const error = new Error('Invalid email or password');
    error.statusCode = 401;
    throw error;
  }

  const isPasswordValid = await bcrypt.compare(password, user.passwordHash);
  if (!isPasswordValid) {
    const error = new Error('Invalid email or password');
    error.statusCode = 401;
    throw error;
  }

  const payload = { userId: user.id, role: user.role };
  const accessToken = generateAccessToken(payload);
  const refreshToken = generateRefreshToken(payload);

  const expiresAt = new Date();
  expiresAt.setDate(expiresAt.getDate() + 7); // Default to 7 days for the DB record

  // Clean up expired tokens to prevent bloat
  await prisma.refreshToken.deleteMany({
    where: { expiresAt: { lt: new Date() } }
  }).catch(() => { });

  await prisma.refreshToken.create({
    data: {
      token: refreshToken,
      userId: user.id,
      expiresAt,
    },
  });

  const { passwordHash: _, ...userWithoutPassword } = user;

  return {
    user: userWithoutPassword,
    accessToken,
    refreshToken,
  };
};

const refreshToken = async (token) => {
  let payload;
  try {
    payload = verifyRefreshToken(token);
  } catch (err) {
    const error = new Error('Invalid or expired refresh token');
    error.statusCode = 401;
    throw error;
  }

  const tokenRecord = await prisma.refreshToken.findUnique({
    where: { token },
  });

  if (!tokenRecord) {
    const error = new Error('Refresh token not found in database');
    error.statusCode = 401;
    throw error;
  }

  const user = await prisma.user.findUnique({ where: { id: payload.userId } });
  if (!user) {
    const error = new Error('User not found');
    error.statusCode = 404;
    throw error;
  }

  const newPayload = { userId: user.id, role: user.role };
  const newAccessToken = generateAccessToken(newPayload);

  // Clean up expired tokens
  await prisma.refreshToken.deleteMany({
    where: { expiresAt: { lt: new Date() } }
  }).catch(() => { });

  return {
    accessToken: newAccessToken,
  };
};

const logout = async (token) => {
  await prisma.refreshToken.deleteMany({
    where: { token },
  });
};

const getMe = async (userId) => {
  const user = await prisma.user.findUnique({
    where: { id: userId },
  });

  if (!user) {
    const error = new Error('User not found');
    error.statusCode = 404;
    throw error;
  }

  const { passwordHash: _, ...userWithoutPassword } = user;
  return userWithoutPassword;
};

module.exports = {
  register,
  login,
  refreshToken,
  logout,
  getMe,
};
