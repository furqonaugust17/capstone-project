const winston = require('winston');
const fs = require('fs');
const path = require('path');
const { env } = require('../config/env');

// Konfigurasi format
const { combine, timestamp, printf, colorize, errors } = winston.format;

const logFormat = printf(({ level, message, timestamp, stack }) => {
  return `${timestamp} ${level}: ${stack || message}`;
});

const logger = winston.createLogger({
  level: env.NODE_ENV === 'production' ? 'info' : 'debug',
  format: combine(
    timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
    errors({ stack: true }),
    logFormat
  ),
  transports: [
    // Error log file
    new winston.transports.File({
      level: 'error',
    }),
    // Combined log file
    new winston.transports.File({
      level: 'info'
    }),
  ],
});

// Jika tidak di production, log ke console juga dengan warna
if (env.NODE_ENV !== 'production') {
  logger.add(
    new winston.transports.Console({
      format: combine(
        colorize(),
        timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
        logFormat
      ),
    })
  );
}

module.exports = logger;
