import { api } from '@/lib/api';
import { PaginatedResponse, GameSession } from '@/types';

export const gameSessionService = {
  getSessions: async (params?: Record<string, any>): Promise<PaginatedResponse<GameSession>> => {
    const { data } = await api.get('/game-sessions/all', { params });
    
    // Map backend camelCase to frontend snake_case GameSession interface
    const mappedData = data.data.data.map((session: any) => ({
      ...session,
      user_id: session.userId,
      animal_id: session.animalId,
      model_id: session.modelId,
      prediction_label: session.predictionLabel,
      confidence_score: session.confidenceScore,
      game_score: session.gameScore,
      focus_score: session.focusScore,
      drawing_duration: session.drawingDuration,
      started_at: session.startedAt,
      finished_at: session.finishedAt,
    }));

    return {
      data: mappedData,
      meta: data.data.meta
    };
  },
  getSessionById: async (id: string): Promise<GameSession> => {
    const { data } = await api.get(`/game-sessions/${id}`);
    const session = data.data;
    
    return {
      ...session,
      user_id: session.userId,
      animal_id: session.animalId,
      model_id: session.modelId,
      prediction_label: session.predictionLabel,
      confidence_score: session.confidenceScore,
      game_score: session.gameScore,
      focus_score: session.focusScore,
      drawing_duration: session.drawingDuration,
      started_at: session.startedAt,
      finished_at: session.finishedAt,
    };
  },
  exportCSV: async (params?: Record<string, any>): Promise<Blob> => {
    const response = await api.get('/game-sessions/export', {
      params,
      responseType: 'blob',
    });
    return response.data;
  },
};
