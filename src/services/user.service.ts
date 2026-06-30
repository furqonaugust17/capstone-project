import { api } from '@/lib/api';
import { PaginatedResponse, User } from '@/types';

export const userService = {
  getUsers: async (params?: Record<string, any>): Promise<PaginatedResponse<User>> => {
    const { data } = await api.get('/users', { params });
    return data.data;
  },
  getUserById: async (id: string): Promise<User> => {
    const { data } = await api.get(`/users/${id}`);
    return data.data;
  },
  updateUser: async (id: string, payload: Partial<User>): Promise<User> => {
    const { data } = await api.patch(`/users/${id}`, payload);
    return data.data;
  },
  deleteUser: async (id: string): Promise<void> => {
    await api.delete(`/users/${id}`);
  },
  // TODO: Check if endpoint /users/:id/inventory exists in backend API
  getUserInventory: async (id: string, params?: Record<string, any>): Promise<any[]> => {
    const { data } = await api.get(`/users/${id}/inventory`, { params });
    return data.data?.data || [];
  },
  // TODO: Check if endpoint /users/:id/purchases exists in backend API
  getUserPurchases: async (id: string, params?: Record<string, any>): Promise<any[]> => {
    const { data } = await api.get(`/users/${id}/purchases`, { params });
    return data.data?.data || [];
  },
};
