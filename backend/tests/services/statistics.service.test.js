const statisticsService = require('../../src/modules/statistics/statistics.service');

describe('Statistics Service', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getOverview', () => {
    it('should calculate global overview using aggregations', async () => {
      prismaMock.user.count.mockResolvedValue(100);
      prismaMock.gameSession.count.mockResolvedValue(500);
      prismaMock.mLModel.count.mockResolvedValue(10);
      
      prismaMock.gameSession.aggregate.mockResolvedValue({
        _avg: {
          gameScore: 80.5
        }
      });

      const result = await statisticsService.getOverview();
      expect(result).toEqual({
        totalUsers: 100,
        totalGames: 500,
        avgScore: 81,
        activeModels: 10,
      });
    });

    it('should handle missing aggregates gracefully', async () => {
      prismaMock.user.count.mockResolvedValue(0);
      prismaMock.gameSession.count.mockResolvedValue(0);
      prismaMock.mLModel.count.mockResolvedValue(0);
      
      prismaMock.gameSession.aggregate.mockResolvedValue({
        _avg: { gameScore: null }
      });

      const result = await statisticsService.getOverview();
      expect(result.avgScore).toBe(0);
    });
  });

  describe('getChartsData', () => {
    it('should return empty chart array if no sessions', async () => {
      prismaMock.gameSession.findMany.mockResolvedValue([]);
      const result = await statisticsService.getChartsData();
      expect(result.sessionsOverTime).toHaveLength(7);
      expect(result.sessionsOverTime[0].count).toBe(0);
    });

    it('should aggregate session counts per day', async () => {
      const today = new Date();
      prismaMock.gameSession.findMany.mockResolvedValue([
        { startedAt: today },
        { startedAt: today }
      ]);
      const result = await statisticsService.getChartsData();
      
      const todayStr = today.toISOString().split('T')[0];
      const todayData = result.sessionsOverTime.find(r => r.date === todayStr);
      expect(todayData.count).toBe(2);
    });
  });

  describe('getDetailedStatistics', () => {
    it('should return top users and animals', async () => {
      prismaMock.user.findMany.mockResolvedValue([
        { id: 'u1', username: 'user1', totalPoint: 100 }
      ]);

      prismaMock.animal.findMany.mockResolvedValue([
        { id: 'a1', name: 'Cat', _count: { gameSessions: 50 } },
        { id: 'a2', name: 'Dog', _count: { gameSessions: 10 } }
      ]);

      const result = await statisticsService.getDetailedStatistics();
      expect(result.topUsers).toHaveLength(1);
      expect(result.topAnimals).toHaveLength(2);
      expect(result.topAnimals[0].name).toBe('Cat');
      expect(result.topAnimals[0].sessionCount).toBe(50);
    });
  });
});
