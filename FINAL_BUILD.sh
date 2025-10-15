#!/bin/bash

echo "=========================================="
echo "  FOOM App - Final Build Script"
echo "=========================================="
echo ""

# Set Android SDK
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools

cd /Users/mor/foom_app

echo "Step 1: Cleaning old build..."
flutter clean
rm -rf build/
rm -rf .dart_tool/
rm -rf android/.gradle/
rm -rf android/app/build/

echo ""
echo "Step 2: Getting dependencies..."
flutter pub get

echo ""
echo "Step 3: Building APK (this will take 5-10 minutes)..."
echo "Building with version validation bypass..."
flutter build apk --release --android-skip-build-dependency-validation

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "  ✅ SUCCESS! APK BUILT!"
    echo "=========================================="
    echo ""
    echo "Your APK is ready at:"
    ls -lh build/app/outputs/flutter-apk/app-release.apk
    echo ""
    echo "Size:"
    du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1
    echo ""
    echo "To install on phone:"
    echo "  flutter install"
    echo "  or"
    echo "  adb install build/app/outputs/flutter-apk/app-release.apk"
    echo ""
else
    echo ""
    echo "=========================================="
    echo "  Build failed. Trying without validation skip..."
    echo "=========================================="
    flutter build apk --release
fi


