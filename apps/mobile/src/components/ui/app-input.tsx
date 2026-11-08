import { useState, type ReactNode } from 'react';

import {
  Pressable,
  StyleSheet,
  TextInput,
  View,
  type TextInputProps,
  type StyleProp,
  type TextStyle,
  type ViewStyle,
} from 'react-native';

import {
  borderRadius,
  dimensions,
  fontFamilies,
  fontSizes,
  spacing,
} from '@/constants/theme';

import { AppText } from '@/components/ui/app-text';
import { useTheme } from '@/hooks/use-theme';

type AppInputProps = Omit<TextInputProps, 'style'> & {
  label?: string;
  error?: string;
  helperText?: string;
  leftElement?: ReactNode;
  rightElement?: ReactNode;
  containerStyle?: StyleProp<ViewStyle>;
  inputStyle?: StyleProp<TextStyle>;
};

export function AppInput({
  label,
  error,
  helperText,
  leftElement,
  rightElement,
  containerStyle,
  inputStyle,
  secureTextEntry,
  editable = true,
  ...rest
}: AppInputProps) {
  const { colors } = useTheme();
  const [passwordVisible, setPasswordVisible] = useState(false);

  const isPassword = secureTextEntry === true;

  const borderColor = error ? colors.danger : colors.border;

  return (
    <View style={[styles.container, containerStyle]}>
      {label ? (
        <AppText variant="label" style={styles.label}>
          {label}
        </AppText>
      ) : null}

      <View
        style={[
          styles.inputContainer,
          {
            backgroundColor: colors.surface,
            borderColor,
            opacity: editable ? 1 : 0.6,
          },
        ]}
      >
        {leftElement}

        <TextInput
          {...rest}
          editable={editable}
          secureTextEntry={isPassword ? !passwordVisible : secureTextEntry}
          placeholderTextColor={colors.textSecondary}
          selectionColor={colors.primary}
          style={[
            styles.input,
            {
              color: colors.text,
            },
            inputStyle,
          ]}
        />

        {isPassword ? (
          <Pressable
            onPress={() => setPasswordVisible((visible) => !visible)}
            accessibilityRole="button"
            accessibilityLabel={
              passwordVisible ? 'Hide password' : 'Show password'
            }
            hitSlop={8}
            style={styles.passwordToggle}
          >
            <AppText variant="caption" color="primary">
              {passwordVisible ? 'Hide' : 'Show'}
            </AppText>
          </Pressable>
        ) : null}

        {rightElement}
      </View>

      {error ? (
        <AppText
          variant="small"
          color="danger"
          style={styles.message}
          accessibilityRole="alert"
        >
          {error}
        </AppText>
      ) : helperText ? (
        <AppText variant="small" color="textSecondary" style={styles.message}>
          {helperText}
        </AppText>
      ) : null}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    width: '100%',
  },
  label: {
    marginBottom: spacing.xs,
  },
  inputContainer: {
    minHeight: dimensions.inputHeight,
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderRadius: borderRadius.lg,
    paddingHorizontal: spacing.lg,
  },
  input: {
    flex: 1,
    minWidth: 0,
    minHeight: dimensions.inputHeight - 2,
    paddingVertical: spacing.sm,
    fontFamily: fontFamilies.regular,
    fontSize: fontSizes.md,
  },
  passwordToggle: {
    marginLeft: spacing.sm,
    padding: spacing.xs,
  },
  message: {
    marginTop: spacing.xs,
  },
});
