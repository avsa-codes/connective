import { useEffect, useState } from 'react';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { StyleSheet, View, ActivityIndicator } from 'react-native';
import * as SecureStore from 'expo-secure-store';
import { getSetCookie } from '@better-auth/expo/client';

import { AppText } from '@/components/ui/app-text';
import { AppButton } from '@/components/ui/app-button';
import { useTheme } from '@/hooks/use-theme';
import { authClient } from '@/lib/auth-client';
import { spacing } from '@/constants/theme';

export default function EmailVerifiedScreen() {
  const router = useRouter();

  const params = useLocalSearchParams<{
    error?: string;
    cookie?: string;
  }>();

  const { colors } = useTheme();

  const [isChecking, setIsChecking] = useState(true);
  const [isVerified, setIsVerified] = useState(false);

  useEffect(() => {
    let active = true;

    const checkSession = async () => {
      try {
        if (params.error) return;

        // Restore the session cookie delivered by the verification redirect.
        if (params.cookie) {
          const storageKey = 'connective_cookie';
          const existingCookie = await SecureStore.getItemAsync(storageKey);

          const updatedCookie = getSetCookie(
            params.cookie,
            existingCookie ?? undefined
          );

          await SecureStore.setItemAsync(storageKey, updatedCookie);
        }

        // Verify that the restored session belongs to a verified user.
        for (let attempt = 0; attempt < 5; attempt++) {
          const { data, error } = await authClient.getSession();

          if (error) {
            throw error;
          }

          if (data?.user?.emailVerified) {
            if (active) setIsVerified(true);
            return;
          }

          await new Promise((resolve) => setTimeout(resolve, 1000));
        }
      } catch (error) {
        console.error('Email verification session restoration failed:', error);
      } finally {
        if (active) setIsChecking(false);
      }
    };

    void checkSession();

    return () => {
      active = false;
    };
  }, [params.cookie, params.error]);

  if (isChecking) {
    return (
      <View style={styles.container}>
        <ActivityIndicator size="large" color={colors.primary} />
        <AppText color="textSecondary">Confirming your email...</AppText>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <AppText variant="heading2">
        {isVerified ? 'Email verified!' : 'Verification incomplete'}
      </AppText>

      <AppText color="textSecondary">
        {isVerified
          ? 'Your email address has been verified successfully.'
          : 'We could not restore your verified session. Please try logging in.'}
      </AppText>

      <AppButton
        title={isVerified ? 'Continue to Connective' : 'Go to login'}
        onPress={() => router.replace(isVerified ? '/' : '/(auth)/login')}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: spacing['2xl'],
    justifyContent: 'center',
    alignItems: 'center',
    gap: spacing.lg,
    backgroundColor: 'black',
  },
});
