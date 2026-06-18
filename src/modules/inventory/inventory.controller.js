'use strict';
const inventoryService = require('./inventory.service');
const { successResponse } = require('../../utils/response');

const myInventory = async (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 10;
  const result = await inventoryService.getMyInventory(req.user.userId, page, limit);
  res.status(200).json(successResponse(result, 200, 'User inventory fetched successfully'));
};

const myHistory = async (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 10;
  const result = await inventoryService.getPurchaseHistory(req.user.userId, page, limit);
  res.status(200).json(successResponse(result, 200, 'Purchase history fetched successfully'));
};

module.exports = {
  myInventory,
  myHistory,
};
