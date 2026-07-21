'use strict';
const express = require('express');
const inventoryController = require('./inventory.controller');
const { authenticate } = require('../../middlewares/auth.middleware');

const router = express.Router();

router.get('/', authenticate, inventoryController.myInventory);
router.get('/history', authenticate, inventoryController.myHistory);
router.post('/equip', authenticate, inventoryController.equip);
router.post('/unequip', authenticate, inventoryController.unequip);

module.exports = router;
