'use strict';
const relationshipService = require('./relationship.service');
const { successResponse } = require('../../utils/response');

const index = async (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 10;
  const search = req.query.search || '';
  const result = await relationshipService.getRelationships(page, limit, search);
  res.status(200).json(successResponse(result, 200, 'Relationships fetched successfully'));
};

const store = async (req, res) => {
  // Support both camelCase and snake_case mapping from frontend
  const animalId = req.body.animalId || req.body.animal_id;
  const modelId = req.body.modelId || req.body.model_id;
  
  if (!animalId || !modelId) {
    return res.status(400).json({ success: false, message: "animalId and modelId are required" });
  }

  const result = await relationshipService.createRelationship({ animalId, modelId });
  res.status(201).json(successResponse(result, 201, 'Relationship created successfully'));
};

const bulkAssign = async (req, res) => {
  const modelId = req.body.modelId || req.body.model_id;
  const animalIds = req.body.animalIds || req.body.animal_ids;
  
  if (!modelId || !Array.isArray(animalIds)) {
    return res.status(400).json({ success: false, message: "modelId and animalIds array are required" });
  }

  await relationshipService.bulkAssign({ modelId, animalIds });
  res.status(200).json(successResponse(null, 200, 'Bulk assign successful'));
};

const destroy = async (req, res) => {
  await relationshipService.deleteRelationship(req.params.id);
  res.status(200).json(successResponse(null, 200, 'Relationship deleted successfully'));
};

module.exports = {
  index,
  store,
  bulkAssign,
  destroy,
};
