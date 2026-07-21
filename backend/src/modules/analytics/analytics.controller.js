'use strict';
const analyticsService = require('./analytics.service');
const { successResponse } = require('../../utils/response');

const overview = async (req, res) => {
  const result = await analyticsService.getOverview();
  res.status(200).json(successResponse(result, 200, 'Analytics overview fetched successfully'));
};

const animals = async (req, res) => {
  const result = await analyticsService.getAnimalsAnalytics();
  res.status(200).json(successResponse(result, 200, 'Animals analytics fetched successfully'));
};

const focus = async (req, res) => {
  const result = await analyticsService.getFocusDistribution();
  res.status(200).json(successResponse(result, 200, 'Focus distribution fetched successfully'));
};

const userStats = async (req, res) => {
  const result = await analyticsService.getUserAnalytics(req.params.id);
  res.status(200).json(successResponse(result, 200, 'User analytics fetched successfully'));
};

const recommendations = async (req, res) => {
  const limit = parseInt(req.query.limit) || 3;
  const result = await analyticsService.getRecommendations(req.user.userId, limit);
  res.status(200).json(successResponse(result, 200, 'Recommendations fetched successfully'));
};

module.exports = {
  overview,
  animals,
  focus,
  userStats,
  recommendations,
};
