import { useState } from 'react';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { StyleSheet, View } from 'react-native';

import { AppLogo } from '@/components/ui/app-logo';
import { AppText } from '@/components/ui/app-text';
import { AppButton } from '@/components/ui/app-button';
import { authClient } from '@/lib/auth-client';
import { spacing } from '@/constants/theme';
import * as Linking from 'expo-linking';

export default function VerificationPendingScreen() {
  const router = useRouter();
  const { email } = useLocalSearchParams<{ email: string }>();

  const [isResending, setIsResending] = useState(false);
  const [message, setMessage] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const handleResend = async () => {
    if (!email || isResending) return;

    setIsResending(true);
    setMessage(null);
    setError(null);

    try {
      const { error: resendError } = await authClient.sendVerificationEmail({
        email,
        callbackURL: 'exp://192.168.1.4:8081/--/email-verified',
      });

      if (resendError) {
        setError(resendError.message || 'Unable to resend verification email.');
      } else {
        setMessage(
          'If your account needs verification, a new email has been sent.'
        );
      }
    } catch {
      setError('Unable to connect to the server. Please try again.');
    } finally {
      setIsResending(false);
    }
  };

  return (
    <View style={styles.container}>
      <AppLogo size="lg" tagline />

      <View style={styles.content}>
        <AppText variant="heading2">Check your email</AppText>

        <AppText color="textSecondary">
          We've sent a verification link to:
        </AppText>

        <AppText variant="body" style={styles.email}>
          {email}
        </AppText>

        <AppText color="textSecondary">
          Open the email and follow the link to verify your account. Once
          verified, you'll be able to access Connective.
        </AppText>

        {message ? (
          <AppText color="success" variant="small">
            {message}
          </AppText>
        ) : null}

        {error ? (
          <AppText color="textSecondary" variant="small">
            {error}
          </AppText>
        ) : null}

        <AppButton
          title="Resend verification email"
          onPress={handleResend}
          loading={isResending}
          disabled={isResending}
        />

        <AppButton
          title="Back to login"
          variant="outline"
          onPress={() => router.replace('/login')}
        />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: spacing['2xl'],
    justifyContent: 'center',
    gap: spacing['3xl'],
    backgroundColor: 'black',
  },
  content: {
    gap: spacing.lg,
  },
  email: {
    fontWeight: '700',
  },
});
