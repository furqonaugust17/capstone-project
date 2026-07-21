'use strict';

const { z } = require('zod');

const equipSchema = z.object({
  item_id: z.string().uuid('Invalid item ID format'),
  category: z.string().transform(val => val.toLowerCase()).pipe(z.enum(['avatar', 'frame', 'theme'], {
    errorMap: () => ({ message: 'Category must be one of: avatar, frame, theme' })
  }))
});

const unequipSchema = z.object({
  category: z.string().transform(val => val.toLowerCase()).pipe(z.enum(['avatar', 'frame', 'theme'], {
    errorMap: () => ({ message: 'Category must be one of: avatar, frame, theme' })
  }))
});

module.exports = {
  equipSchema,
  unequipSchema,
};
