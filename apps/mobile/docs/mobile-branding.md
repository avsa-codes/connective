
# Brand Identity & Asset Configuration

## 1. Brand Identity

Connective's mobile application uses a minimal, premium and professional visual identity.

The approved logo consists of:
- A geometric interlocking connection symbol.
- A Connective wordmark.
- A standalone symbol for application icons and compact UI placements.

The visual identity communicates connection, integration and professional digital services.

### Brand Colour Palette

| Colour | Hex | Usage |
|---|---|---|
| Deep Green | #005B4B | Primary dark brand colour |
| Emerald | #087E67 | Primary brand colour |
| Mint | #E5F5EF | Light surfaces and icon backgrounds |
| Off-White | #F8FAF9 | Application background |

The application supports both light and dark themes.

## 2. Typography

Primary typeface: Plus Jakarta Sans.

Font weights:
- Regular (400)
- Medium (500)
- SemiBold (600)
- Bold (700)

Font assets are loaded through `@expo-google-fonts/plus-jakarta-sans`.

## 3. Branding Asset Structure

All branding assets are maintained inside `apps/mobile/assets/`.

```text
assets/
├── branding/
│   ├── connective-brand-board.png
│   ├── connective-logo.png
│   ├── connective-symbol.png
│   └── connective-symbol-mono.png
│
├── images/
│   ├── android-icon-background.png
│   ├── android-icon-foreground.png
│   ├── android-icon-monochrome.png
│   ├── favicon.png
│   ├── icon.png
│   ├── splash-background.png
│   └── splash-icon.png
│
└── ios/
    └── connective-ios-icon.png
```

### Asset Responsibilities

| Asset | Responsibility |
|---|---|
| connective-brand-board.png | Approved brand identity reference |
| connective-logo.png | Primary logo with wordmark |
| connective-symbol.png | Standalone brand symbol |
| connective-symbol-mono.png | Monochrome brand symbol |
| icon.png | General application icon |
| connective-ios-icon.png | iOS application icon |
| android-icon-foreground.png | Android adaptive icon foreground |
| android-icon-background.png | Android adaptive icon background |
| android-icon-monochrome.png | Android themed icon |
| favicon.png | Web favicon |
| splash-icon.png | Native splash screen symbol |
| splash-background.png | Reference splash background asset |

## 4. Expo Configuration

The application's Expo configuration is maintained in `app.json`.

### Application Identity
- Name: Connective
- Slug: connective
- Scheme: connective
- Version: 1.0.0
- Orientation: Portrait
- User interface style: Automatic (system theme)

### Platform Configuration

**General application icon**
- `./assets/images/icon.png`

**iOS**
- `./assets/ios/connective-ios-icon.png`

**Android**
- Foreground: `./assets/images/android-icon-foreground.png`
- Background: `./assets/images/android-icon-background.png`
- Monochrome: `./assets/images/android-icon-monochrome.png`
- Background colour: `#E5F5EF`

**Web**
- Favicon: `./assets/images/favicon.png`
- Output: Static

**Splash Screen**
- Image: `./assets/images/splash-icon.png`
- Background colour: `#005B4B`
- Image width: 76

## 5. Asset Validation

The following validations have been completed:

- All configured asset paths exist.
- PNG file formats have been verified.
- Application icon dimensions: 1024 × 1024.
- iOS icon dimensions: 1024 × 1024.
- Android foreground dimensions: 1024 × 1024.
- Android monochrome dimensions: 432 × 432.
- Favicon dimensions: 192 × 192.
- Splash icon dimensions: 512 × 512.
- Transparent backgrounds verified for Android foreground, Android monochrome and splash symbol.
- Expo public configuration successfully resolves.
- Expo dependencies are up to date.

Validation commands:

```bash
npx expo config --type public
npx expo install --check
```

Both commands completed successfully.

## 6. Remaining Branding Improvements

The current branding assets are raster PNG exports derived from the approved generated brand artwork.

Before production release:
- Recreate the approved symbol as clean vector SVG artwork.
- Verify logo sharpness at different display sizes.
- Test application icons on actual Android and iOS devices.
- Verify splash screen appearance in native builds.
- Review platform-specific icon rendering and safe areas.

The approved brand direction and colour palette should remain unchanged unless a deliberate branding revision is approved.
