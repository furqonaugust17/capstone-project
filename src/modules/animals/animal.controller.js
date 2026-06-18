'use strict';
const animalService = require('./animal.service');
const { createAnimalSchema, updateAnimalSchema } = require('./animal.validation');
const { successResponse } = require('../../utils/response');

const index = async (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 10;
  const result = await animalService.getAllAnimals(page, limit);
  res.status(200).json(successResponse(result, 200, 'Animals fetched successfully'));
};

const show = async (req, res) => {
  const animal = await animalService.getAnimalById(req.params.id);
  res.status(200).json(successResponse(animal, 200, 'Animal fetched successfully'));
};

const store = async (req, res) => {
  const data = createAnimalSchema.parse(req.body);
  const animal = await animalService.createAnimal(data, req.files);
  res.status(201).json(successResponse(animal, 201, 'Animal created successfully'));
};

const update = async (req, res) => {
  const data = updateAnimalSchema.parse(req.body);
  const animal = await animalService.updateAnimal(req.params.id, data, req.files);
  res.status(200).json(successResponse(animal, 200, 'Animal updated successfully'));
};

const destroy = async (req, res) => {
  await animalService.deleteAnimal(req.params.id);
  res.status(200).json(successResponse(null, 200, 'Animal deleted successfully'));
};

module.exports = {
  index,
  show,
  store,
  update,
  destroy,
};
