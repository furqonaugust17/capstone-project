'use strict';
const { z } = require('zod');

const createAnimalSchema = z.object({
  name: z.string().min(1, 'Name is required').max(100),
  description: z.string().max(1000).optional(),
});

const updateAnimalSchema = z.object({
  name: z.string().min(1).max(100).optional(),
  description: z.string().max(1000).optional(),
  isActive: z.union([z.boolean(), z.string().transform(val => val === 'true')]).optional(),
});

module.exports = {
  createAnimalSchema,
  updateAnimalSchema,
};
