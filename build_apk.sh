#!/bin/bash

# FOOM App Build Script
# This script builds the release APK for the FOOM app

echo "======================================"
echo "  FOOM App - APK Build Script"
echo "======================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}Error: Flutter is not installed or not in PATH${NC}"
    echo "Please install Flutter from https://flutter.dev"
    exit 1
fi

echo -e "${GREEN}✓ Flutter found${NC}"
echo ""

# Check Flutter version
echo "Flutter version:"
flutter --version
echo ""

# Clean previous builds
echo -e "${YELLOW}Cleaning previous builds...${NC}"
flutter clean

# Get dependencies
echo -e "${YELLOW}Getting dependencies...${NC}"
flutter pub get

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to get dependencies${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Dependencies installed${NC}"
echo ""

# Analyze code
echo -e "${YELLOW}Analyzing code...${NC}"
flutter analyze --no-fatal-infos --no-fatal-warnings

# Build APK
echo -e "${YELLOW}Building release APK...${NC}"
echo "This may take a few minutes..."
echo ""

flutter build apk --release

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Build failed${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}======================================"
echo "  ✓ Build Successful!"
echo "======================================${NC}"
echo ""
echo "APK Location:"
echo "  build/app/outputs/flutter-apk/app-release.apk"
echo ""
echo "APK Size:"
ls -lh build/app/outputs/flutter-apk/app-release.apk | awk '{print "  " $5}'
echo ""
echo "To install on a connected device:"
echo "  flutter install"
echo ""
echo "Or manually:"
echo "  adb install build/app/outputs/flutter-apk/app-release.apk"
echo ""
echo -e "${GREEN}Done!${NC}"


