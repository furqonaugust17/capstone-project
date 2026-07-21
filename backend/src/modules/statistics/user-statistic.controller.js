'use strict';
const userStatisticService = require('./user-statistic.service');
const { successResponse } = require('../../utils/response');

const myStatistic = async (req, res) => {
  const stat = await userStatisticService.getUserStatistic(req.user.userId);
  res.status(200).json(successResponse(stat, 200, 'User statistics fetched successfully'));
};

module.exports = {
  myStatistic,
};
