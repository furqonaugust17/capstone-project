'use strict';
const express = require('express');
const shopController = require('./shop.controller');
const { authenticate, requireAdmin } = require('../../middlewares/auth.middleware');
const { uploadImage } = require('../../middlewares/upload.middleware');

const router = express.Router();

router.get('/', authenticate, shopController.index);
router.get('/:id', authenticate, shopController.show);
router.post('/', authenticate, requireAdmin, uploadImage.single('file'), shopController.store);
router.put('/:id', authenticate, requireAdmin, uploadImage.single('file'), shopController.update);
router.delete('/:id', authenticate, requireAdmin, shopController.destroy);

module.exports = router;
