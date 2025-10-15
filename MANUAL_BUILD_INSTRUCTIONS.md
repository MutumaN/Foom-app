# 🛠️ Manual Build Instructions

Since automated building requires admin password, here's how to build your APK manually:

---

## ✅ Option 1: Use the Fix & Build Script (RECOMMENDED)

### Run this in your terminal:

```bash
cd /Users/mor/foom_app
./fix_and_build.sh
```

**You'll be asked for your password once to fix Flutter permissions.**

---

## ✅ Option 2: Manual Commands

### Step 1: Fix Flutter Permissions (one-time)

Open Terminal and run:

```bash
sudo chown -R $(whoami) /usr/local/share/flutter
```

Enter your password when prompted.

### Step 2: Build the APK

```bash
cd /Users/mor/foom_app
flutter pub get
flutter clean
flutter build apk --release --split-per-abi
```

---

## 📦 Where to Find Your APK

After successful build:

```
/Users/mor/foom_app/build/app/outputs/flutter-apk/

Files created:
✅ app-arm64-v8a-release.apk      (~20 MB) - For most phones
✅ app-armeabi-v7a-release.apk    (~18 MB) - For older phones
✅ app-x86_64-release.apk         (~22 MB) - For Intel phones
```

---

## 📱 Install on Your Android Device

### Method 1: USB Connection

1. Connect your Android device via USB
2. Enable Developer Options & USB Debugging
3. Run:
```bash
cd /Users/mor/foom_app
flutter install
```

### Method 2: ADB Install

```bash
adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

### Method 3: Manual Transfer

1. Copy the APK file to your phone
2. Open it on your phone
3. Allow installation from unknown sources
4. Install!

---

## 🔍 Verify Build Success

You'll know it worked when you see:

```
✓ Built build/app/outputs/flutter-apk/app-arm64-v8a-release.apk (20.5MB).
✓ Built build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk (18.2MB).
✓ Built build/app/outputs/flutter-apk/app-x86_64-release.apk (22.1MB).
```

---

## ❓ Troubleshooting

### Problem: "Permission denied"
**Solution:** Run the sudo command from Step 1 again

### Problem: "Flutter not found"
**Solution:** 
```bash
export PATH="$PATH:/usr/local/bin/flutter/bin"
```

### Problem: "Android SDK not found"
**Solution:** 
```bash
flutter doctor
# Follow the instructions to install Android SDK
```

### Problem: "Gradle build failed"
**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk --release
```

---

## 🎯 Quick Reference

**Fix permissions:**
```bash
sudo chown -R $(whoami) /usr/local/share/flutter
```

**Build APK:**
```bash
cd /Users/mor/foom_app && flutter pub get && flutter build apk --release --split-per-abi
```

**Check APK size:**
```bash
ls -lh build/app/outputs/flutter-apk/*.apk
```

---

## ✅ Success Checklist

- [ ] Run fix_and_build.sh OR manual commands
- [ ] See "Build successful" message
- [ ] Find APK files in build/app/outputs/flutter-apk/
- [ ] APK size is around 18-22 MB
- [ ] Install on Android device
- [ ] Open and test the app

---

## 🎉 You're Almost There!

Just run one of these commands and your APK will be ready:

### Easiest Way:
```bash
cd /Users/mor/foom_app && ./fix_and_build.sh
```

### Or One-Line:
```bash
sudo chown -R $(whoami) /usr/local/share/flutter && cd /Users/mor/foom_app && flutter pub get && flutter build apk --release --split-per-abi
```

**Your app is ready to build! Just needs your password to fix Flutter permissions.** 🚀

