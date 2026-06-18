'use strict';
const leaderboardService = require('./leaderboard.service');
const { successResponse } = require('../../utils/response');

const getLive = async (req, res) => {
  const limit = parseInt(req.query.limit) || 100;
  const result = await leaderboardService.getLiveLeaderboard(limit);
  res.status(200).json(successResponse(result, 200, 'Live leaderboard fetched successfully'));
};

const getSnapshot = async (req, res) => {
  const { period, periodLabel } = req.query;
  if (!period || !periodLabel) {
    const error = new Error('period and periodLabel query parameters are required');
    error.statusCode = 400;
    throw error;
  }
  const result = await leaderboardService.getSnapshotLeaderboard(period, periodLabel);
  res.status(200).json(successResponse(result, 200, 'Leaderboard snapshot fetched successfully'));
};

const generateSnapshot = async (req, res) => {
  const { period, periodLabel, limit } = req.body;
  if (!period || !periodLabel) {
    const error = new Error('period and periodLabel body parameters are required');
    error.statusCode = 400;
    throw error;
  }
  const result = await leaderboardService.generateSnapshot(period, periodLabel, limit);
  res.status(201).json(successResponse(result, 201, 'Leaderboard snapshot generated successfully'));
};

const getMyRank = async (req, res) => {
  const result = await leaderboardService.getMyRank(req.user.userId);
  res.status(200).json(successResponse(result, 200, 'My rank fetched successfully'));
};

module.exports = {
  getLive,
  getSnapshot,
  generateSnapshot,
  getMyRank,
};
