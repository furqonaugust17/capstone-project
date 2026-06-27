'use strict';
const prisma = require('../../config/database');
const { uploadToR2, deleteFromR2 } = require('../../utils/cloudflare');
const { env } = require('../../config/env');
const path = require('path');

const getAllShopItems = async (page = 1, limit = 10, category, rarity, includeInactive = false) => {
  const skip = (page - 1) * limit;
  const where = {};
  if (!includeInactive) where.isActive = true;
  if (category) where.category = category;
  if (rarity) where.rarity = rarity;

  const [total, data] = await Promise.all([
    prisma.shopItem.count({ where }),
    prisma.shopItem.findMany({
      where,
      orderBy: { createdAt: 'desc' },
      skip,
      take: limit,
    })
  ]);

  return { data, meta: { total, page, limit, totalPages: Math.ceil(total / limit) } };
};

const getShopItemById = async (id, includeInactive = false) => {
  const item = await prisma.shopItem.findUnique({
    where: { id },
  });

  if (!item || (!includeInactive && !item.isActive)) {
    const error = new Error('Shop item not found');
    error.statusCode = 404;
    throw error;
  }

  return item;
};

const createShopItem = async (data, file) => {
  let imageUrl = null;

  if (file) {
    const ext = path.extname(file.originalname);
    const key = `shop/${Date.now()}${ext}`;
    imageUrl = await uploadToR2(file.buffer, key, file.mimetype);
  }

  const newItem = await prisma.shopItem.create({
    data: {
      name: data.name,
      description: data.description,
      price: data.price,
      category: data.category,
      rarity: data.rarity,
      imageUrl,
    },
  });

  return newItem;
};

const updateShopItem = async (id, data, file) => {
  const item = await prisma.shopItem.findUnique({ where: { id } });
  if (!item) {
    const error = new Error('Shop item not found');
    error.statusCode = 404;
    throw error;
  }

  let imageUrl = item.imageUrl;

  if (file) {
    if (imageUrl) {
      const oldKey = imageUrl.replace(`${env.R2_PUBLIC_URL}/`, '');
      await deleteFromR2(oldKey).catch(() => { });
    }

    const ext = path.extname(file.originalname);
    const key = `shop/${id}${ext}`;
    imageUrl = await uploadToR2(file.buffer, key, file.mimetype);
  }

  const updatedItem = await prisma.shopItem.update({
    where: { id },
    data: {
      ...data,
      imageUrl,
    },
  });

  return updatedItem;
};

const deleteShopItem = async (id) => {
  const item = await prisma.shopItem.findUnique({ where: { id } });
  if (!item) {
    const error = new Error('Shop item not found');
    error.statusCode = 404;
    throw error;
  }

  await prisma.shopItem.update({
    where: { id },
    data: { isActive: false },
  });
};

module.exports = {
  getAllShopItems,
  getShopItemById,
  createShopItem,
  updateShopItem,
  deleteShopItem,
};
