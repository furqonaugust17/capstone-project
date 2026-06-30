import { api } from '@/lib/api';
import { LeaderboardEntry, LeaderboardSnapshot, GenerateSnapshotPayload } from '@/types';

export const leaderboardService = {
  getLive: async (params?: Record<string, any>): Promise<LeaderboardEntry[]> => {
    const { data } = await api.get('/leaderboards/live', { params });
    return data.data;
  },

  getSnapshot: async (params: { period: string; periodLabel: string }): Promise<LeaderboardSnapshot> => {
    const { data } = await api.get('/leaderboards/snapshot', { params });
    return data.data;
  },

  generateSnapshot: async (payload: GenerateSnapshotPayload): Promise<LeaderboardSnapshot> => {
    const { data } = await api.post('/leaderboards/snapshot', payload);
    return data.data;
  },

  // Client-side computed stats from live data
  computeStats: (entries: LeaderboardEntry[]) => {
    if (!entries || !entries.length) return null;
    const scores = entries.map(e => e.totalScore ?? 0);
    const games = entries.map(e => e.totalGames ?? 0);
    return {
      totalRankedUsers: entries.length,
      highestPoints: Math.max(...scores),
      averagePoints: Math.round(scores.reduce((a, b) => a + b, 0) / scores.length),
      mostGamesPlayed: Math.max(...games),
      topPlayer: { username: entries[0].username, totalScore: entries[0].totalScore ?? 0 },
    };
  },
};
