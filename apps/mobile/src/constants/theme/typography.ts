export const fontFamilies = {
  regular: 'PlusJakartaSans-Regular',
  medium: 'PlusJakartaSans-Medium',
  semibold: 'PlusJakartaSans-SemiBold',
  bold: 'PlusJakartaSans-Bold',
} as const;

export const fontSizes = {
  xs: 12,
  sm: 14,
  md: 16,
  lg: 18,
  xl: 20,
  '2xl': 24,
  '3xl': 30,
  '4xl': 36,
} as const;

export const lineHeights = {
  xs: 16,
  sm: 20,
  md: 24,
  lg: 28,
  xl: 28,
  '2xl': 32,
  '3xl': 38,
  '4xl': 44,
} as const;

export const typography = {
  display: {
    fontFamily: fontFamilies.bold,
    fontSize: fontSizes['4xl'],
    lineHeight: lineHeights['4xl'],
  },
  heading1: {
    fontFamily: fontFamilies.semibold,
    fontSize: fontSizes['3xl'],
    lineHeight: lineHeights['3xl'],
  },
  heading2: {
    fontFamily: fontFamilies.semibold,
    fontSize: fontSizes['2xl'],
    lineHeight: lineHeights['2xl'],
  },
  heading3: {
    fontFamily: fontFamilies.semibold,
    fontSize: fontSizes.xl,
    lineHeight: lineHeights.xl,
  },
  body: {
    fontFamily: fontFamilies.regular,
    fontSize: fontSizes.md,
    lineHeight: lineHeights.md,
  },
  bodyMedium: {
    fontFamily: fontFamilies.medium,
    fontSize: fontSizes.md,
    lineHeight: lineHeights.md,
  },
  caption: {
    fontFamily: fontFamilies.regular,
    fontSize: fontSizes.sm,
    lineHeight: lineHeights.sm,
  },
  label: {
    fontFamily: fontFamilies.medium,
    fontSize: fontSizes.sm,
    lineHeight: lineHeights.sm,
  },
  small: {
    fontFamily: fontFamilies.regular,
    fontSize: fontSizes.xs,
    lineHeight: lineHeights.xs,
  },
} as const;
