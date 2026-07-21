'use strict';

const jwt = require('jsonwebtoken');
const { env } = require('../config/env');

/**
 * Generate a short-lived Access Token
 * @param {Object} payload - User data to encode (e.g., { userId: 1, role: 'ADMIN' })
 */
const generateAccessToken = (payload) => {
  return jwt.sign(payload, env.JWT_ACCESS_SECRET, {
    expiresIn: env.JWT_ACCESS_EXPIRATION,
  });
};

/**
 * Generate a long-lived Refresh Token
 * @param {Object} payload - User data to encode
 */
const generateRefreshToken = (payload) => {
  return jwt.sign(payload, env.JWT_REFRESH_SECRET, {
    expiresIn: env.JWT_REFRESH_EXPIRATION,
  });
};

/**
 * Verify an Access Token
 * @param {string} token
 */
const verifyAccessToken = (token) => {
  try {
    return jwt.verify(token, env.JWT_ACCESS_SECRET);
  } catch (error) {
    throw error;
  }
};

/**
 * Verify a Refresh Token
 * @param {string} token
 */
const verifyRefreshToken = (token) => {
  try {
    return jwt.verify(token, env.JWT_REFRESH_SECRET);
  } catch (error) {
    throw error;
  }
};

module.exports = {
  generateAccessToken,
  generateRefreshToken,
  verifyAccessToken,
  verifyRefreshToken,
};
