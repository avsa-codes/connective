import { createAuthClient } from 'better-auth/react';
import { phoneNumberClient } from 'better-auth/client/plugins';
import { expoClient } from '@better-auth/expo/client';
import * as SecureStore from 'expo-secure-store';

export const authClient = createAuthClient({
  baseURL: process.env.EXPO_PUBLIC_API_URL!,

  plugins: [
    phoneNumberClient(),

    expoClient({
      scheme: 'connective',
      storagePrefix: 'connective',
      storage: SecureStore,
    }),
  ],
});
