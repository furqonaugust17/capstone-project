'use strict';
const express = require('express');
const purchaseController = require('./purchase.controller');
const { authenticate } = require('../../middlewares/auth.middleware');

const router = express.Router();

router.post('/:itemId', authenticate, purchaseController.buyItem);

module.exports = router;
