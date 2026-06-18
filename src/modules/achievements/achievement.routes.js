'use strict';
const express = require('express');
const achievementController = require('./achievement.controller');
const { authenticate, requireAdmin } = require('../../middlewares/auth.middleware');
const { uploadImage } = require('../../middlewares/upload.middleware');

const router = express.Router();

router.get('/', authenticate, achievementController.listAll);
router.get('/my', authenticate, achievementController.listMy);

router.post('/', authenticate, requireAdmin, uploadImage.single('file'), achievementController.store);
router.put('/:id', authenticate, requireAdmin, uploadImage.single('file'), achievementController.update);
router.delete('/:id', authenticate, requireAdmin, achievementController.destroy);

module.exports = router;
