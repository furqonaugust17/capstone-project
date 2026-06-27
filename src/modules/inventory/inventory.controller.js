'use strict';
const inventoryService = require('./inventory.service');
const { successResponse } = require('../../utils/response');
const { equipSchema, unequipSchema } = require('./inventory.validation');

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

const equip = async (req, res) => {
  const data = equipSchema.parse(req.body);
  const result = await inventoryService.equipItem(req.user.userId, data.item_id, data.category);
  res.status(200).json(successResponse(result, 200, 'Item equipped successfully'));
};

const unequip = async (req, res) => {
  const data = unequipSchema.parse(req.body);
  const result = await inventoryService.unequipItem(req.user.userId, data.category);
  res.status(200).json(successResponse(result, 200, 'Item unequiped successfully'));
};

module.exports = {
  myInventory,
  myHistory,
  equip,
  unequip,
};
