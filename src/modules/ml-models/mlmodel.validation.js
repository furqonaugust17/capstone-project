'use strict';
const { z } = require('zod');

const createModelSchema = z.object({
  name: z.string().min(1, 'Name is required').max(100),
  version: z.string().min(1, 'Version is required').max(50),
  inputSize: z.coerce.number().int().positive().optional(),
  accuracy: z.coerce.number().min(0).max(100).optional(),
});

const syncAnimalsSchema = z.object({
  animalIds: z.array(z.string().uuid()),
});

const updateModelSchema = z.object({
  name: z.string().min(1).max(100).optional(),
  version: z.string().min(1).max(50).optional(),
  inputSize: z.coerce.number().int().positive().optional(),
  accuracy: z.coerce.number().min(0).max(100).optional(),
  isActive: z.union([z.boolean(), z.string().transform((val) => val === 'true')]).optional(),
});

module.exports = {
  createModelSchema,
  syncAnimalsSchema,
  updateModelSchema,
};
