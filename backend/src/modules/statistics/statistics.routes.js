'use strict';
const express = require('express');
const router = express.Router();
const statisticsController = require('./statistics.controller');
const userStatisticController = require('./user-statistic.controller');
const { authenticate, requireAdmin } = require('../../middlewares/auth.middleware');

// User route
router.get('/my', authenticate, userStatisticController.myStatistic);

// Admin routes
router.get('/overview', authenticate, requireAdmin, statisticsController.overview);
router.get('/charts', authenticate, requireAdmin, statisticsController.charts);
router.get('/detailed', authenticate, requireAdmin, statisticsController.detailed);

module.exports = router;
