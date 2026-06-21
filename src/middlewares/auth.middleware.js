'use strict';

const { verifyAccessToken, verifyRefreshToken } = require('../utils/jwt');
const { errorResponse } = require('../utils/response');
const logger = require('../utils/logger');
const { PrismaClient } = require('@prisma/client');
const { PrismaPg } = require('@prisma/adapter-pg');
const adapter = new PrismaPg({ connectionString: process.env.DATABASE_URL });
const prisma = new PrismaClient({ adapter: adapter });

/**
 * Auth middleware – verifies JWT access token from the Authorization header.
 * Adds `req.user` (decoded payload) on success.
 */
const authenticate = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        message: 'Missing or malformed Authorization header',
      });
    }

    const token = authHeader.split(' ')[1];
    const payload = verifyAccessToken(token);
    req.user = payload; // payload should contain at least { userId, role }
    next();
  } catch (error) {
    logger.error('❌ Authentication error:', error);
    return res.status(401).json(errorResponse('Invalid or expired token', 401));
  }
};

/**
 * Admin‑only guard – ensures the authenticated user has role ADMIN.
 */
const requireAdmin = (req, res, next) => {
  if (!req.user || req.user.role !== 'ADMIN') {
    return res.status(403).json({
      success: false,
      message: 'Admin privileges required',
    });
  }
  next();
};

module.exports = {
  authenticate,
  requireAdmin,
};
