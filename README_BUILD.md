# FOOM App - Build Instructions

## Overview
FOOM (Focus On One Mission) is a screen time tracking app with token rewards and investment features.

## Prerequisites
- Flutter SDK (3.0.0 or higher)
- Android Studio with Android SDK
- Java JDK 11 or higher

## Features Implemented
✅ Authentication (Email/Password & Google Sign-In)
✅ Onboarding screens
✅ Dashboard with screen time tracking
✅ Usage insights with charts
✅ App blocking management
✅ Wallet & token system
✅ Profile management
✅ Firebase integration
✅ M-Pesa payment integration (backend required)

## Quick Start

### 1. Install Dependencies
```bash
cd /Users/mor/foom_app
flutter pub get
```

### 2. Configure Firebase
You already have `google-services.json` in place. Make sure Firebase is configured in the Firebase Console.

### 3. Build APK
```bash
# Build release APK
flutter build apk --release

# Or build debug APK for testing
flutter build apk --debug

# Build app bundle for Play Store
flutter build appbundle --release
```

The APK will be generated at:
- Release: `build/app/outputs/flutter-apk/app-release.apk`
- Debug: `build/app/outputs/flutter-apk/app-debug.apk`

### 4. Install on Device
```bash
# Via USB
flutter install

# Or manually install the APK
adb install build/app/outputs/flutter-apk/app-release.apk
```

## App Structure

```
lib/
├── main.dart                   # App entry point
├── app_router.dart            # Navigation & routing
├── providers.dart             # Global Riverpod providers
├── core/
│   ├── theme/                 # App theming
│   ├── widgets/               # Reusable UI components
│   └── constants.dart         # App constants
├── features/
│   ├── auth/                  # Authentication screens
│   ├── dashboard/             # Home dashboard
│   ├── time_tracking/         # Usage insights
│   ├── apps/                  # App blocking
│   ├── wallet/                # Wallet & investments
│   └── profile/               # User profile
└── services/
    ├── firebase_service.dart  # Firebase operations
    ├── usage_service.dart     # Usage tracking (native)
    ├── blocking_service.dart  # App blocking (native)
    └── payment_service.dart   # M-Pesa payments
```

## Required Permissions

The app requests:
- **Usage Access** - To track screen time
- **Accessibility Service** - To block apps (optional)
- **Internet** - For Firebase and payments

## Configuration

### Update API URLs (Optional)
Edit `lib/core/constants.dart`:
```dart
static const String baseUrl = 'https://your-api.com';
static const String mpesaCallbackUrl = 'https://your-api.com/mpesa/callback';
```

### Update M-Pesa Credentials
Edit `lib/core/constants.dart` with your actual M-Pesa credentials:
```dart
static const String mpesaConsumerKey = 'YOUR_KEY';
static const String mpesaConsumerSecret = 'YOUR_SECRET';
static const String mpesaShortcode = 'YOUR_SHORTCODE';
static const String mpesaPasskey = 'YOUR_PASSKEY';
```

## Testing

### Run on Emulator
```bash
flutter run
```

### Run on Physical Device
```bash
flutter run -d <device-id>
```

### Check for Issues
```bash
flutter doctor -v
flutter analyze
```

## Troubleshooting

### Permission Issues
If you encounter permission errors with Flutter cache:
```bash
sudo chmod -R 777 /usr/local/share/flutter/bin/cache
```

### Build Errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build apk --release
```

### Firebase Issues
- Ensure `google-services.json` is in `android/app/`
- Verify Firebase project is properly configured
- Check that SHA-1 fingerprint is added for Google Sign-In

### Usage Stats Not Working
- Grant Usage Access permission in Settings
- On Android 10+, you may need to grant permission twice

## Key Features

### 1. Screen Time Tracking
- Real-time tracking using Android UsageStatsManager
- Daily, weekly, and per-app breakdowns
- Historical data with charts

### 2. Token System
- Earn 1 token for every 10 minutes reduced screen time
- Tokens can be used for investments
- Convert tokens to KES (1 token = 1 KES)

### 3. Investments
- Integration with Money Market Funds:
  - CIC Money Market Fund (10-12% p.a.)
  - Sanlam Money Market Fund (9-11% p.a.)
  - Britam Money Market Fund (9-10% p.a.)

### 4. M-Pesa Integration
- Deposit via STK Push
- Withdraw to M-Pesa (B2C)
- Transaction history

### 5. App Blocking (Requires Accessibility Service)
- Block distracting apps
- Set daily time limits
- Custom blocked screen overlay

## Backend Requirements

For full functionality, you need a backend API for:
1. M-Pesa Daraja API integration
2. Investment management
3. Transaction processing

See the payment service at `lib/services/payment_service.dart` for required endpoints.

## Firebase Setup

Required Firebase services:
- **Authentication** - Email/Password & Google
- **Firestore** - User data, transactions, investments
- **Storage** - User profile images (optional)

Firestore collections:
```
users/
  - uid, name, email, tokens, savingsBalance, etc.

transactions/
  - userId, type, amount, description, timestamp

investments/
  - userId, mmf, amount, type, status, createdAt
```

## App Signing (For Release)

Create a keystore:
```bash
keytool -genkey -v -keystore ~/foom-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias foom
```

Create `android/key.properties`:
```
storePassword=<password>
keyPassword=<password>
keyAlias=foom
storeFile=/Users/mor/foom-key.jks
```

## Support

For issues or questions, check:
- Flutter documentation: https://flutter.dev
- Firebase documentation: https://firebase.google.com
- Android UsageStatsManager: https://developer.android.com/reference/android/app/usage/UsageStatsManager

## License
© 2025 FOOM. All rights reserved.


