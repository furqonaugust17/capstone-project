'use strict';

const { Upload } = require('@aws-sdk/lib-storage');
const { PutObjectCommand, DeleteObjectCommand } = require('@aws-sdk/client-s3');
const { s3Client } = require('../config/cloudflare');
const { env } = require('../config/env');

const BUCKET_NAME = env.R2_BUCKET_NAME;

/**
 * Upload a file buffer to Cloudflare R2
 * @param {Buffer} buffer - File buffer
 * @param {string} key - The key (path) to store the file (e.g., 'animals/thumbnails/1.png')
 * @param {string} mimetype - The MIME type of the file (e.g., 'image/png')
 * @returns {Promise<string>} - The public URL of the uploaded file
 */
const uploadToR2 = async (buffer, key, mimetype) => {
  try {
    const upload = new Upload({
      client: s3Client,
      params: {
        Bucket: BUCKET_NAME,
        Key: key,
        Body: buffer,
        ContentType: mimetype,
      },
    });

    await upload.done();

    // Construct public URL: e.g., https://pub-xxxxxx.r2.dev/animals/thumbnails/1.png
    const publicUrl = `${env.R2_PUBLIC_URL}/${key}`;
    return publicUrl;
  } catch (error) {
    console.error('❌ Error uploading to R2:', error);
    throw new Error('Failed to upload file to storage');
  }
};

/**
 * Delete a file from Cloudflare R2
 * @param {string} key - The key (path) of the file to delete
 */
const deleteFromR2 = async (key) => {
  try {
    const command = new DeleteObjectCommand({
      Bucket: BUCKET_NAME,
      Key: key,
    });

    await s3Client.send(command);
    console.log(`✅ Deleted file from R2: ${key}`);
  } catch (error) {
    console.error('❌ Error deleting from R2:', error);
    throw new Error('Failed to delete file from storage');
  }
};

module.exports = {
  uploadToR2,
  deleteFromR2,
};