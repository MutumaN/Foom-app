# FOOM App - Complete Project Overview

## 🎯 Project Summary

**FOOM (Focus On One Mission)** is a comprehensive Android app built with Flutter that helps users track and reduce their screen time while earning rewards and building savings.

## 🌟 Core Features

### 1. Authentication System
- **Email/Password Authentication** - Secure signup and login
- **Google Sign-In** - Quick authentication via Google account
- **Onboarding Flow** - 4-screen tutorial for new users
- **Profile Setup** - Customizable user profiles
- **Password Reset** - Email-based password recovery

### 2. Screen Time Tracking
- **Real-time Tracking** - Uses Android UsageStatsManager API
- **Daily Statistics** - Current day usage in minutes/hours
- **Weekly Overview** - 7-day usage history with bar charts
- **Per-App Breakdown** - Detailed usage for each installed app
- **Historical Data** - Track progress over time
- **Yesterday Comparison** - See improvement from previous day

### 3. Token Reward System
- **Automatic Rewards** - Earn 1 token per 10 minutes of reduced screen time
- **Token Balance** - View available tokens in real-time
- **Token to Cash** - Convert tokens to KES (1 token = 1 KES)
- **Token History** - Track all token earnings
- **Investment Options** - Use tokens for MMF investments

### 4. Investment Platform
- **Money Market Funds** - Access to top Kenyan MMFs:
  - CIC Money Market Fund (10-12% p.a., min 1000 KES)
  - Sanlam Money Market Fund (9-11% p.a., min 500 KES)
  - Britam Money Market Fund (9-10% p.a., min 1000 KES)
- **Token Investments** - Invest tokens directly
- **M-Pesa Investments** - Deposit cash via M-Pesa
- **Portfolio Tracking** - Monitor all investments
- **Transaction History** - Complete audit trail

### 5. Digital Wallet
- **Balance Display** - Current savings balance
- **M-Pesa Integration**:
  - STK Push for deposits
  - B2C for withdrawals
  - Phone number verification
  - Transaction callbacks
- **Multiple Payment Methods** - Tokens or M-Pesa
- **Transaction History** - All deposits, withdrawals, investments
- **Real-time Updates** - Live balance updates

### 6. App Management & Blocking
- **App Inventory** - List all installed apps
- **Usage Monitoring** - Per-app daily usage
- **App Blocking** - Block distracting apps
- **Time Limits** - Set daily limits per app
- **Accessibility Service** - System-level app blocking
- **Blocked Screen Overlay** - Custom block message

### 7. Analytics & Insights
- **Usage Charts** - Beautiful fl_chart visualizations
- **Daily Trends** - Pattern analysis
- **Weekly Comparison** - Week-over-week changes
- **App Rankings** - Most used apps
- **Goal Tracking** - Set and monitor usage goals
- **Progress Reports** - Regular summaries

### 8. User Profile & Settings
- **Profile Management** - Name, email, photo
- **Notification Settings** - Push notification controls
- **Privacy Settings** - Data control options
- **Permission Management** - Usage Access, Accessibility
- **Account Settings** - Password change, delete account
- **App Info** - Version, about, support

## 🏗️ Technical Architecture

### Frontend (Flutter)
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **UI Framework**: Material Design 3
- **Charts**: fl_chart
- **HTTP Client**: Dio & HTTP packages

### Backend Services
- **Authentication**: Firebase Auth
- **Database**: Cloud Firestore
- **Storage**: Firebase Storage (optional)
- **Analytics**: Firebase Analytics (optional)

### Native Android
- **Language**: Kotlin
- **APIs**:
  - UsageStatsManager (screen time)
  - AccessibilityService (app blocking)
  - Method Channels (Flutter ↔ Native)

### Third-Party Integrations
- **M-Pesa Daraja API** - Payment processing
- **Google Sign-In** - OAuth authentication
- **MMF APIs** - Investment management (requires backend)

## 📁 Project Structure

