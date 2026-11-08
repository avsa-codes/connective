import { Image } from 'expo-image';
import { StyleSheet, View, type ViewStyle } from 'react-native';

import { AppText } from '@/components/ui/app-text';
import { spacing } from '@/constants/theme';

type AppLogoProps = {
  size?: 'sm' | 'md' | 'lg';
  tagline?: boolean;
  style?: ViewStyle;
};

const logoSizes = {
  sm: {
    symbol: 30,
    text: 23,
  },
  md: {
    symbol: 38,
    text: 29,
  },
  lg: {
    symbol: 46,
    text: 35,
  },
} as const;

export function AppLogo({ size = 'md', tagline = false, style }: AppLogoProps) {
  const dimensions = logoSizes[size];

  return (
    <View style={[styles.container, style]}>
      <View style={styles.logoRow}>
        <Image
          source={require('@/assets/branding/connective-symbol.png')}
          contentFit="contain"
          style={{
            width: dimensions.symbol,
            aspectRatio: 177 / 160,
          }}
          accessibilityLabel="Connective symbol"
        />

        <AppText
          variant="heading2"
          style={[styles.wordmark, { fontSize: dimensions.text }]}
        >
          Connective
        </AppText>
      </View>

      {tagline ? (
        <AppText variant="small" color="textSecondary" style={styles.tagline}>
          Your business. Better connected.
        </AppText>
      ) : null}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
  },
  logoRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
  },
  wordmark: {
    fontWeight: '700',
    letterSpacing: -0.8,
  },
  tagline: {
    marginTop: spacing.sm,
    textAlign: 'center',
  },
});
