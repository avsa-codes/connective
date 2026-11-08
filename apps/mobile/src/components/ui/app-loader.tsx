import { ActivityIndicator, StyleSheet, View } from 'react-native';

import { AppText } from '@/components/ui/app-text';

import { spacing } from '@/constants/theme';

import { useTheme } from '@/hooks/use-theme';

type AppLoaderProps = {
  message?: string;
  fullScreen?: boolean;
  size?: 'small' | 'large';
};

export function AppLoader({
  message,
  fullScreen = false,
  size = 'large',
}: AppLoaderProps) {
  const { colors } = useTheme();

  return (
    <View
      style={[styles.container, fullScreen && styles.fullScreen]}
      accessibilityRole="progressbar"
      accessibilityLabel={message ?? 'Loading'}
    >
      <ActivityIndicator size={size} color={colors.primary} />

      {message ? (
        <AppText variant="caption" color="textSecondary" style={styles.message}>
          {message}
        </AppText>
      ) : null}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  fullScreen: {
    flex: 1,
  },
  message: {
    marginTop: spacing.md,
    textAlign: 'center',
  },
});
