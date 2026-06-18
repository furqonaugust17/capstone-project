'use strict';
const { z } = require('zod');

const ItemCategory = z.enum(['AVATAR', 'FRAME', 'STICKER', 'THEME']);
const ItemRarity = z.enum(['COMMON', 'RARE', 'EPIC', 'LEGENDARY']);

const createShopItemSchema = z.object({
  name: z.string().min(1, 'Name is required').max(100),
  description: z.string().optional(),
  price: z.coerce.number().int().positive('Price must be a positive integer'),
  category: ItemCategory,
  rarity: ItemRarity,
});

const updateShopItemSchema = z.object({
  name: z.string().min(1).max(100).optional(),
  description: z.string().optional(),
  price: z.coerce.number().int().positive().optional(),
  category: ItemCategory.optional(),
  rarity: ItemRarity.optional(),
  isActive: z.union([z.boolean(), z.string().transform((val) => val === 'true')]).optional(),
});

module.exports = {
  createShopItemSchema,
  updateShopItemSchema,
};
