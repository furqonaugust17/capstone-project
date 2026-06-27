'use strict';
const express = require('express');
const mlModelController = require('./mlmodel.controller');
const { authenticate, requireAdmin } = require('../../middlewares/auth.middleware');
const { uploadTflite } = require('../../middlewares/upload.middleware');

const cache = require('../../middlewares/cache.middleware');

const router = express.Router();

router.get('/', authenticate, mlModelController.index);
router.get('/active', authenticate, cache('ml-models', 600), mlModelController.active);
router.get('/:id', authenticate, mlModelController.show);
router.get('/:id/history', authenticate, requireAdmin, mlModelController.history);
router.post('/', authenticate, requireAdmin, uploadTflite.single('file'), mlModelController.store);
router.put('/:id', authenticate, requireAdmin, uploadTflite.single('file'), mlModelController.update);
router.patch('/:id/activate', authenticate, requireAdmin, mlModelController.activate);
router.post('/:id/rollback', authenticate, requireAdmin, mlModelController.rollback);
router.delete('/:id', authenticate, requireAdmin, mlModelController.destroy);

module.exports = router;
