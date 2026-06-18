'use strict';
const prisma = require('../../config/database');

const getRelationships = async (page = 1, limit = 10, search = '') => {
  const skip = (page - 1) * limit;
  
  const where = {
    OR: search ? [
      { animal: { name: { contains: search, mode: 'insensitive' } } },
      { model: { name: { contains: search, mode: 'insensitive' } } }
    ] : undefined
  };

  const [total, data] = await Promise.all([
    prisma.animalModel.count({ where }),
    prisma.animalModel.findMany({
      where,
      include: {
        animal: true,
        model: true,
      },
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

const createRelationship = async (data) => {
  const { animalId, modelId } = data;
  return await prisma.animalModel.create({
    data: {
      animalId,
      modelId,
    },
    include: {
      animal: true,
      model: true,
    }
  });
};

const bulkAssign = async (data) => {
  const { modelId, animalIds } = data;
  
  await prisma.$transaction(async (tx) => {
    if (animalIds && animalIds.length > 0) {
      const dataToInsert = animalIds.map((animalId) => ({
        modelId,
        animalId,
      }));
      // Using skipDuplicates to ignore if the relationship already exists
      await tx.animalModel.createMany({
        data: dataToInsert,
        skipDuplicates: true,
      });
    }
  });
};

const deleteRelationship = async (id) => {
  await prisma.animalModel.delete({
    where: { id }
  });
};

module.exports = {
  getRelationships,
  createRelationship,
  bulkAssign,
  deleteRelationship,
};
