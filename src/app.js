'use strict';

const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const morgan = require('morgan');
const errorHandler = require('./middlewares/error.middleware');
const logger = require('./utils/logger');
const { env } = require('./config/env');
const fs = require('fs');
const path = require('path');

const app = express();

// Security Middlewares
app.use(helmet());

// CORS whitelist setup
const allowedOrigins = env.NODE_ENV === 'production' 
  ? ['https://bima.example.com', 'https://admin.bima.example.com'] 
  : ['http://localhost:5173', 'http://localhost:3000', '*']; // adjust local origins

app.use(cors({
  origin: function (origin, callback) {
    if (!origin || allowedOrigins.includes(origin) || allowedOrigins.includes('*')) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  }
}));

// Rate Limiting
const globalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per `window` (here, per 15 minutes)
  message: { success: false, message: 'Too many requests from this IP, please try again after 15 minutes' }
});

const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 10, // Limit each IP to 10 login/register requests per window
  message: { success: false, message: 'Too many login attempts from this IP, please try again after 15 minutes' }
});

app.use('/api/', globalLimiter);
app.use('/api/auth/login', authLimiter);
app.use('/api/auth/register', authLimiter);

// Logging
// Stream morgan logs to winston
const morganStream = {
  write: (message) => logger.info(message.trim())
};
if (env.NODE_ENV === 'production') {
  app.use(morgan('combined', { stream: morganStream }));
} else {
  app.use(morgan('dev', { stream: morganStream }));
}

// Body parsers
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const swaggerUi = require('swagger-ui-express');
const swaggerSpec = require('./config/swagger');

// Mount Swagger
app.use('/api/docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));
app.get('/api/docs.json', (req, res) => {
  res.setHeader('Content-Type', 'application/json');
  res.send(swaggerSpec);
});

// Health check route
app.get('/api/health', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Server is healthy',
    timestamp: new Date().toISOString()
  });
});

const authRoutes = require('./modules/auth/auth.routes');
const animalRoutes = require('./modules/animals/animal.routes');
const mlModelRoutes = require('./modules/ml-models/mlmodel.routes');
const gameSessionRoutes = require('./modules/game-sessions/gamesession.routes');
const statisticsRoutes = require('./modules/statistics/statistics.routes');
const userRoutes = require('./modules/users/user.routes');

const shopRoutes = require('./modules/shop/shop.routes');
const purchaseRoutes = require('./modules/purchase/purchase.routes');
const inventoryRoutes = require('./modules/inventory/inventory.routes');
const leaderboardRoutes = require('./modules/leaderboard/leaderboard.routes');
const analyticsRoutes = require('./modules/analytics/analytics.routes');

// Mount routes
app.use('/api/auth', authRoutes);
app.use('/api/animals', animalRoutes);
app.use('/api/ml-models', mlModelRoutes);
app.use('/api/game-sessions', gameSessionRoutes);
app.use('/api/statistics', statisticsRoutes);
app.use('/api/users', userRoutes);

app.use('/api/shop', shopRoutes);
app.use('/api/purchase', purchaseRoutes);
app.use('/api/inventory', inventoryRoutes);
app.use('/api/leaderboards', leaderboardRoutes);
app.use('/api/analytics', analyticsRoutes);

// 404 Route
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'API Route Not Found'
  });
});

// Global Error Handler
app.use(errorHandler);

// Initialize Cron Jobs
require('./jobs/cron');

module.exports = app;
