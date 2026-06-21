'use strict';

const admin = require('firebase-admin');
const { env } = require('./env');
const logger = require('../utils/logger');

let firebaseApp;

function initFirebase() {
  if (firebaseApp) return firebaseApp;

  try {
    if (env.FIREBASE_SERVICE_ACCOUNT_PATH) {
      // Initialize using service account JSON file
      firebaseApp = admin.initializeApp({
        credential: admin.credential.cert(env.FIREBASE_SERVICE_ACCOUNT_PATH),
      });
    } else if (env.FIREBASE_PROJECT_ID && env.FIREBASE_CLIENT_EMAIL && env.FIREBASE_PRIVATE_KEY) {
      // Initialize using individual credentials
      firebaseApp = admin.initializeApp({
        credential: admin.credential.cert({
          projectId: env.FIREBASE_PROJECT_ID,
          clientEmail: env.FIREBASE_CLIENT_EMAIL,
          privateKey: env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n'),
        }),
      });
    } else {
      logger.warn('⚠️ Firebase Admin SDK not configured. ML Model deployment will be unavailable.');
    }
  } catch (error) {
    logger.error('❌ Firebase Admin SDK Initialization Error:', error);
  }

  return firebaseApp;
}

module.exports = {
  firebaseAdmin: initFirebase(),
};
