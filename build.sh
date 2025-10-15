#!/bin/bash

echo "🔧 FOOM App - APK Build Script"
echo "================================"
echo ""

# Fix Flutter permissions
echo "1️⃣ Fixing Flutter Git permissions..."
git config --global --add safe.directory /usr/local/share/flutter 2>/dev/null

# Navigate to project
cd /Users/mor/foom_app

# Get dependencies
echo ""
echo "2️⃣ Getting Flutter dependencies..."
/usr/local/bin/flutter pub get

# Clean previous builds
echo ""
echo "3️⃣ Cleaning previous builds..."
/usr/local/bin/flutter clean

# Build APK
echo ""
echo "4️⃣ Building APK (this may take a few minutes)..."
/usr/local/bin/flutter build apk --release --split-per-abi

# Check if build was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ BUILD SUCCESSFUL!"
    echo "================================"
    echo ""
    echo "📦 Your APKs are ready:"
    echo ""
    ls -lh build/app/outputs/flutter-apk/*.apk 2>/dev/null
    echo ""
    echo "📍 Location: build/app/outputs/flutter-apk/"
    echo ""
    echo "🎉 You can now install the APK on your Android device!"
else
    echo ""
    echo "❌ BUILD FAILED!"
    echo "================================"
    echo ""
    echo "Please check the error messages above."
    echo "Common fixes:"
    echo "  1. Make sure Flutter is properly installed"
    echo "  2. Replace google-services.json with real Firebase config"
    echo "  3. Run: flutter doctor"
fi

