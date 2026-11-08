import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import { useFonts } from 'expo-font';
import { ActivityIndicator, View } from 'react-native';
import * as SplashScreen from 'expo-splash-screen';
import { ToastProvider } from '@/context/toast-context';

import { ThemeProvider } from '@/context/theme-context';
import { useTheme } from '@/hooks/use-theme';

void SplashScreen.preventAutoHideAsync();

function RootNavigator() {
  const { colors, resolvedTheme } = useTheme();

  const [fontsLoaded, fontError] = useFonts({
    'PlusJakartaSans-Regular': require('@expo-google-fonts/plus-jakarta-sans/400Regular/PlusJakartaSans_400Regular.ttf'),
    'PlusJakartaSans-Medium': require('@expo-google-fonts/plus-jakarta-sans/500Medium/PlusJakartaSans_500Medium.ttf'),
    'PlusJakartaSans-SemiBold': require('@expo-google-fonts/plus-jakarta-sans/600SemiBold/PlusJakartaSans_600SemiBold.ttf'),
    'PlusJakartaSans-Bold': require('@expo-google-fonts/plus-jakarta-sans/700Bold/PlusJakartaSans_700Bold.ttf'),
  });

  if (!fontsLoaded && !fontError) {
    return null;
  }

  void SplashScreen.hideAsync();

  return (
    <>
      <StatusBar style={resolvedTheme === 'dark' ? 'light' : 'dark'} />

      <Stack
        screenOptions={{
          headerShown: false,
          contentStyle: {
            backgroundColor: colors.background,
          },
        }}
      />
    </>
  );
}

export default function RootLayout() {
  return (
    <ThemeProvider>
      <ToastProvider>
        <RootNavigator />
      </ToastProvider>
    </ThemeProvider>
  );
}
