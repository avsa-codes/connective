import { StyleSheet, View } from 'react-native';

import { AppText } from '@/components/ui/app-text';
import { spacing } from '@/constants/theme';
import { useTheme } from '@/hooks/use-theme';

type AppDividerProps = {
  label?: string;
};

export function AppDivider({ label }: AppDividerProps) {
  const { colors } = useTheme();

  return (
    <View style={styles.container}>
      <View style={[styles.line, { backgroundColor: colors.border }]} />

      {label ? (
        <AppText variant="caption" color="textSecondary" style={styles.label}>
          {label}
        </AppText>
      ) : null}

      <View style={[styles.line, { backgroundColor: colors.border }]} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    width: '100%',
  },
  line: {
    flex: 1,
    height: StyleSheet.hairlineWidth,
  },
  label: {
    marginHorizontal: spacing.lg,
  },
});
