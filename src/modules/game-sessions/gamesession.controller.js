'use strict';
const gameSessionService = require('./gamesession.service');
const { createSessionSchema } = require('./gamesession.validation');
const { successResponse } = require('../../utils/response');

const index = async (req, res) => {
  const userId = req.user.userId;
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 10;
  const result = await gameSessionService.getMySessions(userId, page, limit);
  res.status(200).json(successResponse(result, 200, 'Game sessions fetched successfully'));
};

const show = async (req, res) => {
  const userId = req.user.userId;
  const session = await gameSessionService.getSessionById(req.params.id, userId);
  res.status(200).json(successResponse(session, 200, 'Game session fetched successfully'));
};

const store = async (req, res) => {
  const userId = req.user.userId;
  const data = createSessionSchema.parse(req.body);
  const session = await gameSessionService.createSession(userId, data, req.file);
  res.status(201).json(successResponse(session, 201, 'Game session created successfully'));
};

module.exports = {
  index,
  show,
  store,
};
