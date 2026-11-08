import { Pressable, StyleSheet, View } from 'react-native';

import { AppText } from '@/components/ui/app-text';
import { borderRadius, spacing } from '@/constants/theme';
import { useTheme } from '@/hooks/use-theme';

type AppCheckboxProps = {
  checked: boolean;
  onChange: (checked: boolean) => void;
  label?: string;
  disabled?: boolean;
  children?: React.ReactNode;
};

export function AppCheckbox({
  checked,
  onChange,
  label,
  disabled = false,
  children,
}: AppCheckboxProps) {
  const { colors } = useTheme();

  return (
    <Pressable
      onPress={() => onChange(!checked)}
      disabled={disabled}
      accessibilityRole="checkbox"
      accessibilityState={{ checked, disabled }}
      style={({ pressed }) => [
        styles.container,
        {
          opacity: disabled ? 0.5 : pressed ? 0.75 : 1,
        },
      ]}
    >
      <View
        style={[
          styles.checkbox,
          {
            backgroundColor: checked ? colors.primary : 'transparent',
            borderColor: checked ? colors.primary : colors.border,
          },
        ]}
      >
        {checked ? (
          <View style={styles.checkmark}>
            <View style={styles.checkmarkStem} />
            <View style={styles.checkmarkArm} />
          </View>
        ) : null}
      </View>

      {children ? (
        <View style={styles.label}>{children}</View>
      ) : label ? (
        <AppText variant="caption" color="text" style={styles.label}>
          {label}
        </AppText>
      ) : null}
    </Pressable>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    gap: spacing.md,
  },
  checkbox: {
    width: 20,
    height: 20,
    marginTop: 1,
    borderWidth: 1.5,
    borderRadius: borderRadius.sm,
    alignItems: 'center',
    justifyContent: 'center',
  },
  checkmark: {
    width: 11,
    height: 8,
    position: 'relative',
  },
  checkmarkStem: {
    position: 'absolute',
    width: 2,
    height: 5,
    left: 2,
    top: 2,
    backgroundColor: '#FFFFFF',
    transform: [{ rotate: '-45deg' }],
  },
  checkmarkArm: {
    position: 'absolute',
    width: 2,
    height: 9,
    left: 6,
    top: -1,
    backgroundColor: '#FFFFFF',
    transform: [{ rotate: '45deg' }],
  },
  label: {
    flex: 1,
  },
});
