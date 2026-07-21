import { api } from '@/lib/api';
import { PaginatedResponse, Animal } from '@/types';

export const animalService = {
  getAnimals: async (params?: Record<string, any>): Promise<PaginatedResponse<Animal>> => {
    const { data } = await api.get('/animals', { params });
    return data.data;
  },
  getAnimalById: async (id: string): Promise<Animal> => {
    const { data } = await api.get(`/animals/${id}`);
    return data.data;
  },
  createAnimal: async (payload: Partial<Animal>): Promise<Animal> => {
    const { data } = await api.post('/animals', payload);
    return data.data;
  },
  updateAnimal: async (id: string, payload: Partial<Animal> | FormData): Promise<Animal> => {
    const { data } = await api.put(`/animals/${id}`, payload);
    return data.data;
  },
  deleteAnimal: async (id: string): Promise<void> => {
    await api.delete(`/animals/${id}`);
  },
};
