import type { ReactNode } from 'react';

import {
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  StyleSheet,
  type ScrollViewProps,
  type StyleProp,
  type ViewStyle,
} from 'react-native';

type AppKeyboardViewProps = {
  children: ReactNode;
  scrollable?: boolean;
  contentContainerStyle?: StyleProp<ViewStyle>;
  scrollViewProps?: Omit<ScrollViewProps, 'contentContainerStyle'>;
};

export function AppKeyboardView({
  children,
  scrollable = true,
  contentContainerStyle,
  scrollViewProps,
}: AppKeyboardViewProps) {
  const content = scrollable ? (
    <ScrollView
      {...scrollViewProps}
      contentContainerStyle={[styles.scrollContent, contentContainerStyle]}
      keyboardShouldPersistTaps={
        scrollViewProps?.keyboardShouldPersistTaps ?? 'handled'
      }
    >
      {children}
    </ScrollView>
  ) : (
    children
  );

  return (
    <KeyboardAvoidingView
      style={styles.container}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      {content}
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  scrollContent: {
    flexGrow: 1,
  },
});
