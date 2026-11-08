import {
  createContext,
  useContext,
  useMemo,
  useState,
  type ReactNode,
} from 'react';

import { useColorScheme } from 'react-native';

import {
  lightColors,
  darkColors,
  type ThemeColors,
  type ThemeMode,
  type ResolvedTheme,
} from '@/constants/theme';

type ThemeContextValue = {
  mode: ThemeMode;
  resolvedTheme: ResolvedTheme;
  colors: ThemeColors;
  setMode: (mode: ThemeMode) => void;
};

const ThemeContext = createContext<ThemeContextValue | undefined>(undefined);

type ThemeProviderProps = {
  children: ReactNode;
};

export function ThemeProvider({ children }: ThemeProviderProps) {
  const systemColorScheme = useColorScheme();

  const [mode, setMode] = useState<ThemeMode>('system');

  const resolvedTheme: ResolvedTheme =
    mode === 'system'
      ? systemColorScheme === 'dark'
        ? 'dark'
        : 'light'
      : mode;

  const colors = resolvedTheme === 'dark' ? darkColors : lightColors;

  const value = useMemo(
    () => ({
      mode,
      resolvedTheme,
      colors,
      setMode,
    }),
    [mode, resolvedTheme, colors]
  );

  return (
    <ThemeContext.Provider value={value}>{children}</ThemeContext.Provider>
  );
}

export function useThemeContext() {
  const context = useContext(ThemeContext);

  if (!context) {
    throw new Error('useThemeContext must be used within ThemeProvider');
  }

  return context;
}
