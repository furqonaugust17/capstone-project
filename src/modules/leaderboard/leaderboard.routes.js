'use strict';
const express = require('express');
const leaderboardController = require('./leaderboard.controller');
const { authenticate, requireAdmin } = require('../../middlewares/auth.middleware');

const router = express.Router();

router.get('/live', authenticate, leaderboardController.getLive);
router.get('/me', authenticate, leaderboardController.getMyRank);
router.get('/snapshot', authenticate, leaderboardController.getSnapshot);
router.post('/snapshot', authenticate, requireAdmin, leaderboardController.generateSnapshot);

module.exports = router;
