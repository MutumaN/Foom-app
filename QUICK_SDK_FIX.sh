#!/bin/bash

# Quick Android SDK Setup and Build Script

echo "=============================================="
echo "  Android SDK Setup & Build"
echo "=============================================="
echo ""

ANDROID_SDK="$HOME/Library/Android/sdk"

# Check if SDK exists
if [ ! -d "$ANDROID_SDK" ]; then
    echo "⚠️  Android SDK not found at: $ANDROID_SDK"
    echo ""
    echo "Options to fix:"
    echo ""
    echo "Option 1: Install via Android Studio (RECOMMENDED)"
    echo "  1. Open Android Studio"
    echo "  2. Go to Settings → SDK Manager"
    echo "  3. Install Android SDK"
    echo "  4. Then run this script again"
    echo ""
    echo "Option 2: Link to tush's SDK (if available)"
    echo "  Run: sudo ln -s /Users/tush/Library/Android/sdk $ANDROID_SDK"
    echo "  Then run this script again"
    echo ""
    exit 1
fi

echo "✅ Android SDK found at: $ANDROID_SDK"
echo ""

# Set environment variables
export ANDROID_HOME="$ANDROID_SDK"
export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools"

echo "Setting up environment variables..."

# Detect shell and add to profile
if [ -n "$ZSH_VERSION" ]; then
    PROFILE="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    PROFILE="$HOME/.bash_profile"
else
    PROFILE="$HOME/.profile"
fi

# Add to profile if not already there
if ! grep -q "ANDROID_HOME" "$PROFILE" 2>/dev/null; then
    echo "" >> "$PROFILE"
    echo "# Android SDK" >> "$PROFILE"
    echo "export ANDROID_HOME=\$HOME/Library/Android/sdk" >> "$PROFILE"
    echo "export PATH=\$PATH:\$ANDROID_HOME/platform-tools:\$ANDROID_HOME/tools" >> "$PROFILE"
    echo "✅ Added to $PROFILE"
else
    echo "✅ Already in $PROFILE"
fi

echo ""
echo "Checking Flutter doctor..."
flutter doctor -v

echo ""
echo "Accepting Android licenses..."
flutter doctor --android-licenses

echo ""
echo "Building your FOOM app..."
cd /Users/mor/foom_app

echo "Cleaning..."
flutter clean

echo "Getting dependencies..."
flutter pub get

echo "Building APK (5-10 minutes)..."
flutter build apk --release

if [ $? -eq 0 ]; then
    echo ""
    echo "=============================================="
    echo "  ✅ SUCCESS! Your APK is ready!"
    echo "=============================================="
    echo ""
    ls -lh build/app/outputs/flutter-apk/app-release.apk
    echo ""
    echo "To install: flutter install"
else
    echo ""
    echo "❌ Build failed. Check errors above."
fi


