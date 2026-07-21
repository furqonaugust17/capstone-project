import { api } from '@/lib/api';
import { PaginatedResponse, MLModel } from '@/types';

export const modelService = {
  getModels: async (params?: Record<string, any>): Promise<PaginatedResponse<MLModel>> => {
    const { data } = await api.get('/ml-models', { params });
    return data.data;
  },
  getModelById: async (id: string): Promise<MLModel> => {
    const { data } = await api.get(`/ml-models/${id}`);
    return data.data;
  },
  createModel: async (payload: Partial<MLModel> | FormData): Promise<MLModel> => {
    const isFormData = payload instanceof FormData;
    const { data } = await api.post('/ml-models', payload, {
      headers: isFormData ? { 'Content-Type': 'multipart/form-data' } : undefined
    });
    return data.data;
  },
  updateModel: async (id: string, payload: Partial<MLModel> | FormData): Promise<MLModel> => {
    const isFormData = payload instanceof FormData;
    const { data } = await api.put(`/ml-models/${id}`, payload, {
      headers: isFormData ? { 'Content-Type': 'multipart/form-data' } : undefined
    });
    return data.data;
  },
  deleteModel: async (id: string): Promise<void> => {
    await api.delete(`/ml-models/${id}`);
  },
  activateModel: async (id: string): Promise<MLModel> => {
    const { data } = await api.patch(`/ml-models/${id}/activate`);
    return data.data;
  },
  getModelHistory: async (id: string): Promise<MLModel[]> => {
    const { data } = await api.get(`/ml-models/${id}/history`);
    return data.data;
  },
  rollbackModel: async (id: string): Promise<MLModel> => {
    const { data } = await api.post(`/ml-models/${id}/rollback`);
    return data.data;
  },
  syncAnimals: async (id: string, animalIds: string[]): Promise<void> => {
    await api.post(`/ml-models/${id}/animals`, { animalIds });
  },
};
