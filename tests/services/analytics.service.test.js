'use strict';

const analyticsService = require('../../src/modules/analytics/analytics.service');

describe('Analytics Service', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getOverview', () => {
    it('should return aggregated overview statistics', async () => {
      prismaMock.user.count.mockResolvedValue(100);
      prismaMock.gameSession.count.mockResolvedValue(500);
      prismaMock.gameSession.aggregate.mockResolvedValue({
        _avg: {
          gameScore: 85,
          focusScore: 0.8,
        },
      });

      const result = await analyticsService.getOverview();

      expect(prismaMock.user.count).toHaveBeenCalledWith({ where: { role: 'USER' } });
      expect(prismaMock.gameSession.count).toHaveBeenCalled();
      expect(prismaMock.gameSession.aggregate).toHaveBeenCalled();

      expect(result).toEqual({
        totalUsers: 100,
        totalSessions: 500,
        avgScore: 85,
        avgFocus: 0.8,
      });
    });

    it('should handle zero sessions gracefully', async () => {
      prismaMock.user.count.mockResolvedValue(0);
      prismaMock.gameSession.count.mockResolvedValue(0);
      prismaMock.gameSession.aggregate.mockResolvedValue({
        _avg: {
          gameScore: null,
          focusScore: null,
        },
      });

      const result = await analyticsService.getOverview();

      expect(result).toEqual({
        totalUsers: 0,
        totalSessions: 0,
        avgScore: 0,
        avgFocus: 0,
      });
    });
  });

  describe('updateLearningProfile', () => {
    it('should create new profile if it does not exist', async () => {
      const sessionData = { animalId: 'animal-1', gameScore: 80, confidenceScore: 0.7 };
      prismaMock.learningProfile.findUnique.mockResolvedValue(null);
      prismaMock.learningProfile.create.mockResolvedValue({ id: 'lp-1' });

      await analyticsService.updateLearningProfile('user-1', sessionData);

      expect(prismaMock.learningProfile.findUnique).toHaveBeenCalledWith({
        where: { userId_animalId: { userId: 'user-1', animalId: 'animal-1' } }
      });
      expect(prismaMock.learningProfile.create).toHaveBeenCalledWith(expect.objectContaining({
        data: expect.objectContaining({
          userId: 'user-1',
          animalId: 'animal-1',
          attemptCount: 1,
          avgScore: 80,
          avgConfidence: 0.7
        })
      }));
    });

    it('should update existing profile correctly', async () => {
      const sessionData = { animalId: 'animal-1', gameScore: 90, confidenceScore: 0.9 };
      const existingProfile = {
        id: 'lp-1',
        attemptCount: 1,
        avgScore: 70,
        avgConfidence: 0.5,
      };

      prismaMock.learningProfile.findUnique.mockResolvedValue(existingProfile);
      prismaMock.learningProfile.update.mockResolvedValue({ ...existingProfile, attemptCount: 2 });

      await analyticsService.updateLearningProfile('user-1', sessionData);

      expect(prismaMock.learningProfile.update).toHaveBeenCalledWith(expect.objectContaining({
        where: { id: 'lp-1' },
        data: expect.objectContaining({
          attemptCount: 2,
          avgScore: 80, // (70*1 + 90) / 2
          avgConfidence: 0.7 // (0.5*1 + 0.9) / 2
        })
      }));
    });
  });

  describe('getRecommendations', () => {
    it('should return unplayed animals as priority', async () => {
      prismaMock.animal.findMany.mockResolvedValue([
        { id: 'animal-1', name: 'Cat', isActive: true },
        { id: 'animal-2', name: 'Dog', isActive: true }
      ]);
      prismaMock.learningProfile.findMany.mockResolvedValue([]); // No played profiles

      const recommendations = await analyticsService.getRecommendations('user-1', 2);

      expect(recommendations.length).toBe(2);
      expect(recommendations[0].id).toBe('animal-1');
      expect(recommendations[0].reason).toBe('NEW_CHALLENGE');
      expect(recommendations[1].id).toBe('animal-2');
      expect(recommendations[1].reason).toBe('NEW_CHALLENGE');
    });

    it('should recommend animals needing practice and review', async () => {
      prismaMock.animal.findMany.mockResolvedValue([
        { id: 'animal-1', name: 'Cat', isActive: true },
        { id: 'animal-2', name: 'Dog', isActive: true }
      ]);
      
      const yesterday = new Date();
      yesterday.setDate(yesterday.getDate() - 1);
      
      const lastMonth = new Date();
      lastMonth.setMonth(lastMonth.getMonth() - 1);

      prismaMock.learningProfile.findMany.mockResolvedValue([
        { animalId: 'animal-1', avgScore: 50, lastPlayedAt: yesterday }, // Needs practice
        { animalId: 'animal-2', avgScore: 95, lastPlayedAt: lastMonth } // Review time
      ]);

      const recommendations = await analyticsService.getRecommendations('user-1', 3);

      expect(recommendations.length).toBe(2);
      expect(recommendations[0].id).toBe('animal-1');
      expect(recommendations[0].reason).toBe('NEEDS_PRACTICE');
      expect(recommendations[1].id).toBe('animal-2');
      expect(recommendations[1].reason).toBe('REVIEW_TIME');
    });
  });
});
