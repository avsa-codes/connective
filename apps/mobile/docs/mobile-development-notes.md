# Connective Mobile Development Notes

## Lesson 1 — Mobile Development Foundations

### Technology Stack
- React Native: Mobile UI framework.
- Expo: React Native development platform and tooling.
- Expo Router: File-based navigation.
- TypeScript: Static typing.

### Important Concepts
- React Native does not use HTML elements.
- View is commonly used as a layout container.
- Text displays text content.
- TextInput accepts user input.
- Pressable handles touch interactions.
- Expo Router maps files to application routes.

### Project Location
`apps/mobile`

### Current Goal
Build Connective's signup, email verification, login and placeholder home screens.

### Navigation Requirements
- Signup → Email Verification → Placeholder Home.
- Login → Placeholder Home.
- Login must NOT redirect to onboarding.
- Onboarding will be implemented later and will follow signup only.


## Lesson 2 — Running the Mobile App

- Expo development server: Runs the app during development.
- Expo Go: Android application used to preview the project.
- QR code: Connects the physical phone to the development server.
- Command: npx expo start

## Lesson 3 — Understanding Expo Router

- src/app contains application routes.
- _layout.tsx defines navigation layouts.
- index.tsx represents the root route (/).
- Components are reusable UI building blocks.
- app.json contains Expo application configuration.
- Pressable handles touch interactions.
- View and Text are native UI components.

## Application Navigation Requirements

- Signup → Email Verification → Placeholder Home.
- Login → Placeholder Home.
- Onboarding will be implemented later.
- Onboarding follows signup only, never login.


Design tokens are reusable design values.

Colour palettes are centrally defined.

as const preserves literal types.

TypeScript union types restrict allowed values.

Notes for Lesson 6:
- React Context shares application-wide information.
- Hooks let React components access state and reusable logic.
- useColorScheme() detects device appearance.
- A design system centralizes colours, fonts and spacing.
- We are retaining existing starter utilities where they are useful.




Add that typography tokens standardize font size, line height and weight across screens.

Design tokens should cover spacing, component dimensions and border radii, not just colours and typography.


Created reusable AppButton.



Variants: primary, secondary, outline, ghost and danger.



Sizes: small, medium and large.



Supports disabled and loading states.



Uses Pressable, ActivityIndicator and AppText.



Includes accessibility role and state.

Update mobile-development-notes.md with:
- Created reusable AppLogo.
- Supports three sizes and optional tagline.
- Currently uses temporary text branding.
- Actual branded image will replace the internal implementation later.


Update apps/mobile/docs/mobile-development-notes.md:
- Created reusable AppFormField.
- Combines label and AppInput.
- Supports required indicator, helper text and validation errors.
- Inherits AppInput props through TypeScript's ComponentProps.