# Happily Ever After

[![backend](https://github.com/happilyeveraftercorp/hea/actions/workflows/backend.yaml/badge.svg)](https://github.com/happilyeveraftercorp/hea/actions/workflows/backend.yaml)
[![app](https://github.com/happilyeveraftercorp/hea/actions/workflows/app.yaml/badge.svg)](https://github.com/happilyeveraftercorp/hea/actions/workflows/app.yaml)
[![fastlane-beta](https://github.com/happilyeveraftercorp/hea/actions/workflows/fastlane-beta.yaml/badge.svg)](https://github.com/happilyeveraftercorp/hea/actions/workflows/fastlane-beta.yaml)

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
git clone git@github.com:happilyeveraftercorp/hea.git
cd hea/app
```

If you're working on iOS, run the following to obtain the code-signing certificates:

```
bundle exec fastlane development_pull
```

If you're working on Android, ask Ambrose for the debug keystore file. See the section on [Google Maps and Google Fit](#google-maps-and-google-fit) for more details.

### Running

```
flutter run
flutter run --device-id DEVICE_ID
# For a list of devices
flutter devices
```

### Managing code-signing certificates

To synchronise the list of development devices, run:

```
bundle exec fastlane development_sync
```

For other operations, see the [documentation](https://docs.fastlane.tools/actions/match/) for the `match` command-line tool.

### Configuring Firebase

You only need to do this to change the Firebase project

1. [`dart pub global activate flutterfire_cli`](https://firebase.flutter.dev/docs/overview#using-the-flutterfire-cli)
   - Depends on [Firebase CLI](https://firebase.google.com/docs/cli)
     - `npm install -g firebase-tools`
     - Login with your Google Account that has been granted access to the
       development Firebase project
2. `flutterfire configure --project happily-ever-after-4b2fe --ios-bundle-id care.hea.app --android-app-id care.hea.app`

| Firebase project         | Purpose                                 |
| ------------------------ | --------------------------------------- |
| happily-ever-after-4b2fe | Development, testing and inital version |

### Google Maps and Google Fit

Current API keys:

- Google Fit
  - Relies on the app's certificate, so the debug keystore SHA-1 needs to be [registered in CGP](https://console.cloud.google.com/apis/credentials?project=happily-ever-after-4b2fe)
  - Ambrose owns an already-registered debug keystore file.
- Google Maps (Ambrose's private project)
  - Eventually need to be replaced with an official release API key in the project and add security measures

## Developing (Backend)

### Requirements

- [Node.js](https://nodejs.org/en/download/)
- [Docker](https://www.docker.com/get-started)

### Setup

```
git clone git@github.com:happilyeveraftercorp/hea.git
cd hea/backend
```

### Running

```
docker-compose -f docker-compose.dev.yml up -d db adminer
```
