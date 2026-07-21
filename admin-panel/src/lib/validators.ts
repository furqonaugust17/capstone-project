import { z } from 'zod';

export const animalSchema = z.object({
  name: z.string().min(1, 'Nama wajib diisi'),
  description: z.string().min(1, 'Deskripsi wajib diisi'),
  thumbnail_url: z.string().url('Harus berupa URL yang valid').nullable().optional(),
  hint_image_url: z.string().url('Harus berupa URL yang valid').nullable().optional(),
  difficulty: z.enum(['Easy', 'Medium', 'Hard']),
  is_active: z.boolean().default(true),
});

export const modelSchema = z.object({
  name: z.string().min(1, 'Nama wajib diisi'),
  version: z.string().min(1, 'Versi wajib diisi'),
  file_url: z.string().url('Harus berupa URL yang valid'),
  labels_url: z.string().url('Harus berupa URL yang valid'),
  input_size: z.string().min(1, 'Ukuran input wajib diisi'),
  framework: z.string().min(1, 'Framework wajib diisi'),
  accuracy: z.number().min(0).max(100),
  is_active: z.boolean().default(true),
});

export const shopItemCategoryEnum = z.enum(['AVATAR', 'FRAME', 'STICKER', 'THEME']);
export const shopItemRarityEnum = z.enum(['COMMON', 'RARE', 'EPIC', 'LEGENDARY']);

export const shopItemFormSchema = z.object({
  name: z.string().min(2, 'Nama minimal 2 karakter').max(100),
  description: z.string().optional().or(z.literal('')),
  price: z.number().min(1, 'Harga minimal 1'),
  category: shopItemCategoryEnum,
  rarity: shopItemRarityEnum,
  file: z.any().optional(),
  isActive: z.boolean(),
});

export type ShopItemFormValues = z.infer<typeof shopItemFormSchema>;

