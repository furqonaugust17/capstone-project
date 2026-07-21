'use strict';
const express = require('express');
const analyticsController = require('./analytics.controller');
const { authenticate, requireAdmin } = require('../../middlewares/auth.middleware');

const router = express.Router();

// User route
router.get('/recommendations', authenticate, analyticsController.recommendations);

// Admin routes
router.use(authenticate, requireAdmin);

router.get('/overview', analyticsController.overview);
router.get('/animals', analyticsController.animals);
router.get('/focus', analyticsController.focus);
router.get('/users/:id', analyticsController.userStats);

module.exports = router;
