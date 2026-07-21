'use strict';

const Redis = require('ioredis');
const { env } = require('./env');
const logger = require('../utils/logger');

let redisClient = null;

if (env.REDIS_URL) {
  redisClient = new Redis(env.REDIS_URL, {
    maxRetriesPerRequest: 3,
    retryStrategy(times) {
      if (times > 3) {
        logger.error('Redis connection failed after 3 retries.');
        return null; // Stop retrying
      }
      return Math.min(times * 50, 2000);
    }
  });

  redisClient.on('connect', () => {
    logger.info('🚀 Connected to Redis successfully');
  });

  redisClient.on('error', (err) => {
    logger.error(`❌ Redis Error: ${err.message}`);
  });
} else {
  logger.warn('⚠️ REDIS_URL not provided, caching will be disabled.');
}

const clearCache = async (pattern) => {
  if (!redisClient) return;
  try {
    const keys = await redisClient.keys(pattern);
    if (keys.length > 0) {
      await redisClient.del(...keys);
      logger.info(`✅ Cleared cache for pattern: ${pattern} (${keys.length} keys)`);
    }
  } catch (error) {
    logger.error(`❌ Error clearing cache for pattern ${pattern}:`, error);
  }
};

module.exports = {
  redisClient,
  clearCache
};