```
foom_app/
├── lib/
│   ├── main.dart                          # App entry point with Firebase init
│   ├── app_router.dart                    # GoRouter navigation setup
│   ├── providers.dart                     # Global Riverpod providers
│   │
│   ├── core/                              # Core utilities
│   │   ├── theme/
│   │   │   └── app_theme.dart             # Material 3 theme (light/dark)
│   │   ├── widgets/
│   │   │   ├── app_button.dart            # Reusable button widget
│   │   │   ├── app_card.dart              # Reusable card widget
│   │   │   ├── app_textfield.dart         # Reusable input field
│   │   │   └── loading_indicator.dart     # Loading spinner
│   │   └── constants.dart                 # App-wide constants
│   │
│   ├── features/                          # Feature modules
│   │   ├── auth/                          # Authentication
│   │   │   └── presentation/
│   │   │       ├── splash_screen.dart     # App launch screen
│   │   │       ├── onboarding_screen.dart # 4-page tutorial
│   │   │       ├── login_screen.dart      # Login with email/Google
│   │   │       ├── signup_screen.dart     # Registration form
│   │   │       └── profile_setup_screen.dart # Initial profile setup
│   │   │
│   │   ├── dashboard/                     # Main dashboard
│   │   │   └── presentation/
│   │   │       ├── dashboard_screen.dart  # Home screen
│   │   │       └── widgets/
│   │   │           ├── summary_card.dart  # Stat display cards
│   │   │           └── quick_action_button.dart # Action buttons
│   │   │
│   │   ├── time_tracking/                 # Usage insights
│   │   │   └── presentation/
│   │   │       ├── insights_screen.dart   # Charts & stats
│   │   │       └── widgets/
│   │   │           ├── usage_chart.dart   # Weekly bar chart
│   │   │           └── usage_list.dart    # Per-app usage list
│   │   │
│   │   ├── apps/                          # App management
│   │   │   └── presentation/
│   │   │       └── apps_screen.dart       # App list with blocking
│   │   │
│   │   ├── wallet/                        # Wallet & investments
│   │   │   └── presentation/
│   │   │       └── wallet_screen.dart     # Balance & transactions
│   │   │
│   │   └── profile/                       # User profile
│   │       └── presentation/
│   │           ├── profile_screen.dart    # Profile & settings
│   │           └── profile_setup_screen.dart # Initial setup
│   │
│   └── services/                          # Business logic
│       ├── firebase_service.dart          # Auth & Firestore ops
│       ├── usage_service.dart             # Native usage tracking
│       ├── blocking_service.dart          # Native app blocking
│       └── payment_service.dart           # M-Pesa integration
│
├── android/                               # Android native code
│   └── app/src/main/
│       ├── kotlin/com/foom/app/
│       │   └── MainActivity.kt            # Method channels implementation
│       └── AndroidManifest.xml            # Permissions & config
│
├── assets/                                # Static assets
│   ├── images/                            # App images
│   ├── icons/                             # Icon files
│   └── fonts/                             # Custom fonts
│
├── pubspec.yaml                           # Dependencies
├── README_BUILD.md                        # Build instructions
├── build_apk.sh                           # Build automation script
└── google-services.json                   # Firebase config

```

## 🔧 Technology Stack

### Core Technologies
- **Flutter** 3.0+ - Cross-platform UI framework
- **Dart** - Programming language
- **Kotlin** - Android native code
- **Firebase** - Backend services

### Flutter Packages
```yaml
dependencies:
  # State Management
  flutter_riverpod: ^2.4.9
  
  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  
  # Authentication
  google_sign_in: ^6.1.6
  
  # Navigation
  go_router: ^12.1.3
  
  # Charts
  fl_chart: ^0.65.0
  
  # HTTP & Payments
  http: ^1.1.2
  dio: ^5.4.0
  
  # Storage
  shared_preferences: ^2.2.2
  flutter_secure_storage: ^9.0.0
  
  # Utilities
  intl: ^0.18.1
  permission_handler: ^11.1.0
```

## 🔐 Security Features

