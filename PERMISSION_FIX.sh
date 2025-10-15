#!/bin/bash

# FOOM App - Fix Flutter Permissions
# The Flutter installation is owned by user 'tush' but you're user 'mor'
# This script fixes the ownership so you can build

echo "=============================================="
echo "  Flutter Permission Fix"
echo "=============================================="
echo ""
echo "Issue: Flutter is owned by 'tush', you are 'mor'"
echo "Solution: Change ownership to your user"
echo ""
echo "This will ask for your password..."
echo ""

# Change ownership of Flutter to current user
sudo chown -R "$USER:admin" /usr/local/share/flutter

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Permissions fixed!"
    echo ""
    echo "Now running build..."
    echo ""
    
    cd /Users/mor/foom_app
    
    echo "Cleaning..."
    flutter clean
    
    echo "Getting dependencies..."
    flutter pub get
    
    echo "Building APK (this will take 5-10 minutes)..."
    flutter build apk --release
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "=============================================="
        echo "  ✅ SUCCESS! APK Built!"
        echo "=============================================="
        echo ""
        echo "Your APK is at:"
        ls -lh build/app/outputs/flutter-apk/app-release.apk
        echo ""
        echo "To install: flutter install"
    else
        echo ""
        echo "❌ Build failed. Check errors above."
    fi
else
    echo ""
    echo "❌ Permission fix failed. You may need admin access."
fi


