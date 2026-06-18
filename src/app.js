'use strict';

const express = require('express');
const cors = require('cors');
const errorHandler = require('./middlewares/error.middleware');

const app = express();

// Global Middlewares
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

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
const relationshipRoutes = require('./modules/relationships/relationship.routes');
const shopRoutes = require('./modules/shop/shop.routes');
const purchaseRoutes = require('./modules/purchase/purchase.routes');
const inventoryRoutes = require('./modules/inventory/inventory.routes');
const achievementRoutes = require('./modules/achievements/achievement.routes');

// Mount routes
app.use('/api/auth', authRoutes);
app.use('/api/animals', animalRoutes);
app.use('/api/ml-models', mlModelRoutes);
app.use('/api/game-sessions', gameSessionRoutes);
app.use('/api/statistics', statisticsRoutes);
app.use('/api/users', userRoutes);
app.use('/api/relationships', relationshipRoutes);
app.use('/api/shop', shopRoutes);
app.use('/api/purchase', purchaseRoutes);
app.use('/api/inventory', inventoryRoutes);
app.use('/api/achievements', achievementRoutes);

// 404 Route
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'API Route Not Found'
  });
});

// Global Error Handler
app.use(errorHandler);

module.exports = app;