1. **Firebase Authentication** - Industry-standard auth
2. **Secure Storage** - Encrypted local storage for sensitive data
3. **HTTPS Only** - All API calls use SSL/TLS
4. **Token Validation** - Server-side validation for all transactions
5. **Permission Checks** - Runtime permission verification
6. **Input Validation** - Client and server-side validation

## 📱 App Permissions

Required:
- **INTERNET** - Network access for Firebase and APIs
- **PACKAGE_USAGE_STATS** - Screen time tracking

Optional:
- **BIND_ACCESSIBILITY_SERVICE** - App blocking feature

## 🚀 Getting Started

### Prerequisites
1. Flutter SDK 3.0+
2. Android Studio with Android SDK
3. Java JDK 11+
4. Firebase project with google-services.json

### Build Commands
```bash
# Install dependencies
flutter pub get

# Run in development
flutter run

# Build release APK
flutter build apk --release

# Build app bundle for Play Store
flutter build appbundle --release
```

### Quick Build
```bash
./build_apk.sh
```

## 📊 Database Schema (Firestore)

### users Collection
```javascript
{
  uid: string,
  name: string,
  email: string,
  photoUrl: string?,
  tokens: number,
  savingsBalance: number,
  dailyUsageMinutes: number,
  selectedMMF: string?,
  linkedAccounts: {},
  createdAt: timestamp
}
```

### transactions Collection
```javascript
{
  userId: string,
  type: string, // 'deposit', 'withdrawal', 'investment', 'reward'
  amount: number,
  description: string,
  timestamp: timestamp
}
```

### investments Collection
```javascript
{
  userId: string,
  mmf: string,
  amount: number,
  type: string, // 'tokens' or 'mpesa'
  status: string, // 'pending', 'active', 'completed'
  createdAt: timestamp
}
```

## 🔄 App Flow

1. **Launch** → Splash Screen (2s)
2. **First Time** → Onboarding (4 screens) → Auth (Login/Signup)
3. **Authenticated** → Dashboard
4. **Dashboard** → Shows stats, quick actions, recent activity
5. **Grant Permissions** → Usage Access (required for tracking)
6. **Track Usage** → Background tracking begins
7. **Earn Tokens** → Automatic based on reduced usage
8. **Invest** → Choose MMF and invest tokens/cash
9. **Monitor** → View insights, track progress

## 🎨 Design System

- **Theme**: Material Design 3
- **Colors**: Indigo primary, Green secondary
- **Typography**: Roboto (default Flutter font)
- **Custom Fonts**: Poppins (configured, add TTF files)
- **Icons**: Material Icons + custom
- **Layout**: Responsive, mobile-first

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run with coverage
flutter test --coverage

# Analyze code
flutter analyze

# Check for issues
flutter doctor -v
```

## 📦 APK Output

After successful build:
- **Location**: `build/app/outputs/flutter-apk/app-release.apk`
- **Size**: ~40-60 MB (typical)
- **Min Android Version**: 5.0 (API 21)
- **Target Android Version**: 13 (API 33)

## 🔮 Future Enhancements

- [ ] iOS version
- [ ] Advanced analytics dashboard
- [ ] Social features (friends, leaderboards)
- [ ] Premium MMF options
- [ ] Cryptocurrency investments
- [ ] Parental controls
- [ ] Family sharing
- [ ] Widget support
- [ ] Watch app integration
- [ ] AI-powered insights

## 👥 Target Audience

- Young adults (18-35)
- Students
- Professionals seeking work-life balance
- Parents monitoring children's usage
- Anyone interested in digital wellness

## 💰 Monetization Potential

1. **Commission** - Small fee on investments
2. **Premium Tier** - Advanced features
3. **Partnerships** - MMF referral fees
4. **Ads** - Optional rewarded ads for bonus tokens
5. **Corporate** - B2B wellness programs

## 📝 License

© 2025 FOOM. All rights reserved.

## 🤝 Support

For technical support or questions:
- Check README_BUILD.md for build issues
- Review Firebase console for backend issues
- Check Android Studio logcat for runtime errors
- Verify permissions are granted in device settings

---

**Built with ❤️ using Flutter**


