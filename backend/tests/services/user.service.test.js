const userService = require('../../src/modules/users/user.service');

describe('User Service', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getAllUsers', () => {
    it('should return paginated list of users', async () => {
      prismaMock.user.count.mockResolvedValue(10);
      prismaMock.user.findMany.mockResolvedValue([
        { id: 'u1', username: 'user1', totalPoint: 100 }
      ]);

      const result = await userService.getAllUsers(1, 10);
      
      expect(prismaMock.user.count).toHaveBeenCalled();
      expect(prismaMock.user.findMany).toHaveBeenCalledWith(expect.objectContaining({
        skip: 0,
        take: 10,
      }));
      expect(result.data).toHaveLength(1);
      expect(result.meta.total).toBe(10);
    });
  });

  describe('getUserById', () => {
    it('should throw an error if user not found', async () => {
      prismaMock.user.findUnique.mockResolvedValue(null);
      await expect(userService.getUserById('unknown')).rejects.toThrow('User not found');
    });

    it('should return user', async () => {
      prismaMock.user.findUnique.mockResolvedValue({ id: 'u1', username: 'user1' });
      const result = await userService.getUserById('u1');
      expect(result.id).toBe('u1');
    });
  });

  describe('deleteUser', () => {
    it('should throw error if user not found or not a normal USER', async () => {
      prismaMock.user.findUnique.mockResolvedValue(null);
      await expect(userService.deleteUser('u1')).rejects.toThrow('User not found');
    });

    it('should delete user', async () => {
      prismaMock.user.findUnique.mockResolvedValue({ id: 'u1', role: 'USER' });
      prismaMock.user.delete.mockResolvedValue({ id: 'u1' });
      
      await userService.deleteUser('u1');
      
      expect(prismaMock.user.findUnique).toHaveBeenCalledWith({ where: { id: 'u1', role: 'USER' } });
      expect(prismaMock.user.delete).toHaveBeenCalledWith({ where: { id: 'u1' } });
    });
  });
});
