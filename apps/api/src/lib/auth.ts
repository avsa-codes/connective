import { betterAuth } from 'better-auth';
import { prismaAdapter } from 'better-auth/adapters/prisma';
import { phoneNumber } from 'better-auth/plugins';
import { db } from './db.js';
import { sendVerificationEmail } from '../services/email/templates/verification-email.js';
import { sendWhatsAppOtp } from '../services/whatsapp/fast2sms.service.js';
import { env } from '../config/env.js';
import { expo } from '@better-auth/expo';

const TEMP_EMAIL_DOMAIN = 'phone.connective.invalid';

export const auth = betterAuth({
  baseURL: env.BETTER_AUTH_URL,
  secret: env.BETTER_AUTH_SECRET,

  database: prismaAdapter(db, {
    provider: 'postgresql',
  }),

  trustedOrigins: [
    'connective://',
    ...(env.NODE_ENV === 'development'
      ? ['exp://', 'exp://**', 'exp://192.168.*.*:*/**']
      : []),
  ],

  emailAndPassword: {
    enabled: true,
    requireEmailVerification: true,
  },

  emailVerification: {
    sendOnSignUp: true,
    sendOnSignIn: true,
    autoSignInAfterVerification: true,
    expiresIn: 30 * 30,

    sendVerificationEmail: async ({ user, url }) => {
      // Do not send verification emails to placeholder emails.
      if (user.email.endsWith(`@${TEMP_EMAIL_DOMAIN}`)) {
        return;
      }

      await sendVerificationEmail({
        name: user.name,
        email: user.email,
        url,
      });
    },
  },

  plugins: [
    expo(),

    phoneNumber({
      otpLength: 6,
      expiresIn: 5 * 60,
      requireVerification: true,

      sendOTP: ({ phoneNumber, code }) => {
        // Deliver OTP asynchronously through Fast2SMS.
        void sendWhatsAppOtp(phoneNumber, code).catch((error) => {
          console.error(
            'Failed to send WhatsApp OTP:',
            error instanceof Error ? error.message : 'Unknown error'
          );
        });
      },

      signUpOnVerification: {
        getTempEmail: (phoneNumber) => {
          const digits = phoneNumber.replace(/\D/g, '');
          return `phone-${digits}@${TEMP_EMAIL_DOMAIN}`;
        },

        getTempName: (phoneNumber) => phoneNumber,
      },
    }),
  ],

  advanced: {
    database: {
      generateId: 'uuid',
    },
  },
});
