'use strict';
const { z } = require('zod');

const TriggerType = z.enum(['TOTAL_GAMES', 'TOTAL_SCORE', 'FOCUS_SCORE', 'SPECIFIC_ANIMAL']);

const createAchievementSchema = z.object({
  name: z.string().min(1).max(100),
  description: z.string().optional(),
  rewardPoint: z.coerce.number().int().nonnegative(),
  triggerType: TriggerType,
  triggerValue: z.coerce.number().int().nonnegative(),
});

const updateAchievementSchema = z.object({
  name: z.string().min(1).max(100).optional(),
  description: z.string().optional(),
  rewardPoint: z.coerce.number().int().nonnegative().optional(),
  triggerType: TriggerType.optional(),
  triggerValue: z.coerce.number().int().nonnegative().optional(),
  isActive: z.union([z.boolean(), z.string().transform((val) => val === 'true')]).optional(),
});

module.exports = {
  createAchievementSchema,
  updateAchievementSchema,
};
