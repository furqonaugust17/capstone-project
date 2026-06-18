'use strict';
const userService = require('./user.service');
const { successResponse } = require('../../utils/response');

const index = async (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 10;
  const search = req.query.search || '';

  const result = await userService.getAllUsers(page, limit, search);
  res.status(200).json(successResponse(result, 200, 'Users fetched successfully'));
};

const show = async (req, res) => {
  const user = await userService.getUserById(req.params.id)
  res.status(200).json(successResponse(user, 200, 'User fetched successfully'))
}

const destroy = async (req, res) => {
  await userService.deleteUser(req.params.id);
  res.status(200).json(successResponse(null, 200, 'User deleted successfully'));
};

module.exports = {
  index,
  show,
  destroy,
};
