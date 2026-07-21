'use strict';
const purchaseService = require('./purchase.service');
const { successResponse } = require('../../utils/response');

const buyItem = async (req, res) => {
  const result = await purchaseService.purchaseItem(req.user.userId, req.params.itemId);
  res.status(200).json(successResponse(result, 200, 'Item purchased successfully'));
};

module.exports = {
  buyItem,
};
