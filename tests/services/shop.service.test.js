const shopService = require('../../src/modules/shop/shop.service');

// Mock cloudflare functions
jest.mock('../../src/utils/cloudflare', () => ({
  uploadToR2: jest.fn().mockResolvedValue('http://fake-url.com/image.png'),
  deleteFromR2: jest.fn().mockResolvedValue(),
}));

describe('Shop Service', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getAllShopItems', () => {
    it('should return paginated items', async () => {
      const mockItems = [{ id: 'i1', name: 'Theme', isActive: true }];
      prismaMock.shopItem.count.mockResolvedValue(1);
      prismaMock.shopItem.findMany.mockResolvedValue(mockItems);

      const result = await shopService.getAllShopItems(1, 10, 'THEME');
      expect(prismaMock.shopItem.findMany).toHaveBeenCalledWith(expect.objectContaining({
        where: { isActive: true, category: 'THEME' },
        orderBy: { createdAt: 'desc' },
        skip: 0,
        take: 10
      }));
      expect(result.data).toEqual(mockItems);
      expect(result.meta.total).toBe(1);
    });
  });

  describe('getShopItemById', () => {
    it('should throw an error if item is not found', async () => {
      prismaMock.shopItem.findUnique.mockResolvedValue(null);
      await expect(shopService.getShopItemById('unknown')).rejects.toThrow('Shop item not found');
    });

    it('should return the item if found', async () => {
      const mockItem = { id: 'i1', isActive: true };
      prismaMock.shopItem.findUnique.mockResolvedValue(mockItem);
      const result = await shopService.getShopItemById('i1');
      expect(result).toEqual(mockItem);
    });
  });

  describe('createShopItem', () => {
    it('should create a shop item', async () => {
      const data = { name: 'Item', type: 'THEME', price: 100 };
      prismaMock.shopItem.create.mockResolvedValue({ id: 'i1', ...data });

      const result = await shopService.createShopItem(data, null);
      expect(prismaMock.shopItem.create).toHaveBeenCalledWith({
        data: expect.objectContaining({ name: 'Item', imageUrl: null })
      });
      expect(result.id).toBe('i1');
    });
  });

  describe('updateShopItem', () => {
    it('should throw an error if item not found for update', async () => {
      prismaMock.shopItem.findUnique.mockResolvedValue(null);
      await expect(shopService.updateShopItem('i1', {}, null)).rejects.toThrow('Shop item not found');
    });

    it('should update the item', async () => {
      prismaMock.shopItem.findUnique.mockResolvedValue({ id: 'i1', imageUrl: null });
      prismaMock.shopItem.update.mockResolvedValue({ id: 'i1', price: 200 });

      const result = await shopService.updateShopItem('i1', { price: 200 }, null);
      expect(prismaMock.shopItem.update).toHaveBeenCalledWith({
        where: { id: 'i1' },
        data: { price: 200, imageUrl: null }
      });
      expect(result.price).toBe(200);
    });
  });

  describe('deleteShopItem', () => {
    it('should throw an error if item not found for deletion', async () => {
      prismaMock.shopItem.findUnique.mockResolvedValue(null);
      await expect(shopService.deleteShopItem('i1')).rejects.toThrow('Shop item not found');
    });

    it('should soft delete the item', async () => {
      prismaMock.shopItem.findUnique.mockResolvedValue({ id: 'i1' });
      prismaMock.shopItem.update.mockResolvedValue({ id: 'i1' });

      await shopService.deleteShopItem('i1');
      expect(prismaMock.shopItem.update).toHaveBeenCalledWith({
        where: { id: 'i1' },
        data: { isActive: false }
      });
    });
  });
});
