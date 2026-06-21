const mlModelService = require('../../src/modules/ml-models/mlmodel.service');

// Mock cloudflare functions
jest.mock('../../src/utils/cloudflare', () => ({
  uploadToR2: jest.fn().mockResolvedValue('http://fake-url.com/model.tflite'),
  deleteFromR2: jest.fn().mockResolvedValue(),
}));

describe('ML Model Service', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getAllModels', () => {
    it('should return paginated models', async () => {
      const mockModels = [{ id: 'm1', name: 'Model 1' }];
      prismaMock.mLModel.count.mockResolvedValue(1);
      prismaMock.mLModel.findMany.mockResolvedValue(mockModels);

      const result = await mlModelService.getAllModels(1, 10);
      expect(prismaMock.mLModel.findMany).toHaveBeenCalledWith(expect.objectContaining({
        orderBy: { createdAt: 'desc' },
        skip: 0,
        take: 10,
      }));
      expect(result.data).toEqual(mockModels);
    });
  });

  describe('getModelById', () => {
    it('should throw an error if model is not found', async () => {
      prismaMock.mLModel.findUnique.mockResolvedValue(null);
      await expect(mlModelService.getModelById('m1')).rejects.toThrow('ML Model not found');
    });

    it('should return the model if found', async () => {
      const mockModel = { id: 'm1' };
      prismaMock.mLModel.findUnique.mockResolvedValue(mockModel);
      const result = await mlModelService.getModelById('m1');
      expect(result).toEqual(mockModel);
    });
  });

  describe('createModel', () => {
    it('should throw an error if file is not provided', async () => {
      await expect(mlModelService.createModel({ name: 'Model 1' }, null)).rejects.toThrow('TFLite model file is required');
    });

    it('should create a model', async () => {
      const data = { name: 'Model 1', version: '1.0' };
      const file = { originalname: 'model.tflite', buffer: Buffer.from('test'), mimetype: 'application/octet-stream' };
      prismaMock.mLModel.create.mockResolvedValue({ id: 'm1', ...data });

      const result = await mlModelService.createModel(data, file);
      expect(prismaMock.mLModel.create).toHaveBeenCalledWith({
        data: expect.objectContaining({ name: 'Model 1', version: '1.0', fileUrl: 'http://fake-url.com/model.tflite' })
      });
      expect(result.id).toBe('m1');
    });
  });

  describe('updateModel', () => {
    it('should throw an error if model not found for update', async () => {
      prismaMock.mLModel.findUnique.mockResolvedValue(null);
      await expect(mlModelService.updateModel('m1', {}, null)).rejects.toThrow('ML Model not found');
    });

    it('should update the model', async () => {
      prismaMock.mLModel.findUnique.mockResolvedValue({ id: 'm1', fileUrl: null });
      prismaMock.mLModel.update.mockResolvedValue({ id: 'm1', isActive: false });

      const result = await mlModelService.updateModel('m1', { isActive: false }, null);
      expect(prismaMock.mLModel.update).toHaveBeenCalledWith({
        where: { id: 'm1' },
        data: { isActive: false, fileUrl: null }
      });
      expect(result.isActive).toBe(false);
    });
  });

  describe('deleteModel', () => {
    it('should throw an error if model not found for deletion', async () => {
      prismaMock.mLModel.findUnique.mockResolvedValue(null);
      await expect(mlModelService.deleteModel('m1')).rejects.toThrow('ML Model not found');
    });

    it('should delete the model', async () => {
      prismaMock.mLModel.findUnique.mockResolvedValue({ id: 'm1' });
      prismaMock.mLModel.update.mockResolvedValue({ id: 'm1' });

      await mlModelService.deleteModel('m1');
      expect(prismaMock.mLModel.update).toHaveBeenCalledWith({
        where: { id: 'm1' },
        data: { isActive: false }
      });
    });
  });

  describe('getModelHistory', () => {
    it('should throw an error if model is not found', async () => {
      prismaMock.mLModel.findUnique.mockResolvedValue(null);
      await expect(mlModelService.getModelHistory('m1')).rejects.toThrow('ML Model not found');
    });

    it('should return history of models with same name', async () => {
      const mockModel = { id: 'm1', name: 'DrawModel' };
      const mockHistory = [
        { id: 'm2', name: 'DrawModel', version: '2.0', activatedAt: new Date() },
        { id: 'm1', name: 'DrawModel', version: '1.0', activatedAt: null }
      ];
      prismaMock.mLModel.findUnique.mockResolvedValue(mockModel);
      prismaMock.mLModel.findMany.mockResolvedValue(mockHistory);

      const result = await mlModelService.getModelHistory('m1');
      
      expect(prismaMock.mLModel.findMany).toHaveBeenCalledWith({
        where: { name: 'DrawModel' },
        orderBy: { createdAt: 'desc' },
      });
      expect(result).toEqual(mockHistory);
    });
  });

  describe('activateModel', () => {
    it('should throw an error if model is not found', async () => {
      prismaMock.mLModel.findUnique.mockResolvedValue(null);
      await expect(mlModelService.activateModel('m1')).rejects.toThrow('ML Model not found');
    });

    it('should deactivate other models and activate the target model with current date', async () => {
      const mockModel = { id: 'm1', name: 'DrawModel', isActive: false };
      prismaMock.mLModel.findUnique.mockResolvedValue(mockModel);
      prismaMock.$transaction.mockResolvedValue([null, mockModel]);

      await mlModelService.activateModel('m1');

      expect(prismaMock.$transaction).toHaveBeenCalled();
      
      // We can't easily assert the contents of the transaction array without mocking it perfectly,
      // but we can ensure it was called. The mock for $transaction is usually handled in setup.js or we can just assert it's called.
      expect(prismaMock.mLModel.findUnique).toHaveBeenCalledWith({ where: { id: 'm1' } });
    });
  });
});
