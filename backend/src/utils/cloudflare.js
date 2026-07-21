'use strict';

const { Upload } = require('@aws-sdk/lib-storage');
const { PutObjectCommand, DeleteObjectCommand } = require('@aws-sdk/client-s3');
const { s3Client } = require('../config/cloudflare');
const { env } = require('../config/env');

const BUCKET_NAME = env.R2_BUCKET_NAME;
const logger = require('./logger');

/**
 * Upload a file buffer to Cloudflare R2
 * @param {Buffer} buffer - File buffer
 * @param {string} key - The key (path) to store the file (e.g., 'animals/thumbnails/1.png')
 * @param {string} mimetype - The MIME type of the file (e.g., 'image/png')
 * @returns {Promise<string>} - The public URL of the uploaded file
 */
const uploadToR2 = async (buffer, key, mimetype) => {
  const command = new PutObjectCommand({
    Bucket: env.R2_BUCKET_NAME,
    Key: key,
    Body: buffer,
    ContentType: mimetype,
  });

  try {
    await s3Client.send(command);
    return `${env.R2_PUBLIC_URL}/${key}`;
  } catch (error) {
    logger.error('❌ Error uploading to R2:', error);
    throw new Error('Failed to upload file to storage');
  }
};

/**
 * Delete a file from Cloudflare R2
 * @param {string} key - The key (path) of the file to delete
 */
const deleteFromR2 = async (key) => {
  const command = new DeleteObjectCommand({
    Bucket: env.R2_BUCKET_NAME,
    Key: key,
  });

  try {
    await s3Client.send(command);
    logger.info(`✅ Deleted file from R2: ${key}`);
  } catch (error) {
    logger.error('❌ Error deleting from R2:', error);
    // Kita tidak throw error agar proses lain tidak terhenti hanya karena gagal hapus
  }
};

module.exports = {
  uploadToR2,
  deleteFromR2,
};