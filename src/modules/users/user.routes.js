'use strict';
const express = require('express');
const router = express.Router();
const userController = require('./user.controller');
const { authenticate, requireAdmin } = require('../../middlewares/auth.middleware');

// Secure all user management routes for Admin only
router.use(authenticate, requireAdmin);

router.get('/', userController.index);
router.get('/:id', userController.show);
router.get('/:id/inventory', userController.inventory);
router.get('/:id/purchases', userController.purchases);
router.delete('/:id', userController.destroy);

module.exports = router;
