import { api } from '@/lib/api';

export const statisticsService = {
  getOverview: async () => {
    const { data } = await api.get('/statistics/overview');
    return data.data;
  },
  getCharts: async (params?: Record<string, any>) => {
    const { data } = await api.get('/statistics/charts', { params });
    return data.data;
  },
  getDetailed: async (params?: Record<string, any>) => {
    const { data } = await api.get('/statistics/detailed', { params });
    return data.data;
  },
};
