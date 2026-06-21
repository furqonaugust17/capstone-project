const relationshipService = require('../../src/modules/relationships/relationship.service');

describe('Relationship Service', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('createRelationship', () => {
    it('should create an animal-model relationship', async () => {
      prismaMock.animalModel.create.mockResolvedValue({ id: 'rel1', animalId: 'a1', modelId: 'm1' });

      const result = await relationshipService.createRelationship({ animalId: 'a1', modelId: 'm1' });
      expect(prismaMock.animalModel.create).toHaveBeenCalledWith({
        data: { animalId: 'a1', modelId: 'm1' },
        include: { animal: true, model: true }
      });
      expect(result.id).toBe('rel1');
    });
  });

  describe('deleteRelationship', () => {
    it('should delete the relationship', async () => {
      prismaMock.animalModel.delete.mockResolvedValue({});

      await relationshipService.deleteRelationship('rel1');
      expect(prismaMock.animalModel.delete).toHaveBeenCalledWith({
        where: { id: 'rel1' }
      });
    });
  });

  describe('getRelationships', () => {
    it('should return paginated relationships', async () => {
      prismaMock.animalModel.count.mockResolvedValue(10);
      prismaMock.animalModel.findMany.mockResolvedValue([
        { id: 'rel1' }
      ]);

      const result = await relationshipService.getRelationships(1, 10);
      expect(prismaMock.animalModel.count).toHaveBeenCalledWith({ where: { OR: undefined } });
      expect(prismaMock.animalModel.findMany).toHaveBeenCalledWith(expect.objectContaining({
        skip: 0,
        take: 10,
        include: { animal: true, model: true }
      }));
      expect(result.data).toHaveLength(1);
      expect(result.meta.total).toBe(10);
    });
  });

  describe('bulkAssign', () => {
    it('should execute bulk assignment within transaction', async () => {
      prismaMock.$transaction.mockImplementation((callback) => callback(prismaMock));
      prismaMock.animalModel.createMany.mockResolvedValue({});

      await relationshipService.bulkAssign({ modelId: 'm1', animalIds: ['a1', 'a2'] });

      expect(prismaMock.$transaction).toHaveBeenCalled();
      expect(prismaMock.animalModel.createMany).toHaveBeenCalledWith({
        data: [
          { modelId: 'm1', animalId: 'a1' },
          { modelId: 'm1', animalId: 'a2' }
        ],
        skipDuplicates: true
      });
    });
  });
});
