'use strict';
const express = require('express');
const router = express.Router();
const statisticsController = require('./statistics.controller');
const { authenticate, requireAdmin } = require('../../middlewares/auth.middleware');

router.use(authenticate, requireAdmin);

router.get('/overview', statisticsController.overview);
router.get('/charts', statisticsController.charts);
router.get('/detailed', statisticsController.detailed);

module.exports = router;
