import { api } from '@/lib/api';
import { PaginatedResponse, ShopItem } from '@/types';

export const shopService = {
  getItems: async (params?: Record<string, any>): Promise<PaginatedResponse<ShopItem>> => {
    const { data } = await api.get('/shop', { params });
    return data.data;
  },
  getItemById: async (id: string): Promise<ShopItem> => {
    const { data } = await api.get(`/shop/${id}`);
    return data.data;
  },
  createItem: async (payload: FormData): Promise<ShopItem> => {
    const { data } = await api.post('/shop', payload);
    return data.data;
  },
  updateItem: async (id: string, payload: FormData): Promise<ShopItem> => {
    const { data } = await api.put(`/shop/${id}`, payload);
    return data.data;
  },
  deleteItem: async (id: string): Promise<void> => {
    await api.delete(`/shop/${id}`);
  },
};
