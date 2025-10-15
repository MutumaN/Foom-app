# 📦 Building FOOM App APK

## Current Status
- ✅ Flutter project created
- ✅ All Dart code written (23 files)
- ✅ Android configuration added
- ✅ MainActivity.kt created with native code
- ✅ Mock Firebase config added
- ⚠️ Flutter Git permissions issue detected

---

## 🔧 Fix Flutter Permissions (One-time setup)

Run this command to fix Flutter:

```bash
git config --global --add safe.directory /usr/local/share/flutter
```

---

## 📱 Build APK - Method 1: Command Line

### Step 1: Navigate to project
```bash
cd /Users/mor/foom_app
```

### Step 2: Get dependencies
```bash
flutter pub get
```

### Step 3: Build APK (Debug)
```bash
flutter build apk --debug
```

### Step 4: Build APK (Release)
```bash
flutter build apk --release
```

### Output Location:
```
/Users/mor/foom_app/build/app/outputs/flutter-apk/app-release.apk
```

---

## 📱 Build APK - Method 2: Split APKs (Smaller size)

```bash
flutter build apk --split-per-abi --release
```

This creates 3 APKs (one per architecture):
- `app-armeabi-v7a-release.apk` - 32-bit ARM
- `app-arm64-v8a-release.apk` - 64-bit ARM (most common)
- `app-x86_64-release.apk` - Intel 64-bit

---

## 📱 Build App Bundle (For Play Store)

```bash
flutter build appbundle --release
```

Output: `/Users/mor/foom_app/build/app/outputs/bundle/release/app-release.aab`

---

## 🔥 Replace Firebase Config (Important!)

The current `google-services.json` is a MOCK file. Replace it with your real Firebase config:

### Steps:
1. Go to https://console.firebase.google.com
2. Create a project (or use existing)
3. Add Android app with package name: `com.foom.app`
4. Download `google-services.json`
5. Replace the file at: `/Users/mor/foom_app/android/app/google-services.json`

---

## 🚀 Quick Build Script

Create this script to build quickly:

```bash
#!/bin/bash
# build.sh

echo "🔧 Getting dependencies..."
flutter pub get

echo "🏗️ Building APK..."
flutter build apk --release --split-per-abi

echo "✅ Build complete!"
echo "📦 APKs located at:"
echo "   build/app/outputs/flutter-apk/"

ls -lh build/app/outputs/flutter-apk/*.apk
```

Make it executable:
```bash
chmod +x build.sh
./build.sh
```

---

## 🐛 Common Build Issues & Fixes

### Issue 1: Flutter Git Permissions
```bash
# Solution:
git config --global --add safe.directory /usr/local/share/flutter
```

### Issue 2: Gradle Errors
```bash
# Clean and rebuild:
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

### Issue 3: Firebase Errors
```
# Make sure google-services.json is valid
# Download from Firebase Console
```

### Issue 4: Kotlin Version Issues
```
# Update android/build.gradle:
ext.kotlin_version = '1.8.0'
```

---

## 📊 Build Output

After successful build, you'll see:

```
✓ Built build/app/outputs/flutter-apk/app-arm64-v8a-release.apk (25.5MB).
```

---

## 🎯 Install on Device

### Via USB:
```bash
flutter install
```

### Via ADB:
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔍 APK Analysis

Check APK size and contents:

```bash
# Analyze APK
flutter build apk --analyze-size

# Check APK info
aapt dump badging build/app/outputs/flutter-apk/app-release.apk
```

---

## 📦 APK Signing (For Production)

### Generate keystore:
```bash
keytool -genkey -v -keystore ~/foom-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias foom
```

### Create key.properties:
```properties
# android/key.properties
storePassword=<password>
keyPassword=<password>
keyAlias=foom
storeFile=/Users/mor/foom-release-key.jks
```

### Update android/app/build.gradle:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

---

## ✅ Pre-Build Checklist

- [ ] Flutter SDK installed
- [ ] Android SDK installed
- [ ] Java JDK installed
- [ ] Firebase project created
- [ ] google-services.json replaced with real config
- [ ] Package name matches Firebase config
- [ ] All dependencies in pubspec.yaml
- [ ] Android permissions in AndroidManifest.xml

---

## 🚀 One-Command Build

```bash
cd /Users/mor/foom_app && git config --global --add safe.directory /usr/local/share/flutter && flutter pub get && flutter build apk --release --split-per-abi
```

---

## 📱 Expected APK Sizes

- **Debug APK:** ~40-50 MB
- **Release APK (all architectures):** ~25-30 MB
- **Release APK (single architecture):** ~15-20 MB
- **App Bundle:** ~20-25 MB

---

## 🎉 Success Indicators

You'll know it worked when you see:

```
Running Gradle task 'assembleRelease'...
✓ Built build/app/outputs/flutter-apk/app-release.apk (25.5MB).
```

---

## 📞 Need Help?

If build fails:
1. Run `flutter doctor` to check setup
2. Check error messages carefully
3. Verify Firebase configuration
4. Ensure all permissions are set

---

**Your app is ready to build!** 🚀

Just fix the Flutter permissions and run the build command!

