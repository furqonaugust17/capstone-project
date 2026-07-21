const leaderboardService = require('../../src/modules/leaderboard/leaderboard.service');

describe('Leaderboard Service', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getLiveLeaderboard', () => {
    it('should return live rankings mapped correctly', async () => {
      const mockStats = [
        { userId: 'u1', totalScore: 1000, totalGames: 10, user: { username: 'user1', displayName: 'User 1', avatarUrl: null } },
        { userId: 'u2', totalScore: 800, totalGames: 8, user: { username: 'user2', displayName: 'User 2', avatarUrl: null } },
      ];
      
      prismaMock.userStatistic.findMany.mockResolvedValue(mockStats);

      const result = await leaderboardService.getLiveLeaderboard(10);
      
      expect(prismaMock.userStatistic.findMany).toHaveBeenCalledWith(expect.objectContaining({
        orderBy: { totalScore: 'desc' },
        take: 10,
      }));

      expect(result).toHaveLength(2);
      expect(result[0].rank).toBe(1);
      expect(result[0].userId).toBe('u1');
      expect(result[0].username).toBe('user1');
      expect(result[1].rank).toBe(2);
      expect(result[1].userId).toBe('u2');
    });
  });

  describe('getMyRank', () => {
    it('should return null if user statistic is not found', async () => {
      prismaMock.userStatistic.findUnique.mockResolvedValue(null);

      const result = await leaderboardService.getMyRank('unknown_user');
      expect(result).toBeNull();
    });

    it('should calculate and return rank correctly', async () => {
      const mockStat = {
        userId: 'u1',
        totalScore: 500,
        totalGames: 5,
        user: { username: 'user1', displayName: 'User 1', avatarUrl: null }
      };

      prismaMock.userStatistic.findUnique.mockResolvedValue(mockStat);
      prismaMock.userStatistic.count.mockResolvedValue(4); // 4 people have score > 500

      const result = await leaderboardService.getMyRank('u1');
      
      expect(prismaMock.userStatistic.count).toHaveBeenCalledWith({
        where: { totalScore: { gt: 500 } }
      });

      expect(result.rank).toBe(5);
      expect(result.totalScore).toBe(500);
      expect(result.username).toBe('user1');
    });
  });
});
