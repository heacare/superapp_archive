
# Happily Ever After

[![backend](https://github.com/Happily-Ever-After-Corp/hea/actions/workflows/backend.yml/badge.svg)](https://github.com/Happily-Ever-After-Corp/hea/actions/workflows/backend.yml)

## Developing (App)

### Requirements

1. [Flutter](https://docs.flutter.dev/get-started/install)
2. (Android) Android SDK
   - [Android Studio](https://developer.android.com/studio#downloads)
   - or [Android SDK command-line tools](https://developer.android.com/studio#command-tools) and JDK
     - Set `ANDROID_SDK_ROOT`
       ```
       export ANDROID_SDK_ROOT="$HOME/android-sdk"
       ```
       - Add the above to your `.bashrc` or `.zshrc`
     - Extract command-line tools into `$ANDROID_SDK_ROOT/cmdline-tools/latest`
       ```
       mkdir -p "$ANDROID_SDK_ROOT/cmdline-tools"
       cd "$ANDROID_SDK_ROOT/cmdline-tools"
       unzip $PATH_TO_ZIP
       mv cmdline-tools latest
       ```
     - Add `$ANDROID_SDK_ROOT/cmdline-tools/latest/bin` to `PATH`
       ```
       export PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH"
       ```
       - Add the above to your `.bashrc` or `.zshrc`
     - Install Android 12 SDK
       ```
       sdkmanager "platform-tools" "build-tools;32.0.0" "platforms;android-32"
       ```
     - Accept licenses
       ```
       flutter doctor --android-licenses
       ```
   - or `brew install android-sdk`
3. (iOS) Xcode
   - Install command-line tools
     ```
     sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`
     sudo xcodebuild -runFirstLaunch
     ```
   - Accept licenses
     ```
     sudo xcodebuild -license
     ```
4. Existing emulator
   - (Android) [Create device using AVD Manager](https://docs.flutter.dev/get-started/install/linux#set-up-the-android-emulator) or `avdmanager`
     ```
     sdkmanager "system-images;android-31;google_apis_playstore;x86_64"
     avdmanager create avd --name flutter_emulator --package "system-images;android-31;google_apis_playstore;x86_64" --device pixel_5
     flutter emulators --launch flutter_emulator
     ```
	 - You might want to enable hardware keyboard by setting this property in `~/.android/avd/flutter_emulator.avd/config.ini`:
	   ```
	   hw.keyboard = yes
       ```
   - (iOS) [Start Simulator](https://docs.flutter.dev/get-started/install/macos#set-up-the-ios-simulator)
     ```
     flutter emulators --launch apple_ios_simulator
     ```
5. Check Flutter setup
   ```
   flutter doctor
   ```

### Setup

```
git clone git@github.com:Happily-Ever-After-Corp/hea.git
cd hea/app
```

### Running

```
flutter run
```

### Configuring Firebase

You only need to do this to change the Firebase project

1. [`dart pub global activate flutterfire_cli`](https://firebase.flutter.dev/docs/overview#using-the-flutterfire-cli)
   - Depends on [Firebase CLI](https://firebase.google.com/docs/cli)
     - `npm install -g firebase-tools`
     - Login with your Google Account that has been granted access to the
       development Firebase project
2. `flutterfire configure --project happily-ever-after-4b2fe --ios-bundle-id care.hea.app --android-app-id care.hea.app`

| Firebase project | Purpose |
|-|-|
| happily-ever-after-4b2fe | Development, testing and inital version |

## Developing (Backend)

### Requirements

- [Node.js](https://nodejs.org/en/download/)
- [Docker](https://www.docker.com/get-started)

### Setup

```
git clone git@github.com:Happily-Ever-After-Corp/hea.git
cd hea/backend
```

### Running

```
docker-compose -f docker-compose.dev.yml up -d db adminer
```
