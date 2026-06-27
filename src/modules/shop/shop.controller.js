'use strict';
const shopService = require('./shop.service');
const { createShopItemSchema, updateShopItemSchema } = require('./shop.validation');
const { successResponse } = require('../../utils/response');

const index = async (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 10;
  const { category, rarity } = req.query;
  const includeInactive = req.user?.role === 'ADMIN';

  const result = await shopService.getAllShopItems(page, limit, category, rarity, includeInactive);
  res.status(200).json(successResponse(result, 200, 'Shop items fetched successfully'));
};

const show = async (req, res) => {
  const includeInactive = req.user?.role === 'ADMIN';
  const item = await shopService.getShopItemById(req.params.id, includeInactive);
  res.status(200).json(successResponse(item, 200, 'Shop item fetched successfully'));
};

const store = async (req, res) => {
  const data = createShopItemSchema.parse(req.body);
  const item = await shopService.createShopItem(data, req.file);
  res.status(201).json(successResponse(item, 201, 'Shop item created successfully'));
};

const update = async (req, res) => {
  const data = updateShopItemSchema.parse(req.body);
  const item = await shopService.updateShopItem(req.params.id, data, req.file);
  res.status(200).json(successResponse(item, 200, 'Shop item updated successfully'));
};

const destroy = async (req, res) => {
  await shopService.deleteShopItem(req.params.id);
  res.status(200).json(successResponse(null, 200, 'Shop item deleted successfully'));
};

module.exports = {
  index,
  show,
  store,
  update,
  destroy,
};
