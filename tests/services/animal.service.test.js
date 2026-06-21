const animalService = require('../../src/modules/animals/animal.service');

// Mock cloudflare functions
jest.mock('../../src/utils/cloudflare', () => ({
  uploadToR2: jest.fn().mockResolvedValue('http://fake-url.com/image.jpg'),
  deleteFromR2: jest.fn().mockResolvedValue(),
}));

describe('Animal Service', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getAllAnimals', () => {
    it('should return paginated active animals', async () => {
      prismaMock.animal.count.mockResolvedValue(10);
      prismaMock.animal.findMany.mockResolvedValue([{ id: 'a1', name: 'Cat' }]);

      const result = await animalService.getAllAnimals(1, 10);
      expect(prismaMock.animal.findMany).toHaveBeenCalledWith({
        where: { isActive: true },
        orderBy: { createdAt: 'desc' },
        skip: 0,
        take: 10,
      });
      expect(result.data).toHaveLength(1);
      expect(result.meta.total).toBe(10);
    });
  });

  describe('getAnimalById', () => {
    it('should throw an error if animal not found', async () => {
      prismaMock.animal.findUnique.mockResolvedValue(null);
      await expect(animalService.getAnimalById('unknown')).rejects.toThrow('Animal not found');
    });

    it('should throw an error if animal is inactive', async () => {
      prismaMock.animal.findUnique.mockResolvedValue({ id: 'a1', isActive: false });
      await expect(animalService.getAnimalById('a1')).rejects.toThrow('Animal not found');
    });

    it('should return animal if found and active', async () => {
      const mockAnimal = { id: 'a1', name: 'Cat', isActive: true };
      prismaMock.animal.findUnique.mockResolvedValue(mockAnimal);
      const result = await animalService.getAnimalById('a1');
      expect(result).toEqual(mockAnimal);
    });
  });

  describe('createAnimal', () => {
    it('should create an animal without files', async () => {
      const data = { name: 'Cat', description: 'Meow' };
      prismaMock.animal.create.mockResolvedValue({ id: 'a1', ...data });

      const result = await animalService.createAnimal(data, null);
      expect(prismaMock.animal.create).toHaveBeenCalledWith({ data });
      expect(result.id).toBe('a1');
    });
  });

  describe('updateAnimal', () => {
    it('should throw an error if animal not found for update', async () => {
      prismaMock.animal.findUnique.mockResolvedValue(null);
      await expect(animalService.updateAnimal('unknown', {}, null)).rejects.toThrow('Animal not found');
    });

    it('should update animal data without files', async () => {
      prismaMock.animal.findUnique.mockResolvedValue({ id: 'a1' });
      prismaMock.animal.update.mockResolvedValue({ id: 'a1', name: 'Updated Cat' });

      const result = await animalService.updateAnimal('a1', { name: 'Updated Cat' }, null);
      expect(prismaMock.animal.update).toHaveBeenCalledWith({
        where: { id: 'a1' },
        data: { name: 'Updated Cat' },
      });
      expect(result.name).toBe('Updated Cat');
    });
  });

  describe('deleteAnimal', () => {
    it('should throw an error if animal not found for deletion', async () => {
      prismaMock.animal.findUnique.mockResolvedValue(null);
      await expect(animalService.deleteAnimal('unknown')).rejects.toThrow('Animal not found');
    });

    it('should soft delete the animal', async () => {
      prismaMock.animal.findUnique.mockResolvedValue({ id: 'a1' });
      prismaMock.animal.update.mockResolvedValue({ id: 'a1' });

      await animalService.deleteAnimal('a1');
      expect(prismaMock.animal.update).toHaveBeenCalledWith({
        where: { id: 'a1' },
        data: { isActive: false }
      });
    });
  });
});
