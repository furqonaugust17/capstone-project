'use strict';
const achievementService = require('./achievement.service');
const { successResponse } = require('../../utils/response');

const listAll = async (req, res) => {
  const achievements = await achievementService.getAllAchievements();
  res.status(200).json(successResponse(achievements, 200, 'All achievements fetched successfully'));
};

const listMy = async (req, res) => {
  const myAchievements = await achievementService.getMyAchievements(req.user.userId);
  res.status(200).json(successResponse(myAchievements, 200, 'My achievements fetched successfully'));
};

const store = async (req, res) => {
  const { createAchievementSchema } = require('./achievement.validation');
  const data = createAchievementSchema.parse(req.body);
  const result = await achievementService.createAchievement(data, req.file);
  res.status(201).json(successResponse(result, 201, 'Achievement created successfully'));
};

const update = async (req, res) => {
  const { updateAchievementSchema } = require('./achievement.validation');
  const data = updateAchievementSchema.parse(req.body);
  const result = await achievementService.updateAchievement(req.params.id, data, req.file);
  res.status(200).json(successResponse(result, 200, 'Achievement updated successfully'));
};

const destroy = async (req, res) => {
  await achievementService.deleteAchievement(req.params.id);
  res.status(200).json(successResponse(null, 200, 'Achievement deleted successfully'));
};

module.exports = {
  listAll,
  listMy,
  store,
  update,
  destroy,
};
