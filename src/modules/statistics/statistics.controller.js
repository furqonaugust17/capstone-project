'use strict';
const statisticsService = require('./statistics.service');
const { successResponse } = require('../../utils/response');

const overview = async (req, res) => {
  const result = await statisticsService.getOverview();
  res.status(200).json(successResponse(result, 200, 'Overview statistics fetched successfully'));
};

const charts = async (req, res) => {
  const result = await statisticsService.getChartsData();
  res.status(200).json(successResponse(result, 200, 'Chart statistics fetched successfully'));
};

const detailed = async (req, res) => {
  const result = await statisticsService.getDetailedStatistics();
  res.status(200).json(successResponse(result, 200, 'Detailed statistics fetched successfully'));
};

module.exports = {
  overview,
  charts,
  detailed,
};
