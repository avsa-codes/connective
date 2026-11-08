import type { ReactNode } from 'react';

import {
  ScrollView,
  StyleSheet,
  View,
  type ScrollViewProps,
} from 'react-native';

import { SafeAreaView } from 'react-native-safe-area-context';

import { dimensions, spacing } from '@/constants/theme';
import { useTheme } from '@/hooks/use-theme';

type AppScreenProps = {
  children: ReactNode;
  scrollable?: boolean;
  padded?: boolean;
  safeArea?: boolean;
  scrollViewProps?: Omit<ScrollViewProps, 'contentContainerStyle'>;
};

export function AppScreen({
  children,
  scrollable = false,
  padded = true,
  safeArea = true,
  scrollViewProps,
}: AppScreenProps) {
  const { colors } = useTheme();

  const content = scrollable ? (
    <ScrollView
      {...scrollViewProps}
      style={styles.scrollView}
      contentContainerStyle={[
        styles.content,
        styles.scrollContent,
        padded && styles.padded,
      ]}
      keyboardShouldPersistTaps={
        scrollViewProps?.keyboardShouldPersistTaps ?? 'handled'
      }
    >
      {children}
    </ScrollView>
  ) : (
    <View style={[styles.content, styles.flexContent, padded && styles.padded]}>
      {children}
    </View>
  );

  if (!safeArea) {
    return (
      <View style={[styles.container, { backgroundColor: colors.background }]}>
        {content}
      </View>
    );
  }

  return (
    <SafeAreaView
      edges={['top', 'right', 'bottom', 'left']}
      style={[styles.container, { backgroundColor: colors.background }]}
    >
      {content}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  scrollView: {
    flex: 1,
  },
  content: {
    width: '100%',
    maxWidth: dimensions.maxContentWidth,
    alignSelf: 'center',
  },
  padded: {
    paddingHorizontal: dimensions.screenPadding,
  },
  flexContent: {
    flex: 1,
  },
  scrollContent: {
    flexGrow: 1,
    paddingVertical: spacing.lg,
  },
});
