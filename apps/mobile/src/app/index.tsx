import { useEffect, useState } from 'react';
import { StyleSheet, View } from 'react-native';
import { useRouter } from 'expo-router';
import * as SecureStore from 'expo-secure-store';

import { AppLogo } from '@/components/ui/app-logo';
import { AppText } from '@/components/ui/app-text';
import { useTheme } from '@/hooks/use-theme';
import { spacing } from '@/constants/theme';
import { authClient } from '@/lib/auth-client';

const STORAGE_KEY = 'connective_cookie';

export default function HomeScreen() {
  const router = useRouter();
  const { colors } = useTheme();

  const [isReady, setIsReady] = useState(false);
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  useEffect(() => {
    let active = true;

    const initializeApp = async () => {
      try {
        // Check local storage first. Do not wait for the API.
        const cookie = await SecureStore.getItemAsync(STORAGE_KEY);

        if (!active) return;

        if (!cookie) {
          router.replace('/(auth)/login');
          return;
        }

        // Show Home immediately if a cookie exists.
        setIsAuthenticated(true);
        setIsReady(true);

        // Validate the session quietly in the background.
        try {
          const { data, error } = await authClient.getSession();

          if (!active) return;

          // Only redirect when the server successfully confirms
          // that no authenticated session exists.
          if (!error && !data?.session) {
            await SecureStore.deleteItemAsync(STORAGE_KEY);

            if (active) {
              setIsAuthenticated(false);
              router.replace('/(auth)/login');
            }
          }
        } catch {
          // A network failure should not immediately log out the user.
        }
      } catch (error) {
        console.error('Local session check failed:', error);

        if (active) {
          router.replace('/(auth)/login');
        }
      }
    };

    void initializeApp();

    return () => {
      active = false;
    };
  }, []);

  if (!isReady || !isAuthenticated) {
    return null;
  }

  return (
    <View style={styles.container}>
      <AppLogo size="lg" tagline />

      <View style={styles.content}>
        <AppText variant="heading1">Welcome to Connective!</AppText>

        <AppText color="textSecondary">Your business, connected.</AppText>

        <AppText variant="body">You are successfully logged in.</AppText>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: spacing['2xl'],
    justifyContent: 'center',
    alignItems: 'center',
    gap: spacing['3xl'],
  },
  content: {
    width: '100%',
    gap: spacing.md,
  },
});
