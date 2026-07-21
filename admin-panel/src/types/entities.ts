export interface User {
  id: string;
  username: string;
  email: string;
  displayName: string;
  avatarUrl: string | null;
  totalPoint: number;
  createdAt: string;
  updatedAt: string;
}

export interface Animal {
  id: string;
  name: string;
  description: string;
  thumbnailUrl: string | null;
  hintImageUrl: string | null;
  traceImageUrl: string | null;
  difficulty: 'easy' | 'medium' | 'hard';
  funFact?: string;
  drawingTips?: string[];
  isActive: boolean;
  createdAt: string;
}

export interface MLModel {
  id: string;
  name: string;
  version: string;
  fileUrl: string;
  labelsUrl: string;
  inputSize: string;
  framework: string;
  accuracy: number;
  isActive: boolean;
  createdAt: string;
}

export interface AnimalModel {
  id: string;
  animalId: string;
  modelId: string;
  animal?: Animal;
  model?: MLModel;
  createdAt: string;
}

export interface GameSession {
  id: string;
  userId: string;
  animalId: string;
  modelId: string;
  predictionLabel: string;
  confidenceScore: number;
  gameScore: number;
  focusScore: number;
  drawingDuration: number;
  startedAt: string;
  finishedAt: string;
  user?: User;
  animal?: Animal;
  model?: MLModel;
}

export interface ShopItem {
  id: string;
  name: string;
  description: string;
  imageUrl: string | null;
  price: number;
  category: 'AVATAR' | 'FRAME' | 'STICKER' | 'THEME';
  rarity: 'COMMON' | 'RARE' | 'EPIC' | 'LEGENDARY';
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface UserInventory {
  id: string;
  userId: string;
  itemId: string;
  quantity: number;
  acquiredAt: string;
  shopItem?: ShopItem;
}

export interface PurchaseHistory {
  id: string;
  userId: string;
  itemId: string;
  price: number;
  purchasedAt: string;
  shopItem?: ShopItem;
}



export interface UserStatistic {
  userId: string;
  totalGames: number;
  totalScore: number;
  highestScore: number;
  averageFocus: number;
  totalDrawingTime: number;
  updatedAt: string;
}

export type LeaderboardPeriod = 'WEEKLY' | 'MONTHLY' | 'SEASONAL' | 'ALL_TIME';

export interface LeaderboardEntry {
  rank: number;
  userId: string;
  username: string;
  displayName: string | null;
  avatarUrl: string | null;
  totalScore: number;
  totalGames: number;
  highestScore: number;
  averageFocus: number;
}

export interface LeaderboardSnapshot {
  id: string;
  period: LeaderboardPeriod;
  periodLabel: string;
  rankings: LeaderboardEntry[];
  generatedAt: string;
}

export interface LeaderboardStats {
  totalRankedUsers: number;
  highestPoints: number;
  averagePoints: number;
  mostGamesPlayed: number;
  topPlayer: { username: string; totalScore: number };
}

export interface GenerateSnapshotPayload {
  period: LeaderboardPeriod;
  periodLabel: string;
  limit?: number;
}
