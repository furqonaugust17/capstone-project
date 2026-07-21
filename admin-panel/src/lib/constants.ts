export const DEFAULT_PAGE_SIZE = 10;

export const DIFFICULTY_OPTIONS = [
  { label: 'Easy', value: 'Easy' },
  { label: 'Medium', value: 'Medium' },
  { label: 'Hard', value: 'Hard' },
] as const;

export const CATEGORY_OPTIONS = [
  { label: 'Avatar', value: 'Avatar' },
  { label: 'Frame', value: 'Frame' },
  { label: 'Sticker', value: 'Sticker' },
  { label: 'Theme', value: 'Theme' },
] as const;

export const RARITY_OPTIONS = [
  { label: 'Common', value: 'Common' },
  { label: 'Rare', value: 'Rare' },
  { label: 'Epic', value: 'Epic' },
  { label: 'Legendary', value: 'Legendary' },
] as const;
