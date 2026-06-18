'use strict';
const { z } = require('zod');

const createSessionSchema = z.object({
  animalId: z.string().uuid('Invalid animal ID format'),
  modelId: z.string().uuid('Invalid model ID format'),
  predictionLabel: z.string().min(1, 'Prediction label is required'),
  confidenceScore: z.number().min(0).max(1),
  gameScore: z.number().int().min(0),
  focusScore: z.number().min(0).max(1).optional(),
  drawingDuration: z.number().int().positive('Duration must be positive in seconds/ms'),
  startedAt: z.string().datetime('Must be a valid ISO datetime string'),
});

module.exports = {
  createSessionSchema,
};
