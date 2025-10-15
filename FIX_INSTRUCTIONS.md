# 🔧 Fix Flutter & Build APK

## The Problem

Your Flutter installation has a permission issue with its cache directory. This prevents any Flutter commands from running.

## The Solution

### Option 1: Run the Fix Script (Easiest)

Open Terminal and run:

```bash
cd /Users/mor/foom_app
sudo ./fix_flutter_and_build.sh
```

Enter your Mac password when prompted. This script will:
1. Fix Flutter permissions
2. Clean the project
3. Get dependencies
4. Build your APK

**That's it!** Your APK will be ready in 5-10 minutes.

---

### Option 2: Manual Fix

If you prefer to do it manually:

#### Step 1: Fix Flutter Permissions
```bash
sudo chmod -R 755 /usr/local/share/flutter
```

#### Step 2: Build the APK
```bash
cd /Users/mor/foom_app
flutter clean
flutter pub get
flutter build apk --release
```

---

## After Building

Your APK will be at:
```
/Users/mor/foom_app/build/app/outputs/flutter-apk/app-release.apk
```

### Install on Your Phone

**Via Flutter:**
```bash
flutter install
```

**Via ADB:**
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

**Manual:**
1. Copy the APK file to your phone
2. Open it and install
3. You may need to allow "Install from Unknown Sources"

---

## Troubleshooting

### "Permission denied" errors
Make sure you're using `sudo`:
```bash
sudo ./fix_flutter_and_build.sh
```

### "Flutter not found"
Check Flutter installation:
```bash
which flutter
flutter doctor -v
```

### Build takes too long
First build can take 10-15 minutes. This is normal.

### Still having issues?

Try this complete reset:
```bash
# Fix all Flutter permissions
sudo chmod -R 755 /usr/local/share/flutter

# Go to project
cd /Users/mor/foom_app

# Complete clean
flutter clean
rm -rf build/
rm -rf .dart_tool/

# Rebuild
flutter pub get
flutter build apk --release
```

---

## What's Next?

Once your APK is built:

1. ✅ Install on your phone
2. ✅ Create an account (email or Google)
3. ✅ Grant Usage Access permission
4. ✅ Start using the app!
5. ✅ Check back tomorrow to see your first tokens!

---

## Expected Build Output

You should see:
```
✓ Built build/app/outputs/flutter-apk/app-release.apk (45.2MB)
```

File size will be around 40-60 MB.

---

## Need Help?

Check the other documentation files:
- **README.md** - Main overview
- **QUICK_START.md** - Quick build guide
- **PROJECT_OVERVIEW.md** - Technical details

---

**Good luck with your build! 🚀**


