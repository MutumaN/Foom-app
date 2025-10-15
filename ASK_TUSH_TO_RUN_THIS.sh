#!/bin/bash

# Hey Tush! 
# Mor needs to use the Android SDK to build an app.
# Please run this script to share your SDK with Mor's user account.

echo "=============================================="
echo "  Share Android SDK with user 'mor'"
echo "=============================================="
echo ""
echo "This will give user 'mor' access to your Android SDK"
echo "so they can build their Flutter app."
echo ""
echo "Your SDK won't be modified, just made accessible."
echo ""
read -p "Press Enter to continue..."

# Make SDK readable by mor
sudo chmod -R 755 /Users/tush/Library/Android/sdk

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Done! Now mor can run:"
    echo ""
    echo "   ln -s /Users/tush/Library/Android/sdk ~/Library/Android/sdk"
    echo "   echo 'export ANDROID_HOME=\$HOME/Library/Android/sdk' >> ~/.zshrc"
    echo "   source ~/.zshrc"
    echo "   cd /Users/mor/foom_app"
    echo "   flutter build apk --release"
    echo ""
    echo "Thanks! 🙏"
else
    echo ""
    echo "❌ Failed. Make sure you run this with: sudo ./ASK_TUSH_TO_RUN_THIS.sh"
fi


