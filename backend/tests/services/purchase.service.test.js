const purchaseService = require('../../src/modules/purchase/purchase.service');

describe('Purchase Service', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('purchaseItem', () => {
    beforeEach(() => {
      prismaMock.$transaction.mockImplementation((callback) => callback(prismaMock));
    });

    it('should throw an error if item is not found', async () => {
      prismaMock.shopItem.findUnique.mockResolvedValue(null);
      await expect(purchaseService.purchaseItem('u1', 'i1')).rejects.toThrow('Shop item not found or unavailable');
    });

    it('should throw an error if item is inactive', async () => {
      prismaMock.shopItem.findUnique.mockResolvedValue({ id: 'i1', isActive: false });
      await expect(purchaseService.purchaseItem('u1', 'i1')).rejects.toThrow('Shop item not found or unavailable');
    });

    it('should update inventory if user already owns the item (stackable)', async () => {
      const mockItem = { id: 'i1', isActive: true, price: 100 };
      prismaMock.shopItem.findUnique.mockResolvedValue(mockItem);
      prismaMock.user.findUnique.mockResolvedValue({ id: 'u1', totalPoint: 150 });
      prismaMock.userInventory.findUnique.mockResolvedValue({ id: 'inv1' });

      prismaMock.userInventory.update.mockResolvedValue({});
      prismaMock.user.update.mockResolvedValue({});
      prismaMock.purchaseHistory.create.mockResolvedValue({});

      await purchaseService.purchaseItem('u1', 'i1');

      expect(prismaMock.userInventory.update).toHaveBeenCalledWith({
        where: { id: 'inv1' },
        data: { quantity: { increment: 1 } }
      });
    });

    it('should throw an error if user does not have enough points', async () => {
      prismaMock.shopItem.findUnique.mockResolvedValue({ id: 'i1', isActive: true, price: 100 });
      prismaMock.user.findUnique.mockResolvedValue({ id: 'u1', totalPoint: 50 });
      await expect(purchaseService.purchaseItem('u1', 'i1')).rejects.toThrow('Insufficient points');
    });

    it('should complete purchase successfully for new item', async () => {
      const mockItem = { id: 'i1', isActive: true, price: 100 };
      prismaMock.shopItem.findUnique.mockResolvedValue(mockItem);
      prismaMock.user.findUnique.mockResolvedValue({ id: 'u1', totalPoint: 150 });
      prismaMock.userInventory.findUnique.mockResolvedValue(null); // Not owned
      
      prismaMock.user.update.mockResolvedValue({});
      prismaMock.userInventory.create.mockResolvedValue({ id: 'inv1' });
      prismaMock.purchaseHistory.create.mockResolvedValue({ id: 'ph1' });

      const result = await purchaseService.purchaseItem('u1', 'i1');

      expect(prismaMock.user.update).toHaveBeenCalledWith({
        where: { id: 'u1' },
        data: { totalPoint: { decrement: 100 } }
      });
      expect(prismaMock.userInventory.create).toHaveBeenCalledWith({
        data: { userId: 'u1', itemId: 'i1', quantity: 1 }
      });
      expect(prismaMock.purchaseHistory.create).toHaveBeenCalledWith({
        data: { userId: 'u1', itemId: 'i1', price: 100 }
      });
      expect(result.message).toBe('Item purchased successfully');
      expect(result.item).toEqual(mockItem);
    });
  });
});
