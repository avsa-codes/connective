import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useRef,
  useState,
  type ReactNode,
} from 'react';

import { AppToast } from '@/components/ui/app-toast';

import { StyleSheet, View } from 'react-native';

import { spacing } from '@/constants/theme';

export type ToastType = 'success' | 'error' | 'info';

type ToastData = {
  id: number;
  message: string;
  type: ToastType;
};

type ToastContextValue = {
  showToast: (message: string, type?: ToastType) => void;
  hideToast: () => void;
};

const ToastContext = createContext<ToastContextValue | undefined>(undefined);

type ToastProviderProps = {
  children: ReactNode;
};

export function ToastProvider({ children }: ToastProviderProps) {
  const [toast, setToast] = useState<ToastData | null>(null);
  const timerRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const nextIdRef = useRef(0);

  const hideToast = useCallback(() => {
    if (timerRef.current) {
      clearTimeout(timerRef.current);
      timerRef.current = null;
    }

    setToast(null);
  }, []);

  const showToast = useCallback((message: string, type: ToastType = 'info') => {
    if (timerRef.current) {
      clearTimeout(timerRef.current);
    }

    const id = ++nextIdRef.current;

    setToast({ id, message, type });

    timerRef.current = setTimeout(() => {
      setToast((current) => (current?.id === id ? null : current));
      timerRef.current = null;
    }, 3000);
  }, []);

  useEffect(() => {
    return () => {
      if (timerRef.current) {
        clearTimeout(timerRef.current);
      }
    };
  }, []);

  return (
    <ToastContext.Provider value={{ showToast, hideToast }}>
      {children}

      {toast ? (
        <View pointerEvents="box-none" style={styles.overlay}>
          <AppToast
            key={toast.id}
            message={toast.message}
            type={toast.type}
            onDismiss={hideToast}
          />
        </View>
      ) : null}
    </ToastContext.Provider>
  );
}

export function useToastContext() {
  const context = useContext(ToastContext);

  if (!context) {
    throw new Error('useToastContext must be used within ToastProvider');
  }

  return context;
}

const styles = StyleSheet.create({
  overlay: {
    position: 'absolute',
    top: 56,
    left: spacing.lg,
    right: spacing.lg,
    zIndex: 999,
  },
});