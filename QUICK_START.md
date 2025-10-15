# FOOM App - Quick Start Guide

## 🚀 Build Your APK in 3 Simple Steps

### Step 1: Fix Flutter Permissions (if needed)
```bash
sudo chmod -R 755 /usr/local/share/flutter
```

### Step 2: Navigate to Project
```bash
cd /Users/mor/foom_app
```

### Step 3: Run Build Script
```bash
./build_apk.sh
```

**That's it!** Your APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

---

## Alternative: Manual Build

If the script doesn't work, run these commands manually:

```bash
cd /Users/mor/foom_app

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build release APK
flutter build apk --release
```

---

## Install on Your Phone

### Option 1: Direct Install (via USB)
```bash
flutter install
```

### Option 2: ADB Install
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Option 3: Transfer APK
1. Copy `build/app/outputs/flutter-apk/app-release.apk` to your phone
2. Open the APK file on your phone
3. Allow installation from unknown sources if prompted
4. Install and enjoy!

---

## ⚙️ Initial Setup After Install

### 1. Grant Permissions
- **Usage Access**: Settings → Apps → Special Access → Usage Access → FOOM → Enable
- **Accessibility** (optional): For app blocking feature

### 2. Create Account
- Sign up with email or Google
- Complete profile setup

### 3. Start Tracking
- The app will start tracking your screen time automatically
- Check back tomorrow to see your first token rewards!

---

## 📱 Device Requirements

- **Android Version**: 5.0 (Lollipop) or higher
- **RAM**: 2GB+ recommended
- **Storage**: 100MB free space
- **Internet**: Required for authentication and sync

---

## 🔧 Troubleshooting

### "Build failed" error
```bash
flutter doctor -v
# Fix any issues shown, then rebuild
```

### "Permission denied" error
```bash
sudo chmod -R 755 /usr/local/share/flutter
```

### "Firebase error" after install
- Make sure `google-services.json` is in `android/app/`
- Check Firebase console for project configuration

### Usage stats not showing
- Grant Usage Access permission
- Wait 24 hours for data to accumulate
- Restart the app

---

## 📚 Need More Help?

See detailed documentation:
- **README_BUILD.md** - Complete build instructions
- **PROJECT_OVERVIEW.md** - Full project documentation

---

**Happy building! 🎉**


