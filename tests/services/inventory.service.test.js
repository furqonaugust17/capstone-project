const inventoryService = require('../../src/modules/inventory/inventory.service');

describe('Inventory Service', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getMyInventory', () => {
    it('should return paginated inventory with shopItem included', async () => {
      const mockInventory = [
        { shopItem: { type: 'THEME', name: 'Dark Theme' } },
        { shopItem: { type: 'AVATAR', name: 'Cool Avatar' } },
      ];

      prismaMock.userInventory.count.mockResolvedValue(2);
      prismaMock.userInventory.findMany.mockResolvedValue(mockInventory);

      const result = await inventoryService.getMyInventory('u1', 1, 10);

      expect(prismaMock.userInventory.findMany).toHaveBeenCalledWith({
        where: { userId: 'u1' },
        include: { shopItem: true },
        orderBy: { acquiredAt: 'desc' },
        skip: 0,
        take: 10,
      });

      expect(result.data).toEqual(mockInventory);
      expect(result.meta.total).toBe(2);
    });
  });

  describe('getPurchaseHistory', () => {
    it('should return paginated purchase history', async () => {
      prismaMock.purchaseHistory.count.mockResolvedValue(10);
      prismaMock.purchaseHistory.findMany.mockResolvedValue([{ id: 'ph1' }, { id: 'ph2' }]);

      const result = await inventoryService.getPurchaseHistory('u1', 1, 5);

      expect(prismaMock.purchaseHistory.count).toHaveBeenCalledWith({ where: { userId: 'u1' } });
      expect(prismaMock.purchaseHistory.findMany).toHaveBeenCalledWith(expect.objectContaining({
        where: { userId: 'u1' },
        skip: 0,
        take: 5
      }));
      expect(result.data).toHaveLength(2);
      expect(result.meta.total).toBe(10);
    });
  });
});
