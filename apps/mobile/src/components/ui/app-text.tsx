import {
  Text,
  type TextProps,
  type StyleProp,
  type TextStyle,
} from 'react-native';

import { typography, type ThemeColors } from '@/constants/theme';

import { useTheme } from '@/hooks/use-theme';

type TypographyVariant = keyof typeof typography;

type AppTextProps = TextProps & {
  variant?: TypographyVariant;
  color?: keyof ThemeColors;
  style?: StyleProp<TextStyle>;
};

export function AppText({
  variant = 'body',
  color = 'text',
  style,
  children,
  ...rest
}: AppTextProps) {
  const { colors } = useTheme();

  return (
    <Text
      {...rest}
      style={[typography[variant], { color: colors[color] }, style]}
    >
      {children}
    </Text>
  );
}
