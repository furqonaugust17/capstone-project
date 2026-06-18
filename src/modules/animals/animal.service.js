'use strict';
const prisma = require('../../config/database');
const { uploadToR2, deleteFromR2 } = require('../../utils/cloudflare');
const { env } = require('../../config/env');
const path = require('path');

const getAllAnimals = async (page = 1, limit = 10) => {
  const skip = (page - 1) * limit;
  const [total, data] = await Promise.all([
    prisma.animal.count({ where: { isActive: true } }),
    prisma.animal.findMany({
      where: { isActive: true },
      orderBy: { createdAt: 'desc' },
      skip,
      take: limit,
    })
  ]);
  
  return {
    data,
    meta: { total, page, limit, totalPages: Math.ceil(total / limit) }
  };
};

const getAnimalById = async (id) => {
  const animal = await prisma.animal.findUnique({
    where: { id },
  });

  if (!animal || !animal.isActive) {
    const error = new Error('Animal not found');
    error.statusCode = 404;
    throw error;
  }

  return animal;
};

const createAnimal = async (data, files) => {
  let newAnimal = await prisma.animal.create({
    data: {
      name: data.name,
      description: data.description,
    },
  });

  let thumbnailUrl = null;
  let hintImageUrl = null;
  let shouldUpdate = false;

  if (files && files.thumbnail && files.thumbnail.length > 0) {
    const file = files.thumbnail[0];
    const ext = path.extname(file.originalname);
    const key = `animals/thumbnails/${newAnimal.id}${ext}`;
    thumbnailUrl = await uploadToR2(file.buffer, key, file.mimetype);
    shouldUpdate = true;
  }

  if (files && files.hintImage && files.hintImage.length > 0) {
    const file = files.hintImage[0];
    const ext = path.extname(file.originalname);
    const key = `animals/hints/${newAnimal.id}${ext}`;
    hintImageUrl = await uploadToR2(file.buffer, key, file.mimetype);
    shouldUpdate = true;
  }

  if (shouldUpdate) {
    newAnimal = await prisma.animal.update({
      where: { id: newAnimal.id },
      data: {
        thumbnailUrl,
        hintImageUrl,
      },
    });
  }

  return newAnimal;
};

const updateAnimal = async (id, data, files) => {
  const animal = await prisma.animal.findUnique({ where: { id } });
  if (!animal) {
    const error = new Error('Animal not found');
    error.statusCode = 404;
    throw error;
  }

  let thumbnailUrl = animal.thumbnailUrl;
  let hintImageUrl = animal.hintImageUrl;

  if (files && files.thumbnail && files.thumbnail.length > 0) {
    if (thumbnailUrl) {
      const oldKey = thumbnailUrl.replace(`${env.R2_PUBLIC_URL}/`, '');
      await deleteFromR2(oldKey).catch(() => {});
    }
    const file = files.thumbnail[0];
    const ext = path.extname(file.originalname);
    const key = `animals/thumbnails/${id}${ext}`;
    thumbnailUrl = await uploadToR2(file.buffer, key, file.mimetype);
  }

  if (files && files.hintImage && files.hintImage.length > 0) {
    if (hintImageUrl) {
      const oldKey = hintImageUrl.replace(`${env.R2_PUBLIC_URL}/`, '');
      await deleteFromR2(oldKey).catch(() => {});
    }
    const file = files.hintImage[0];
    const ext = path.extname(file.originalname);
    const key = `animals/hints/${id}${ext}`;
    hintImageUrl = await uploadToR2(file.buffer, key, file.mimetype);
  }

  const updatedAnimal = await prisma.animal.update({
    where: { id },
    data: {
      ...data,
      thumbnailUrl,
      hintImageUrl,
    },
  });

  return updatedAnimal;
};

const deleteAnimal = async (id) => {
  const animal = await prisma.animal.findUnique({ where: { id } });
  if (!animal) {
    const error = new Error('Animal not found');
    error.statusCode = 404;
    throw error;
  }

  await prisma.animal.update({
    where: { id },
    data: { isActive: false },
  });
};

module.exports = {
  getAllAnimals,
  getAnimalById,
  createAnimal,
  updateAnimal,
  deleteAnimal,
};
