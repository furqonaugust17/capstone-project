'use strict';

const express = require('express');
const router = express.Router();
const logger = require('../../utils/logger');
const { generateSnapshot } = require('../leaderboard/leaderboard.service');
const { env } = require('../../config/env');

// Middleware to verify Vercel Cron Secret
const verifyCron = (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || authHeader !== `Bearer ${env.CRON_SECRET}`) {
    logger.warn('Unauthorized cron invocation attempt');
    return res.status(401).json({ success: false, message: 'Unauthorized' });
  }
  next();
};

// Helper to get week number
function getWeekNumber(d) {
  d = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()));
  d.setUTCDate(d.getUTCDate() + 4 - (d.getUTCDay() || 7));
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
  const weekNo = Math.ceil((((d - yearStart) / 86400000) + 1) / 7);
  return weekNo;
}

router.post('/weekly-snapshot', verifyCron, async (req, res) => {
  try {
    logger.info('Running weekly leaderboard snapshot from Vercel Cron...');
    const now = new Date();
    const periodLabel = `Week ${getWeekNumber(now)} ${now.getFullYear()}`;
    await generateSnapshot('WEEKLY', periodLabel);
    
    logger.info(`Weekly snapshot created: ${periodLabel}`);
    res.status(200).json({ success: true, message: `Weekly snapshot created: ${periodLabel}` });
  } catch (error) {
    logger.error('Error running weekly snapshot:', error);
    res.status(500).json({ success: false, message: 'Failed to generate snapshot' });
  }
});

module.exports = router;
