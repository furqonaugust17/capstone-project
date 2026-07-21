'use strict';
const { z } = require('zod');

const createAnimalSchema = z.object({
  name: z.string().min(1, 'Name is required').max(100),
  description: z.string().max(1000).optional(),
  funFact: z.string().max(500).optional(),
  drawingTips: z.union([
    z.array(z.string().max(200)),
    z.string().max(200).transform(val => [val])
  ]).optional(),
  difficulty: z.enum(['easy', 'medium', 'hard']).optional().default('easy'),
});

const updateAnimalSchema = z.object({
  name: z.string().min(1).max(100).optional(),
  description: z.string().max(1000).optional(),
  funFact: z.string().max(500).optional(),
  drawingTips: z.union([
    z.array(z.string().max(200)),
    z.string().max(200).transform(val => [val])
  ]).optional(),
  difficulty: z.enum(['easy', 'medium', 'hard']).optional(),
  isActive: z.union([z.boolean(), z.string().transform(val => val === 'true')]).optional(),
});

module.exports = {
  createAnimalSchema,
  updateAnimalSchema,
};
