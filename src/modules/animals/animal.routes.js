'use strict';
const express = require('express');
const animalController = require('./animal.controller');
const { authenticate, requireAdmin } = require('../../middlewares/auth.middleware');
const { uploadFields } = require('../../middlewares/upload.middleware');

const router = express.Router();

router.get('/', authenticate, animalController.index);
router.get('/:id', authenticate, animalController.show);
router.post('/', authenticate, requireAdmin, uploadFields, animalController.store);
router.put('/:id', authenticate, requireAdmin, uploadFields, animalController.update);
router.delete('/:id', authenticate, requireAdmin, animalController.destroy);

module.exports = router;
