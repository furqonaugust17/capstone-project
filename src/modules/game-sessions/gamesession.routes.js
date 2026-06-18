'use strict';
const express = require('express');
const gameSessionController = require('./gamesession.controller');
const { authenticate } = require('../../middlewares/auth.middleware');

const router = express.Router();

// Apply authentication middleware to all routes in this module
router.use(authenticate);

router.post('/', gameSessionController.store);
router.get('/', gameSessionController.index);
router.get('/:id', gameSessionController.show);

module.exports = router;
