import { api } from '@/lib/api';
import { ApiSuccessResponse, User } from '@/types';

export const authService = {
  login: async (credentials: Record<string, string>) => {
    const { data } = await api.post('/auth/login', credentials);
    return data;
  },
  getMe: async (): Promise<User> => {
    const { data } = await api.get<ApiSuccessResponse<User>>('/auth/me');
    return data.data;
  },
  logout: async () => {
    const { data } = await api.post('/auth/logout');
    return data;
  },
};
