'use strict';
const express = require('express');
const leaderboardController = require('./leaderboard.controller');
const { authenticate, requireAdmin } = require('../../middlewares/auth.middleware');
const cache = require('../../middlewares/cache.middleware');

const router = express.Router();

router.get('/live', authenticate, cache('leaderboard', 60), leaderboardController.getLive);
router.get('/me', authenticate, leaderboardController.getMyRank);
router.get('/snapshot', authenticate, cache('leaderboard', 3600), leaderboardController.getSnapshot);
router.post('/snapshot', authenticate, requireAdmin, leaderboardController.generateSnapshot);

module.exports = router;
