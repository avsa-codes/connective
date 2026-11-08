import type { ReactNode } from 'react';

import { Pressable, StyleSheet, type PressableProps } from 'react-native';

import { borderRadius, spacing } from '@/constants/theme';

import { useTheme } from '@/hooks/use-theme';

type IconButtonSize = 'sm' | 'md' | 'lg';

type AppIconButtonProps = {
  icon: ReactNode;
  accessibilityLabel: string;
  onPress: PressableProps['onPress'];
  size?: IconButtonSize;
  disabled?: boolean;
  variant?: 'filled' | 'outlined' | 'ghost';
};

export function AppIconButton({
  icon,
  accessibilityLabel,
  onPress,
  size = 'md',
  disabled = false,
  variant = 'ghost',
}: AppIconButtonProps) {
  const { colors } = useTheme();

  const dimensions = {
    sm: 36,
    md: 44,
    lg: 52,
  };

  const backgrounds = {
    filled: colors.primaryLight,
    outlined: 'transparent',
    ghost: 'transparent',
  };

  return (
    <Pressable
      onPress={onPress}
      disabled={disabled}
      accessibilityRole="button"
      accessibilityLabel={accessibilityLabel}
      accessibilityState={{ disabled }}
      hitSlop={spacing.xs}
      style={({ pressed }) => [
        styles.button,
        {
          width: dimensions[size],
          height: dimensions[size],
          borderRadius: borderRadius.lg,
          backgroundColor: backgrounds[variant],
          borderWidth: variant === 'outlined' ? 1 : 0,
          borderColor: colors.border,
          opacity: disabled ? 0.5 : pressed ? 0.7 : 1,
        },
      ]}
    >
      {icon}
    </Pressable>
  );
}

const styles = StyleSheet.create({
  button: {
    alignItems: 'center',
    justifyContent: 'center',
  },
});
