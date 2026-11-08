import type { ComponentProps } from 'react';

import { View, StyleSheet } from 'react-native';

import { AppInput } from '@/components/ui/app-input';
import { AppText } from '@/components/ui/app-text';
import { spacing } from '@/constants/theme';

type AppFormFieldProps = ComponentProps<typeof AppInput> & {
  label: string;
  required?: boolean;
};

export function AppFormField({
  label,
  required = false,
  error,
  helperText,
  ...inputProps
}: AppFormFieldProps) {
  return (
    <View style={styles.container}>
      <View style={styles.labelContainer}>
        <AppText variant="label">{label}</AppText>

        {required ? (
          <AppText variant="label" color="danger">
            *
          </AppText>
        ) : null}
      </View>

      <AppInput {...inputProps} error={error} helperText={helperText} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    width: '100%',
    gap: spacing.xs,
  },
  labelContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.xxs,
  },
});
