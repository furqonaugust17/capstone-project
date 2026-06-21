'use strict';
const cron = require('node-cron');
const prisma = require('../config/database');
const { generateSnapshot } = require('../modules/leaderboard/leaderboard.service');
const logger = require('../utils/logger');

// Job 1: Generate Weekly Leaderboard Snapshot
// Runs every Sunday at 23:59
cron.schedule('59 23 * * 0', async () => {
  try {
    logger.info('Running weekly leaderboard snapshot...');
    const now = new Date();
    // Assuming a simple label like "Week 42 2023"
    const periodLabel = `Week ${getWeekNumber(now)} ${now.getFullYear()}`;
    await generateSnapshot('WEEKLY', periodLabel);
    logger.info(`Weekly snapshot created: ${periodLabel}`);
  } catch (error) {
    logger.error('Error running weekly snapshot:', error);
  }
});

// Helper to get week number
function getWeekNumber(d) {
  d = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()));
  d.setUTCDate(d.getUTCDate() + 4 - (d.getUTCDay() || 7));
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
  const weekNo = Math.ceil((((d - yearStart) / 86400000) + 1) / 7);
  return weekNo;
}

logger.info('Cron jobs initialized');
