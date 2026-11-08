import type { ReactNode } from 'react';

import { Modal, Pressable, StyleSheet, View } from 'react-native';

import { SafeAreaView } from 'react-native-safe-area-context';

import { AppText } from '@/components/ui/app-text';

import { borderRadius, dimensions, spacing } from '@/constants/theme';

import { useTheme } from '@/hooks/use-theme';

type AppModalProps = {
  visible: boolean;
  onClose: () => void;
  children: ReactNode;
  title?: string;
  showCloseButton?: boolean;
  dismissOnBackdropPress?: boolean;
};

export function AppModal({
  visible,
  onClose,
  children,
  title,
  showCloseButton = true,
  dismissOnBackdropPress = true,
}: AppModalProps) {
  const { colors } = useTheme();

  return (
    <Modal
      visible={visible}
      transparent
      animationType="fade"
      statusBarTranslucent
      onRequestClose={onClose}
    >
      <View style={styles.overlay}>
        <Pressable
          style={styles.backdrop}
          onPress={dismissOnBackdropPress ? onClose : undefined}
          accessible={false}
        />

        <SafeAreaView style={styles.safeArea} pointerEvents="box-none">
          <View
            style={[
              styles.modal,
              {
                backgroundColor: colors.surface,
                borderColor: colors.border,
              },
            ]}
            accessibilityViewIsModal
          >
            {(title || showCloseButton) && (
              <View style={styles.header}>
                {title ? (
                  <AppText variant="heading3">{title}</AppText>
                ) : (
                  <View />
                )}

                {showCloseButton ? (
                  <Pressable
                    onPress={onClose}
                    hitSlop={8}
                    accessibilityRole="button"
                    accessibilityLabel="Close dialog"
                    style={styles.closeButton}
                  >
                    <AppText variant="heading3" color="textSecondary">
                      ×
                    </AppText>
                  </Pressable>
                ) : null}
              </View>
            )}

            <View style={styles.body}>{children}</View>
          </View>
        </SafeAreaView>
      </View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  overlay: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'rgba(0, 0, 0, 0.45)',
  },
  backdrop: {
    ...StyleSheet.absoluteFill,
  },
  safeArea: {
    width: '100%' as const,
    alignItems: 'center',
    justifyContent: 'center',
  },
  modal: {
    width: '90%',
    maxWidth: dimensions.maxContentWidth,
    borderWidth: 1,
    borderRadius: borderRadius['2xl'],
    padding: spacing.xl,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginBottom: spacing.lg,
  },
  closeButton: {
    width: 32,
    height: 32,
    alignItems: 'center',
    justifyContent: 'center',
  },
  body: {
    width: '100%',
  },
});
