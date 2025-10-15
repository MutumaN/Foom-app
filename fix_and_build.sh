#!/bin/bash

echo "🔧 FOOM App - Fix Permissions & Build APK"
echo "=========================================="
echo ""
echo "This script will:"
echo "  1. Fix Flutter permissions (requires password)"
echo "  2. Get Flutter dependencies"
echo "  3. Build the APK"
echo ""
echo "You'll be asked for your password to fix Flutter permissions."
echo ""
read -p "Press Enter to continue..."

# Fix Flutter permissions
echo ""
echo "🔐 Fixing Flutter permissions..."
sudo chown -R $(whoami) /usr/local/share/flutter

if [ $? -eq 0 ]; then
    echo "✅ Permissions fixed!"
else
    echo "❌ Failed to fix permissions. Please run manually:"
    echo "   sudo chown -R \$(whoami) /usr/local/share/flutter"
    exit 1
fi

# Navigate to project
cd /Users/mor/foom_app

# Get dependencies
echo ""
echo "📦 Getting Flutter dependencies..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "❌ Failed to get dependencies"
    exit 1
fi

# Clean previous builds
echo ""
echo "🧹 Cleaning previous builds..."
flutter clean

# Build APK
echo ""
echo "🏗️  Building APK (this will take a few minutes)..."
echo ""
flutter build apk --release --split-per-abi

# Check if build was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ ✅ ✅ BUILD SUCCESSFUL! ✅ ✅ ✅"
    echo "=========================================="
    echo ""
    echo "📦 Your APKs are ready:"
    echo ""
    ls -lh build/app/outputs/flutter-apk/*.apk 2>/dev/null
    echo ""
    echo "📍 Location: /Users/mor/foom_app/build/app/outputs/flutter-apk/"
    echo ""
    echo "🎉 You can now install the APK on your Android device!"
    echo ""
    echo "To install via USB:"
    echo "  flutter install"
    echo ""
    echo "To install via ADB:"
    echo "  adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk"
    echo ""
else
    echo ""
    echo "❌ BUILD FAILED!"
    echo "=========================================="
    echo ""
    echo "Please check the error messages above."
    echo ""
    echo "Common fixes:"
    echo "  1. Make sure Android SDK is installed"
    echo "  2. Run: flutter doctor"
    echo "  3. Check Firebase configuration"
fi

