  import {
    ActivityIndicator,
    Pressable,
    StyleSheet,
    type PressableProps,
    type StyleProp,
    type ViewStyle,
  } from 'react-native';

  import { AppText } from '@/components/ui/app-text';
  import { borderRadius, dimensions, spacing } from '@/constants/theme';
  import { useTheme } from '@/hooks/use-theme';

  type ButtonVariant = 'primary' | 'secondary' | 'outline' | 'ghost' | 'danger';

  type ButtonSize = 'sm' | 'md' | 'lg';

  type AppButtonProps = Omit<PressableProps, 'style' | 'children'> & {
    title: string;
    variant?: ButtonVariant;
    size?: ButtonSize;
    loading?: boolean;
    fullWidth?: boolean;
    style?: StyleProp<ViewStyle>;
  };

  export function AppButton({
    title,
    variant = 'primary',
    size = 'lg',
    loading = false,
    disabled = false,
    fullWidth = true,
    style,
    ...rest
  }: AppButtonProps) {
    const { colors } = useTheme();

    const isDisabled = disabled || loading;

    const variantStyles = {
      primary: {
        backgroundColor: colors.primary,
        borderColor: colors.primary,
        textColor: colors.onPrimary,
      },
      secondary: {
        backgroundColor: colors.primaryLight,
        borderColor: colors.primaryLight,
        textColor: colors.primary,
      },
      outline: {
        backgroundColor: 'transparent',
        borderColor: colors.border,
        textColor: colors.text,
      },
      ghost: {
        backgroundColor: 'transparent',
        borderColor: 'transparent',
        textColor: colors.primary,
      },
      danger: {
        backgroundColor: colors.danger,
        borderColor: colors.danger,
        textColor: '#FFFFFF',
      },
    };

    const sizeStyles = {
      sm: {
        height: 40,
        paddingHorizontal: spacing.lg,
      },
      md: {
        height: 48,
        paddingHorizontal: spacing.xl,
      },
      lg: {
        height: dimensions.buttonHeight,
        paddingHorizontal: spacing['2xl'],
      },
    };

    const currentVariant = variantStyles[variant];
    const currentSize = sizeStyles[size];

    return (
      <Pressable
        {...rest}
        disabled={isDisabled}
        accessibilityRole="button"
        accessibilityState={{
          disabled: isDisabled,
          busy: loading,
        }}
        style={({ pressed }) => [
          styles.button,
          currentSize,
          {
            backgroundColor: currentVariant.backgroundColor,
            borderColor: currentVariant.borderColor,
            opacity: isDisabled ? 0.5 : pressed ? 0.85 : 1,
            width: fullWidth ? '100%' : undefined,
          },
          style,
        ]}
      >
        {loading ? (
          <ActivityIndicator color={currentVariant.textColor} size="small" />
        ) : (
          <AppText
            variant="bodyMedium"
            style={{ color: currentVariant.textColor }}
          >
            {title}
          </AppText>
        )}
      </Pressable>
    );
  }

  const styles = StyleSheet.create({
    button: {
      flexDirection: 'row',
      alignItems: 'center',
      justifyContent: 'center',
      borderWidth: 1,
      borderRadius: borderRadius.lg,
    },
  });