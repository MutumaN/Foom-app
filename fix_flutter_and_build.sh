#!/bin/bash

# FOOM App - Fix Flutter Permissions and Build
# Run this with: sudo ./fix_flutter_and_build.sh

set -e

echo "======================================"
echo "  FOOM App - Fix & Build Script"
echo "======================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run with sudo:${NC}"
    echo "  sudo ./fix_flutter_and_build.sh"
    exit 1
fi

echo -e "${YELLOW}Step 1: Fixing Flutter permissions...${NC}"
chmod -R 755 /usr/local/share/flutter 2>/dev/null || true
chmod -R 755 /usr/local/share/flutter/bin/cache 2>/dev/null || true
echo -e "${GREEN}✓ Permissions fixed${NC}"
echo ""

# Get the actual user (not root)
ACTUAL_USER="${SUDO_USER:-$USER}"
PROJECT_DIR="/Users/mor/foom_app"

echo -e "${YELLOW}Step 2: Cleaning project...${NC}"
cd "$PROJECT_DIR"
sudo -u "$ACTUAL_USER" flutter clean
echo -e "${GREEN}✓ Project cleaned${NC}"
echo ""

echo -e "${YELLOW}Step 3: Getting dependencies...${NC}"
sudo -u "$ACTUAL_USER" flutter pub get
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to get dependencies${NC}"
    echo "Try manually: flutter pub get"
    exit 1
fi
echo -e "${GREEN}✓ Dependencies installed${NC}"
echo ""

echo -e "${YELLOW}Step 4: Building APK...${NC}"
echo "This will take several minutes..."
sudo -u "$ACTUAL_USER" flutter build apk --release
if [ $? -ne 0 ]; then
    echo -e "${RED}Build failed${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}======================================"
echo "  ✓✓✓ BUILD SUCCESSFUL! ✓✓✓"
echo "======================================${NC}"
echo ""
echo "Your APK is ready at:"
echo "  $PROJECT_DIR/build/app/outputs/flutter-apk/app-release.apk"
echo ""
ls -lh "$PROJECT_DIR/build/app/outputs/flutter-apk/app-release.apk" 2>/dev/null || echo "APK location: build/app/outputs/flutter-apk/app-release.apk"
echo ""
echo "To install:"
echo "  flutter install"
echo "  or"
echo "  adb install build/app/outputs/flutter-apk/app-release.apk"
echo ""
echo -e "${GREEN}Done!${NC}"


