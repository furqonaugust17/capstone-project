'use strict';

const authService = require('./auth.service');
const { registerSchema, loginSchema, refreshSchema } = require('./auth.validation');
const { successResponse } = require('../../utils/response');

const register = async (req, res) => {
  const data = registerSchema.parse(req.body);
  const user = await authService.register(data);
  res.status(201).json(successResponse(user, 201, 'User registered successfully'));
};

const login = async (req, res) => {
  const data = loginSchema.parse(req.body);
  const result = await authService.login(data.email, data.password);
  res.status(200).json(successResponse(result, 200, 'Login successful'));
};

const refresh = async (req, res) => {
  const data = refreshSchema.parse(req.body);
  const result = await authService.refreshToken(data.refreshToken);
  res.status(200).json(successResponse(result, 200, 'Token refreshed successfully'));
};

const logout = async (req, res) => {
  const data = refreshSchema.parse(req.body);
  await authService.logout(data.refreshToken);
  res.status(200).json(successResponse(null, 200, 'Logout successful'));
};

const me = async (req, res) => {
  const userId = req.user.userId;
  const user = await authService.getMe(userId);
  res.status(200).json(successResponse(user, 200, 'User profile fetched successfully'));
};

module.exports = {
  register,
  login,
  refresh,
  logout,
  me,
};
