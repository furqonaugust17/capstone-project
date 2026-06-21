const gameSessionService = require('../../src/modules/game-sessions/gamesession.service');
const { checkAchievements } = require('../../src/modules/achievements/achievement.checker');

jest.mock('../../src/modules/achievements/achievement.checker', () => ({
  checkAchievements: jest.fn(),
}));

describe('Game Session Service', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    // Mock prisma.$transaction to execute the callback with the prismaMock object
    prismaMock.$transaction.mockImplementation((callback) => callback(prismaMock));
  });

  describe('createSession', () => {
    it('should create a game session, update user points, create stats if absent, and check achievements', async () => {
      const data = {
        animalId: 'a1',
        modelId: 'm1',
        predictionLabel: 'Cat',
        confidenceScore: 0.95,
        gameScore: 90,
        focusScore: 85,
        drawingDuration: 120,
        startedAt: '2023-10-10T10:00:00Z',
      };
      const userId = 'u1';

      prismaMock.gameSession.create.mockResolvedValue({ id: 'gs1', ...data });
      prismaMock.user.update.mockResolvedValue({});
      prismaMock.userStatistic.findUnique.mockResolvedValue(null); // Stat not present
      prismaMock.userStatistic.create.mockResolvedValue({});

      const result = await gameSessionService.createSession(userId, data);

      expect(result).toHaveProperty('id', 'gs1');
      expect(prismaMock.$transaction).toHaveBeenCalled();
      expect(prismaMock.gameSession.create).toHaveBeenCalledWith(expect.objectContaining({
        data: expect.objectContaining({ userId, animalId: data.animalId, gameScore: data.gameScore })
      }));
      expect(prismaMock.user.update).toHaveBeenCalledWith({
        where: { id: userId },
        data: { totalPoint: { increment: 90 } },
      });
      expect(prismaMock.userStatistic.create).toHaveBeenCalled();
      expect(checkAchievements).toHaveBeenCalledWith(userId, prismaMock);
    });

    it('should update user stats if they already exist', async () => {
      const data = {
        animalId: 'a1',
        modelId: 'm1',
        predictionLabel: 'Cat',
        confidenceScore: 0.95,
        gameScore: 90,
        focusScore: 85,
        drawingDuration: 120,
        startedAt: '2023-10-10T10:00:00Z',
      };
      const userId = 'u1';

      prismaMock.gameSession.create.mockResolvedValue({ id: 'gs1', ...data });
      prismaMock.user.update.mockResolvedValue({});
      
      const existingStat = {
        userId,
        totalGames: 5,
        totalScore: 400,
        highestScore: 88,
        totalDrawingTime: 600,
        averageFocus: 80,
      };
      prismaMock.userStatistic.findUnique.mockResolvedValue(existingStat);
      prismaMock.userStatistic.update.mockResolvedValue({});

      await gameSessionService.createSession(userId, data);

      expect(prismaMock.userStatistic.update).toHaveBeenCalledWith({
        where: { userId },
        data: {
          totalGames: 6,
          totalScore: 490,
          highestScore: 90, // max(88, 90)
          totalDrawingTime: 720,
          averageFocus: expect.any(Number),
        }
      });
    });
  });

  describe('getMySessions', () => {
    it('should return paginated sessions and metadata', async () => {
      prismaMock.gameSession.count.mockResolvedValue(15);
      prismaMock.gameSession.findMany.mockResolvedValue([{ id: 'gs1' }, { id: 'gs2' }]);

      const result = await gameSessionService.getMySessions('u1', 2, 2);

      expect(prismaMock.gameSession.count).toHaveBeenCalledWith({ where: { userId: 'u1' } });
      expect(prismaMock.gameSession.findMany).toHaveBeenCalledWith(expect.objectContaining({
        where: { userId: 'u1' },
        skip: 2,
        take: 2,
      }));
      expect(result.data).toHaveLength(2);
      expect(result.meta).toEqual({
        total: 15,
        page: 2,
        limit: 2,
        totalPages: 8,
      });
    });
  });

  describe('getSessionById', () => {
    it('should throw an error if session is not found', async () => {
      prismaMock.gameSession.findUnique.mockResolvedValue(null);
      await expect(gameSessionService.getSessionById('gs1', 'u1')).rejects.toThrow('Game session not found');
    });

    it('should throw an error if session belongs to another user', async () => {
      prismaMock.gameSession.findUnique.mockResolvedValue({ id: 'gs1', userId: 'u2' });
      await expect(gameSessionService.getSessionById('gs1', 'u1')).rejects.toThrow('Forbidden: This session does not belong to you');
    });

    it('should return session if found and belongs to user', async () => {
      const session = { id: 'gs1', userId: 'u1' };
      prismaMock.gameSession.findUnique.mockResolvedValue(session);
      const result = await gameSessionService.getSessionById('gs1', 'u1');
      expect(result).toEqual(session);
    });
  });
});
