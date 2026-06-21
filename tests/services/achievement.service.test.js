const achievementService = require('../../src/modules/achievements/achievement.service');

describe('Achievement Service', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getAllAchievements', () => {
    it('should return all achievements', async () => {
      const mockAchievements = [{ id: 'a1', name: 'First Win' }];
      prismaMock.achievement.findMany.mockResolvedValue(mockAchievements);

      const result = await achievementService.getAllAchievements();
      expect(prismaMock.achievement.findMany).toHaveBeenCalledWith({
        where: { isActive: true },
        orderBy: { rewardPoint: 'asc' },
      });
      expect(result).toEqual(mockAchievements);
    });
  });

  describe('getMyAchievements', () => {
    it('should return user achievements mapped correctly', async () => {
      const mockUserAchievements = [
        {
          id: 'ua1',
          userId: 'u1',
          achievementId: 'a1',
          unlockedAt: '2023-01-01T00:00:00Z',
          achievement: { id: 'a1', name: 'First Win' }
        }
      ];
      prismaMock.userAchievement.findMany.mockResolvedValue(mockUserAchievements);

      const result = await achievementService.getMyAchievements('u1');
      expect(prismaMock.userAchievement.findMany).toHaveBeenCalledWith({
        where: { userId: 'u1' },
        include: { achievement: true },
        orderBy: { unlockedAt: 'desc' }
      });
      
      expect(result).toHaveLength(1);
      expect(result[0].id).toBe('a1');
      expect(result[0].unlockedAt).toBe('2023-01-01T00:00:00Z');
      expect(result[0].name).toBe('First Win');
    });
  });

  describe('createAchievement', () => {
    it('should create an achievement', async () => {
      prismaMock.achievement.create.mockResolvedValue({ id: 'a1', name: 'Test' });

      const result = await achievementService.createAchievement({ name: 'Test' }, null);
      expect(prismaMock.achievement.create).toHaveBeenCalledWith({
        data: { name: 'Test', iconUrl: null }
      });
      expect(result.id).toBe('a1');
    });
  });

  describe('updateAchievement', () => {
    it('should throw error if achievement not found', async () => {
      prismaMock.achievement.findUnique.mockResolvedValue(null);
      await expect(achievementService.updateAchievement('a1', {}, null)).rejects.toThrow('Achievement not found');
    });

    it('should update an achievement', async () => {
      prismaMock.achievement.findUnique.mockResolvedValue({ id: 'a1', iconUrl: null });
      prismaMock.achievement.update.mockResolvedValue({ id: 'a1', name: 'Updated' });

      const result = await achievementService.updateAchievement('a1', { name: 'Updated' }, null);
      expect(prismaMock.achievement.update).toHaveBeenCalledWith({
        where: { id: 'a1' },
        data: { name: 'Updated', iconUrl: null }
      });
      expect(result.name).toBe('Updated');
    });
  });

  describe('deleteAchievement', () => {
    it('should throw error if achievement not found', async () => {
      prismaMock.achievement.findUnique.mockResolvedValue(null);
      await expect(achievementService.deleteAchievement('a1')).rejects.toThrow('Achievement not found');
    });

    it('should delete an achievement (soft delete)', async () => {
      prismaMock.achievement.findUnique.mockResolvedValue({ id: 'a1' });
      prismaMock.achievement.update.mockResolvedValue({ id: 'a1' });

      await achievementService.deleteAchievement('a1');
      expect(prismaMock.achievement.update).toHaveBeenCalledWith({
        where: { id: 'a1' },
        data: { isActive: false }
      });
    });
  });
});
