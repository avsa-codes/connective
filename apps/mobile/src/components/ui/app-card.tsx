import type { ReactNode } from 'react';

import { StyleSheet, View } from 'react-native';

import { borderRadius, spacing } from '@/constants/theme';

import { useTheme } from '@/hooks/use-theme';

type AppCardProps = {
  children: ReactNode;
  padding?: keyof typeof spacing;
  bordered?: boolean;
};

export function AppCard({
  children,
  padding = 'xl',
  bordered = true,
}: AppCardProps) {
  const { colors } = useTheme();

  return (
    <View
      style={[
        styles.card,
        {
          backgroundColor: colors.surface,
          borderColor: colors.border,
          borderWidth: bordered ? 1 : 0,
          padding: spacing[padding],
        },
      ]}
    >
      {children}
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    borderRadius: borderRadius.xl,
  },
});
