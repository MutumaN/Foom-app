# 🔧 Setup Android SDK

## The Issue

You have Android Studio installed, but the Android SDK is not set up for your user account (mor).

The SDK might be installed for user "tush", but you need your own copy.

## ✅ Solution: Install Android SDK (5 minutes)

### Option 1: Use Android Studio (Easiest)

1. **Open Android Studio**
   - Find it in Applications
   - Or run: `open "/Applications/Android Studio.app"`

2. **Configure SDK**
   - When Android Studio opens, it should show a welcome screen
   - Click on **"More Actions"** → **"SDK Manager"**
   - Or go to: **Android Studio** → **Settings** → **Appearance & Behavior** → **System Settings** → **Android SDK**

3. **Install SDK Components**
   - Check these boxes:
     - ✅ Android SDK Platform (latest version)
     - ✅ Android SDK Build-Tools
     - ✅ Android SDK Command-line Tools
     - ✅ Android SDK Platform-Tools
   - Click **"Apply"** and let it download

4. **Note the SDK Location**
   - It should be: `/Users/mor/Library/Android/sdk`
   - Remember this path!

5. **Close Android Studio**

---

### Option 2: Manual Setup via Command Line

Run these commands in Terminal:

```bash
# Create SDK directory
mkdir -p ~/Library/Android/sdk

# Download command line tools (latest version)
cd ~/Library/Android/sdk
curl -o cmdline-tools.zip https://dl.google.com/android/repository/commandlinetools-mac-9477386_latest.zip

# Extract
unzip cmdline-tools.zip
mkdir -p cmdline-tools/latest
mv cmdline-tools/* cmdline-tools/latest/

# Install required components
cd cmdline-tools/latest/bin
yes | ./sdkmanager --licenses
./sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"
```

---

## 🔧 Set Environment Variable

After installing, add this to your shell profile:

### For zsh (default on macOS):

```bash
echo 'export ANDROID_HOME=$HOME/Library/Android/sdk' >> ~/.zshrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.zshrc
echo 'export PATH=$PATH:$ANDROID_HOME/tools' >> ~/.zshrc
source ~/.zshrc
```

### For bash:

```bash
echo 'export ANDROID_HOME=$HOME/Library/Android/sdk' >> ~/.bash_profile
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.bash_profile
echo 'export PATH=$PATH:$ANDROID_HOME/tools' >> ~/.bash_profile
source ~/.bash_profile
```

---

## ✅ Verify Setup

Run this to verify:

```bash
echo $ANDROID_HOME
```

Should show: `/Users/mor/Library/Android/sdk`

Check Flutter can see it:

```bash
flutter doctor -v
```

Should show Android toolchain with a ✓ (or at least no SDK error)

---

## 🚀 Then Build Your APK

After SDK is set up:

```bash
cd /Users/mor/foom_app
flutter doctor --android-licenses  # Accept licenses
flutter clean
flutter pub get
flutter build apk --release
```

---

## 🆘 Quick Fix (If user "tush" has SDK)

If user "tush" has the SDK installed, they could share it:

```bash
# Ask tush to run this:
sudo ln -s /Users/tush/Library/Android/sdk /Users/mor/Library/Android/sdk
```

Then you set the environment variable:

```bash
echo 'export ANDROID_HOME=$HOME/Library/Android/sdk' >> ~/.zshrc
source ~/.zshrc
```

---

## 📱 Expected Result

After setup, you should see:

```bash
$ flutter doctor

[✓] Flutter (Channel stable, ...)
[✓] Android toolchain - develop for Android devices
[✓] Xcode - develop for iOS and macOS
[✓] Android Studio (version ...)
```

Then you can build your APK! 🚀

---

## ⏱️ Time Estimate

- Via Android Studio: 5-10 minutes (recommended)
- Via Command Line: 10-15 minutes

---

**After this, your build will work!**


