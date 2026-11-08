import { useState } from 'react';
import { Keyboard, Pressable, StyleSheet, View } from 'react-native';
import { useRouter } from 'expo-router';
import { AppLogo } from '@/components/ui/app-logo';
import { AppText } from '@/components/ui/app-text';
import { AppButton } from '@/components/ui/app-button';
import { AppInput } from '@/components/ui/app-input';
import { AppDivider } from '@/components/ui/app-divider';
import { spacing } from '@/constants/theme';
import { authClient } from '@/lib/auth-client';

export default function LoginScreen() {
  const router = useRouter();

  // Login method
  const [showEmailLogin, setShowEmailLogin] = useState(false);

  // Phone OTP state
  const [phone, setPhone] = useState('');
  const [otp, setOtp] = useState('');
  const [otpSent, setOtpSent] = useState(false);

  // Email login state
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  // Shared form state
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [formError, setFormError] = useState<string | null>(null);

  const handleSendOtp = async () => {
    Keyboard.dismiss();
    setFormError(null);

    const normalizedPhone = phone.replace(/\D/g, '');

    if (!/^[6-9]\d{9}$/.test(normalizedPhone)) {
      setFormError('Please enter a valid 10-digit mobile number.');
      return;
    }

    try {
      setIsSubmitting(true);

      const { error } = await authClient.phoneNumber.sendOtp({
        phoneNumber: `+91${normalizedPhone}`,
      });

      if (error) {
        setFormError(error.message || 'Unable to send OTP.');
        return;
      }

      setPhone(normalizedPhone);
      setOtpSent(true);
      setOtp('');
    } catch {
      setFormError('Unable to connect to the server. Please try again.');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleVerifyOtp = async () => {
    Keyboard.dismiss();
    setFormError(null);

    if (!/^\d{6}$/.test(otp)) {
      setFormError('Please enter the six-digit verification code.');
      return;
    }

    try {
      setIsSubmitting(true);

      const { error } = await authClient.phoneNumber.verify({
        phoneNumber: `+91${phone}`,
        code: otp,
      });

      if (error) {
        setFormError(error.message || 'Invalid or expired OTP.');
        return;
      }

      router.replace('/');
    } catch {
      setFormError('Unable to verify your code. Please try again.');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleResendOtp = async () => {
    Keyboard.dismiss();
    setFormError(null);
    setOtp('');

    try {
      setIsSubmitting(true);

      const { error } = await authClient.phoneNumber.sendOtp({
        phoneNumber: `+91${phone}`,
      });

      if (error) {
        setFormError(error.message || 'Unable to resend OTP.');
      }
    } catch {
      setFormError('Unable to connect to the server. Please try again.');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleLogin = async () => {
    Keyboard.dismiss();
    setFormError(null);

    const normalizedEmail = email.trim().toLowerCase();

    if (!normalizedEmail || !password) {
      setFormError('Please complete all fields.');
      return;
    }

    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(normalizedEmail)) {
      setFormError('Please enter a valid email address.');
      return;
    }

    try {
      setIsSubmitting(true);

      const { error } = await authClient.signIn.email({
        email: normalizedEmail,
        password,
      });

      if (error) {
        setFormError(error.message || 'Unable to log in.');
        return;
      }

      router.replace('/');
    } catch {
      setFormError('Unable to connect to the server. Please try again.');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleChangePhone = () => {
    setOtpSent(false);
    setOtp('');
    setFormError(null);
  };

  return (
    <View style={styles.container}>
      <AppLogo size="lg" tagline />

      <View style={styles.content}>
        <AppText variant="heading2">
          {otpSent ? 'Verify your phone number' : 'Welcome back'}
        </AppText>

        <AppText color="textSecondary">
          {otpSent
            ? 'Check WhatsApp for your six-digit verification code.'
            : 'Login to your Connective account.'}
        </AppText>

        {otpSent ? (
          <>
            <AppText variant="bodyMedium">+91 {phone}</AppText>

            <AppInput
              label="Verification code"
              placeholder="Enter 6-digit OTP"
              value={otp}
              onChangeText={(value) =>
                setOtp(value.replace(/\D/g, '').slice(0, 6))
              }
              keyboardType="number-pad"
            />

            {formError && <AppText color="textSecondary">{formError}</AppText>}

            <AppButton
              title="Verify and continue"
              onPress={handleVerifyOtp}
              loading={isSubmitting}
              disabled={isSubmitting}
            />

            <Pressable
              onPress={handleResendOtp}
              disabled={isSubmitting}
              style={styles.textButton}
            >
              <AppText color="primary">Resend OTP</AppText>
            </Pressable>

            <Pressable
              onPress={handleChangePhone}
              disabled={isSubmitting}
              style={styles.textButton}
            >
              <AppText color="textSecondary">Change phone number</AppText>
            </Pressable>
          </>
        ) : showEmailLogin ? (
          <>
            <AppInput
              label="Email address"
              placeholder="Enter your email"
              value={email}
              onChangeText={setEmail}
              keyboardType="email-address"
              autoCapitalize="none"
            />

            <AppInput
              label="Password"
              placeholder="Enter your password"
              value={password}
              onChangeText={setPassword}
              secureTextEntry
            />

            {formError && <AppText color="textSecondary">{formError}</AppText>}

            <AppButton
              title="Login"
              onPress={handleLogin}
              loading={isSubmitting}
              disabled={isSubmitting}
            />

            <Pressable
              onPress={() => {
                setShowEmailLogin(false);
                setFormError(null);
              }}
              style={styles.textButton}
            >
              <AppText color="primary">Login with OTP instead</AppText>
            </Pressable>
          </>
        ) : (
          <>
            <AppInput
              label="Phone number (+91)"
              placeholder="Enter your 10-digit mobile number"
              value={phone}
              onChangeText={(value) =>
                setPhone(value.replace(/\D/g, '').slice(0, 10))
              }
              keyboardType="phone-pad"
            />

            {formError && <AppText color="textSecondary">{formError}</AppText>}

            <AppButton
              title="Continue with OTP"
              onPress={handleSendOtp}
              loading={isSubmitting}
              disabled={isSubmitting}
            />

            <AppDivider label="OR" />

            <Pressable
              onPress={() => {
                setShowEmailLogin(true);
                setFormError(null);
              }}
              style={styles.alternativeButton}
            >
              <AppText variant="bodyMedium">
                Login with email and password
              </AppText>
            </Pressable>
          </>
        )}

        <View style={styles.footer}>
          <AppText color="textSecondary">Don't have an account?</AppText>

          <AppButton
            title="Sign up"
            onPress={() => router.replace('/signup')}
            variant="ghost"
            size="sm"
          />
        </View>
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
    gap: spacing.md,
  },
  textButton: {
    alignItems: 'center',
    paddingVertical: spacing.xs,
  },
  alternativeButton: {
    minHeight: 52,
    width: '100%',
    borderWidth: 1,
    borderColor: '#555555',
    borderRadius: 14,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: spacing.md,
  },
  footer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    flexWrap: 'wrap',
    gap: spacing.xs,
    marginTop: spacing.md,
  },
});
