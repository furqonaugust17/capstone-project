'use strict';

const multer = require('multer');
const path = require('path');

// Use memory storage for files (buffers will be uploaded to R2 later)
const storage = multer.memoryStorage();

const fileFilter = (req, file, cb) => {
  const allowedMimes = ['image/jpeg', 'image/png', 'image/svg+xml', 'application/x-tflite', 'application/octet-stream'];
  if (allowedMimes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(new Error('Invalid file type. Only JPG, PNG, SVG, and TFLITE are allowed.'), false);
  }
};

/**
 * Configuration for general image uploads (max 2MB)
 */
const uploadImage = multer({
  storage,
  fileFilter,
  limits: { fileSize: 2 * 1024 * 1024 },
});

/**
 * Configuration for TFLite model uploads (max 50MB)
 */
const uploadTflite = multer({
  storage,
  fileFilter,
  limits: { fileSize: 50 * 1024 * 1024 },
});

/**
 * Configuration for multiple fields (thumbnail and hint image)
 */
const uploadFields = multer({
  storage,
  fileFilter,
  limits: { fileSize: 2 * 1024 * 1024 },
}).fields([
  { name: 'thumbnail', maxCount: 1 },
  { name: 'hintImage', maxCount: 1 },
  { name: 'traceImage', maxCount: 1 },
]);

module.exports = {
  uploadImage,
  uploadTflite,
  uploadFields,
};
