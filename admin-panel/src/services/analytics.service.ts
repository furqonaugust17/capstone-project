import { api } from '@/lib/api';

export const analyticsService = {
  getOverview: async () => {
    const { data } = await api.get('/analytics/overview');
    return data.data;
  },
  getAnimalsAnalytics: async () => {
    const { data } = await api.get('/analytics/animals');
    return data.data;
  },
  getFocusDistribution: async () => {
    const { data } = await api.get('/analytics/focus');
    return data.data;
  },
  getUserAnalytics: async (userId: string) => {
    const { data } = await api.get(`/analytics/users/${userId}`);
    return data.data;
  },
};
