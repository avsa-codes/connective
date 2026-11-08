import { useThemeContext } from '@/context/theme-context';

export function useTheme() {
  return useThemeContext();
}

//any components can call : const { colors, mode, resolvedTheme, setMode } = useTheme();

//const { colors } = useTheme();

//<View style={{ backgroundColor: colors.background }} />
