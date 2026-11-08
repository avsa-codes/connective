import { useState } from 'react';
import {
  Keyboard,
  KeyboardAvoidingView,
  Platform,
  Pressable,
  ScrollView,
  StyleSheet,
  View,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { AppButton } from '@/components/ui/app-button';
import { AppCheckbox } from '@/components/ui/app-checkbox';
import { AppDivider } from '@/components/ui/app-divider';
import { AppFormField } from '@/components/ui/app-form-field';
import { AppLogo } from '@/components/ui/app-logo';
import { AppText } from '@/components/ui/app-text';
import { useTheme } from '@/hooks/use-theme';
import { spacing } from '@/constants/theme';
import { useRouter } from 'expo-router';
import { authClient } from '@/lib/auth-client';

export default function SignupScreen() {
  const { colors } = useTheme();
  const router = useRouter();

  // Signup method
  const [showEmailSignup, setShowEmailSignup] = useState(false);

  // Phone OTP state
  const [phone, setPhone] = useState('');
  const [otp, setOtp] = useState('');
  const [otpSent, setOtpSent] = useState(false);
  const [isPhoneVerified, setIsPhoneVerified] = useState(false);

  // Email signup state
  const [fullName, setFullName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');

  // Shared form state
  const [acceptedTerms, setAcceptedTerms] = useState(false);
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

    if (!acceptedTerms) {
      setFormError('Please accept the Terms & Privacy Policy.');
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

      setIsPhoneVerified(true);
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

  const handleSignUp = async () => {
    Keyboard.dismiss();
    setFormError(null);

    const trimmedName = fullName.trim();
    const normalizedEmail = email.trim().toLowerCase();

    if (!trimmedName || !normalizedEmail || !password || !confirmPassword) {
      setFormError('Please complete all fields.');
      return;
    }

    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(normalizedEmail)) {
      setFormError('Please enter a valid email address.');
      return;
    }

    if (password.length < 8) {
      setFormError('Password must contain at least 8 characters.');
      return;
    }

    if (password !== confirmPassword) {
      setFormError('Your passwords do not match.');
      return;
    }

    if (!acceptedTerms) {
      setFormError('Please accept the Terms & Privacy Policy.');
      return;
    }

    try {
      setIsSubmitting(true);

      const { error } = await authClient.signUp.email({
        name: trimmedName,
        email: normalizedEmail,
        password,
        callbackURL: 'exp://192.168.1.4:8081/--/email-verified',
      });

      if (error) {
        setFormError(error.message || 'Unable to create your account.');
        return;
      }

      router.replace({
        pathname: '/verification-pending',
        params: { email: normalizedEmail },
      });
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
    <SafeAreaView
      style={[styles.screen, { backgroundColor: colors.background }]}
      edges={['top', 'bottom']}
    >
      <KeyboardAvoidingView
        style={[styles.screen, { backgroundColor: colors.background }]}
        behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      >
        <ScrollView
          contentContainerStyle={styles.scrollContent}
          keyboardShouldPersistTaps="handled"
          showsVerticalScrollIndicator={false}
          onScrollBeginDrag={Keyboard.dismiss}
        >
          <View style={styles.container}>
            <View style={styles.header}>
              <AppLogo size="md" tagline />

              <AppText variant="heading2" style={styles.title}>
                {isPhoneVerified
                  ? 'Phone verified'
                  : otpSent
                  ? 'Verify your phone number'
                  : 'Create your account'}
              </AppText>

              {otpSent && !isPhoneVerified && (
                <AppText
                  variant="body"
                  color="textSecondary"
                  style={styles.subtitle}
                >
                  Check WhatsApp for your six-digit verification code.
                </AppText>
              )}
            </View>

            {isPhoneVerified ? (
              <View style={styles.form}>
                <AppText
                  variant="body"
                  color="textSecondary"
                  style={styles.centerText}
                >
                  Your phone number has been verified successfully.
                </AppText>
              </View>
            ) : otpSent ? (
              <View style={styles.form}>
                <AppText variant="bodyMedium" style={styles.phoneDisplay}>
                  +91 {phone}
                </AppText>

                <AppFormField
                  label="Verification code"
                  required
                  placeholder="Enter 6-digit OTP"
                  value={otp}
                  onChangeText={(value) =>
                    setOtp(value.replace(/\D/g, '').slice(0, 6))
                  }
                  keyboardType="number-pad"
                  autoComplete="one-time-code"
                  returnKeyType="done"
                />

                {formError && (
                  <AppText variant="small" color="textSecondary">
                    {formError}
                  </AppText>
                )}

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
                  <AppText variant="bodyMedium" color="primary">
                    Resend OTP
                  </AppText>
                </Pressable>

                <Pressable
                  onPress={handleChangePhone}
                  disabled={isSubmitting}
                  style={styles.textButton}
                >
                  <AppText variant="body" color="textSecondary">
                    Change phone number
                  </AppText>
                </Pressable>
              </View>
            ) : showEmailSignup ? (
              <View style={styles.form}>
                <AppFormField
                  label="Full name"
                  required
                  placeholder="Enter your full name"
                  value={fullName}
                  onChangeText={setFullName}
                  autoCapitalize="words"
                  autoComplete="name"
                  returnKeyType="next"
                />

                <AppFormField
                  label="Email address"
                  required
                  placeholder="you@example.com"
                  value={email}
                  onChangeText={setEmail}
                  keyboardType="email-address"
                  autoCapitalize="none"
                  autoCorrect={false}
                  autoComplete="email"
                  returnKeyType="next"
                />

                <AppFormField
                  label="Password"
                  required
                  placeholder="Create a password"
                  value={password}
                  onChangeText={setPassword}
                  secureTextEntry
                  autoCapitalize="none"
                  autoComplete="new-password"
                  returnKeyType="next"
                />

                <AppFormField
                  label="Confirm password"
                  required
                  placeholder="Re-enter your password"
                  value={confirmPassword}
                  onChangeText={setConfirmPassword}
                  secureTextEntry
                  autoCapitalize="none"
                  autoComplete="new-password"
                  returnKeyType="done"
                />

                <AppCheckbox
                  checked={acceptedTerms}
                  onChange={setAcceptedTerms}
                >
                  <AppText variant="small" color="text">
                    I agree to the{' '}
                    <AppText variant="small" color="primary" onPress={() => {}}>
                      Terms
                    </AppText>
                    {' & '}
                    <AppText variant="small" color="primary" onPress={() => {}}>
                      Privacy Policy
                    </AppText>
                    .
                  </AppText>
                </AppCheckbox>

                {formError && (
                  <AppText variant="small" color="textSecondary">
                    {formError}
                  </AppText>
                )}

                <AppButton
                  title="Create account"
                  onPress={handleSignUp}
                  loading={isSubmitting}
                  disabled={isSubmitting}
                />

                <Pressable
                  onPress={() => {
                    setShowEmailSignup(false);
                    setFormError(null);
                  }}
                  style={styles.textButton}
                >
                  <AppText variant="bodyMedium" color="primary">
                    Sign up with OTP instead
                  </AppText>
                </Pressable>
              </View>
            ) : (
              <View style={styles.form}>
                <AppFormField
                  label="Phone number (+91)"
                  required
                  placeholder="Enter your 10-digit mobile number"
                  value={phone}
                  onChangeText={(value) =>
                    setPhone(value.replace(/\D/g, '').slice(0, 10))
                  }
                  keyboardType="phone-pad"
                  autoComplete="tel"
                  returnKeyType="done"
                />

                <AppCheckbox
                  checked={acceptedTerms}
                  onChange={setAcceptedTerms}
                >
                  <AppText variant="small" color="text">
                    I agree to the{' '}
                    <AppText variant="small" color="primary" onPress={() => {}}>
                      Terms
                    </AppText>
                    {' & '}
                    <AppText variant="small" color="primary" onPress={() => {}}>
                      Privacy Policy
                    </AppText>
                    .
                  </AppText>
                </AppCheckbox>

                {formError && (
                  <AppText variant="small" color="textSecondary">
                    {formError}
                  </AppText>
                )}

                <AppButton
                  title="Continue with OTP"
                  onPress={handleSendOtp}
                  loading={isSubmitting}
                  disabled={isSubmitting}
                />

                <AppDivider label="OR" />

                <Pressable
                  onPress={() => {
                    setShowEmailSignup(true);
                    setFormError(null);
                  }}
                  style={[
                    styles.alternativeButton,
                    {
                      backgroundColor: colors.surface,
                      borderColor: colors.border,
                    },
                  ]}
                >
                  <AppText variant="bodyMedium">
                    Sign up with email and password
                  </AppText>
                </Pressable>
              </View>
            )}

            <View style={styles.footer}>
              <AppText variant="body" color="textSecondary">
                Already have an account?
              </AppText>

              <AppButton
                title="Log in"
                variant="ghost"
                size="sm"
                onPress={() => router.push('/(auth)/login')}
              />
            </View>
          </View>
        </ScrollView>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  screen: {
    flex: 1,
  },
  scrollContent: {
    flexGrow: 1,
    justifyContent: 'flex-start',
    paddingHorizontal: spacing['2xl'],
    paddingTop: spacing['6xl'],
    paddingBottom: spacing.lg,
  },
  container: {
    width: '100%',
    maxWidth: 440,
    alignSelf: 'center',
    gap: spacing.md,
  },
  header: {
    alignItems: 'center',
    gap: spacing.sm,
    marginBottom: spacing.xs,
  },
  title: {
    textAlign: 'center',
    marginTop: spacing.sm,
  },
  subtitle: {
    textAlign: 'center',
  },
  form: {
    gap: spacing.md,
  },
  phoneDisplay: {
    textAlign: 'center',
  },
  centerText: {
    textAlign: 'center',
  },
  textButton: {
    alignItems: 'center',
    paddingVertical: spacing.xs,
  },
  alternativeButton: {
    minHeight: 52,
    width: '100%',
    borderWidth: 1,
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
  },
});
