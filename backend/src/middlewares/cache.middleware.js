'use strict';

const { redisClient } = require('../config/redis');
const logger = require('../utils/logger');

/**
 * Cache middleware generator
 * @param {string} prefix - Key prefix (e.g., 'animals', 'leaderboard')
 * @param {number} ttlSeconds - Time to live in seconds
 */
const cache = (prefix, ttlSeconds) => {
  return async (req, res, next) => {
    if (!redisClient) {
      return next(); // Skip caching if Redis is not configured or failed
    }

    const key = `${prefix}:${req.originalUrl || req.url}`;

    try {
      const cachedData = await redisClient.get(key);
      if (cachedData) {
        logger.debug(`Hit cache: ${key}`);
        return res.status(200).json(JSON.parse(cachedData));
      }

      // Intercept res.json to cache the response before sending it
      const originalJson = res.json.bind(res);
      res.json = (body) => {
        // Only cache successful GET responses
        if (res.statusCode >= 200 && res.statusCode < 300) {
          redisClient.set(key, JSON.stringify(body), 'EX', ttlSeconds).catch(err => {
            logger.error(`❌ Error setting cache for key ${key}:`, err);
          });
        }
        return originalJson(body);
      };

      next();
    } catch (error) {
      logger.error('❌ Cache Middleware Error:', error);
      next(); // Fallback to DB on error
    }
  };
};

module.exports = cache;
