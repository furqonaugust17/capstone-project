'use strict';
const express = require('express');
const router = express.Router();
const relationshipController = require('./relationship.controller');
const { authenticate, requireAdmin } = require('../../middlewares/auth.middleware');

router.use(authenticate, requireAdmin);

router.get('/', relationshipController.index);
router.post('/', relationshipController.store);
router.post('/bulk', relationshipController.bulkAssign);
router.delete('/:id', relationshipController.destroy);

module.exports = router;
