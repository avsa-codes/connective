export const lightColors = {
  // Brand
  primary: '#087E67',
  primaryDark: '#005B4B',
  primaryLight: '#E5F5EF',

  // Backgrounds
  background: '#F8FAF9',
  surface: '#FFFFFF',
  surfaceSecondary: '#F0F4F2',

  // Text
  text: '#172521',
  textSecondary: '#687873',
  textInverse: '#FFFFFF',

  // Borders and dividers
  border: '#E1E9E5',

  // Status
  success: '#16865D',
  warning: '#D99A28',
  danger: '#D94848',

  // Interactive elements
  onPrimary: '#FFFFFF',
} as const;

export const darkColors = {
  // Brand
  primary: '#42B99A',
  primaryDark: '#087E67',
  primaryLight: '#183D32',

  // Backgrounds
  background: '#0D1715',
  surface: '#172521',
  surfaceSecondary: '#20312B',

  // Text
  text: '#E8F3EF',
  textSecondary: '#A0B4AB',
  textInverse: '#0D1715',

  // Borders and dividers
  border: '#30443B',

  // Status
  success: '#54C99A',
  warning: '#F0B94F',
  danger: '#F07878',

  // Interactive elements
  onPrimary: '#0D1715',
} as const;

export type ThemeColors = {
  [Key in keyof typeof lightColors]: string;
};

export type ThemeMode = 'light' | 'dark' | 'system';

export type ResolvedTheme = 'light' | 'dark';
