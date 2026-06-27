'use strict';
const mlModelService = require('./mlmodel.service');
const { createModelSchema } = require('./mlmodel.validation');
const { successResponse } = require('../../utils/response');
const { clearCache } = require('../../config/redis');

const index = async (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 10;
  const result = await mlModelService.getAllModels(page, limit);
  res.status(200).json(successResponse(result, 200, 'ML Models fetched successfully'));
};

const show = async (req, res) => {
  const model = await mlModelService.getModelById(req.params.id);
  res.status(200).json(successResponse(model, 200, 'ML Model fetched successfully'));
};

const active = async (req, res) => {
  const model = await mlModelService.getActiveModel();
  res.status(200).json(successResponse(model, 200, 'Active ML Model fetched successfully'));
};

const store = async (req, res) => {
  const data = createModelSchema.parse(req.body);
  const model = await mlModelService.createModel(data, req.file);
  res.status(201).json(successResponse(model, 201, 'ML Model created successfully'));
};

const activate = async (req, res) => {
  const model = await mlModelService.activateModel(req.params.id);
  await clearCache('ml-models:*');
  res.status(200).json(successResponse(model, 200, 'ML Model activated successfully'));
};

const destroy = async (req, res) => {
  await mlModelService.deleteModel(req.params.id);
  await clearCache('ml-models:*');
  res.status(200).json(successResponse(null, 200, 'ML Model deleted successfully'));
};

const update = async (req, res) => {
  const { updateModelSchema } = require('./mlmodel.validation');
  const data = updateModelSchema.parse(req.body);
  const model = await mlModelService.updateModel(req.params.id, data, req.file);
  await clearCache('ml-models:*');
  res.status(200).json(successResponse(model, 200, 'ML Model updated successfully'));
};


const history = async (req, res) => {
  const models = await mlModelService.getModelHistory(req.params.id);
  res.status(200).json(successResponse(models, 200, 'ML Model history fetched successfully'));
};

const rollback = async (req, res) => {
  const model = await mlModelService.activateModel(req.params.id);
  await clearCache('ml-models:*');
  res.status(200).json(successResponse(model, 200, 'ML Model rolled back successfully'));
};

module.exports = {
  index,
  show,
  active,
  store,
  activate,
  destroy,
  update,
  history,
  rollback,
};
