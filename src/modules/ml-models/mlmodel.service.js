'use strict';
const prisma = require('../../config/database');
const { uploadToR2, deleteFromR2 } = require('../../utils/cloudflare');
const { env } = require('../../config/env');
const path = require('path');

const getAllModels = async (page = 1, limit = 10) => {
  const skip = (page - 1) * limit;
  const [total, data] = await Promise.all([
    prisma.mLModel.count(),
    prisma.mLModel.findMany({
      orderBy: { createdAt: 'desc' },
      skip,
      take: limit,
      include: {
        animalModels: {
          include: { animal: true }
        }
      }
    })
  ]);
  return { data, meta: { total, page, limit, totalPages: Math.ceil(total / limit) } };
};

const getActiveModel = async () => {
  const model = await prisma.mLModel.findFirst({
    where: { isActive: true },
    include: {
      animalModels: {
        include: { animal: true }
      }
    }
  });

  if (!model) {
    const error = new Error('No active ML model found');
    error.statusCode = 404;
    throw error;
  }

  return model;
};

const createModel = async (data, file) => {
  if (!file) {
    const error = new Error('TFLite model file is required');
    error.statusCode = 400;
    throw error;
  }

  const ext = path.extname(file.originalname);
  const key = `models/${data.name}-v${data.version}${ext}`;

  // Upload to R2
  const fileUrl = await uploadToR2(file.buffer, key, file.mimetype);

  const newModel = await prisma.mLModel.create({
    data: {
      name: data.name,
      version: data.version,
      inputSize: data.inputSize,
      accuracy: data.accuracy,
      fileUrl,
      firebaseModelName: null,
      isActive: false, // Default to false until activated
    },
  });

  return newModel;
};

const activateModel = async (id) => {
  const model = await prisma.mLModel.findUnique({ where: { id } });
  if (!model) {
    const error = new Error('ML Model not found');
    error.statusCode = 404;
    throw error;
  }

  // Transaction to deactivate all and activate target
  await prisma.$transaction([
    prisma.mLModel.updateMany({
      where: { isActive: true },
      data: { isActive: false },
    }),
    prisma.mLModel.update({
      where: { id },
      data: { isActive: true },
    }),
  ]);

  return await prisma.mLModel.findUnique({ where: { id } });
};

const deleteModel = async (id) => {
  const model = await prisma.mLModel.findUnique({ where: { id } });
  if (!model) {
    const error = new Error('ML Model not found');
    error.statusCode = 404;
    throw error;
  }

  await prisma.mLModel.update({
    where: { id },
    data: { isActive: false },
  });
};

const syncAnimals = async (modelId, animalIds) => {
  const model = await prisma.mLModel.findUnique({ where: { id: modelId } });
  if (!model) {
    const error = new Error('ML Model not found');
    error.statusCode = 404;
    throw error;
  }

  await prisma.$transaction(async (tx) => {
    await tx.animalModel.deleteMany({
      where: { modelId },
    });

    if (animalIds && animalIds.length > 0) {
      const dataToInsert = animalIds.map((animalId) => ({
        modelId,
        animalId,
      }));
      await tx.animalModel.createMany({
        data: dataToInsert,
      });
    }
  });

  return await prisma.animalModel.findMany({
    where: { modelId },
    include: { animal: true },
  });
};

const updateModel = async (id, data, file) => {
  const model = await prisma.mLModel.findUnique({ where: { id } });
  if (!model) {
    const error = new Error('ML Model not found');
    error.statusCode = 404;
    throw error;
  }

  let fileUrl = model.fileUrl;

  if (file) {
    if (fileUrl) {
      const oldKey = fileUrl.replace(`${env.R2_PUBLIC_URL}/`, '');
      await deleteFromR2(oldKey).catch(() => { });
    }

    const ext = path.extname(file.originalname);
    const key = `models/${data.name || model.name}-v${data.version || model.version}${ext}`;
    fileUrl = await uploadToR2(file.buffer, key, file.mimetype);
  }

  if (data.isActive === true) {
    await prisma.mLModel.updateMany({
      where: { isActive: true },
      data: { isActive: false }
    });
  }

  const updatedModel = await prisma.mLModel.update({
    where: { id },
    data: {
      ...data,
      fileUrl,
    },
  });

  return updatedModel;
};

const getModelById = async (id) => {
  const model = await prisma.mLModel.findUnique({ where: { id } });
  if (!model) {
    const error = new Error('ML Model not found');
    error.statusCode = 404;
    throw error;
  }

  return model;
};

module.exports = {
  getAllModels,
  getActiveModel,
  createModel,
  activateModel,
  deleteModel,
  syncAnimals,
  updateModel,
  getModelById
};
