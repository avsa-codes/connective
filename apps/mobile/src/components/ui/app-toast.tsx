import { Pressable, StyleSheet, View } from 'react-native';

import { AppText } from '@/components/ui/app-text';
import { borderRadius, spacing } from '@/constants/theme';
import type { ToastType } from '@/context/toast-context';
import { useTheme } from '@/hooks/use-theme';

type AppToastProps = {
  message: string;
  type: ToastType;
  onDismiss: () => void;
};

export function AppToast({ message, type, onDismiss }: AppToastProps) {
  const { colors } = useTheme();

  const typeColors = {
    success: colors.success,
    error: colors.danger,
    info: colors.primary,
  };

  const statusLabels = {
    success: 'Success',
    error: 'Error',
    info: 'Information',
  };

  return (
    <View
      style={[
        styles.container,
        {
          backgroundColor: colors.surface,
          borderColor: colors.border,
          borderLeftColor: typeColors[type],
        },
      ]}
      accessibilityRole="alert"
      accessibilityLiveRegion="polite"
    >
      <View style={styles.content}>
        <AppText variant="label" style={{ color: typeColors[type] }}>
          {statusLabels[type]}
        </AppText>

        <AppText variant="caption" color="text" style={styles.message}>
          {message}
        </AppText>
      </View>

      <Pressable
        onPress={onDismiss}
        hitSlop={8}
        accessibilityRole="button"
        accessibilityLabel="Dismiss notification"
        style={styles.dismiss}
      >
        <AppText color="textSecondary" variant="bodyMedium">
          ×
        </AppText>
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderLeftWidth: 4,
    borderRadius: borderRadius.lg,
    padding: spacing.lg,
    elevation: 5,
    shadowColor: '#000000',
    shadowOffset: { width: 0, height: 3 },
    shadowOpacity: 0.12,
    shadowRadius: 8,
  },
  content: {
    flex: 1,
  },
  message: {
    marginTop: spacing.xs,
  },
  dismiss: {
    paddingLeft: spacing.md,
    paddingVertical: spacing.xs,
  },
});
