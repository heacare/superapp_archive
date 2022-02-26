
# Happily Ever After

[![backend](https://github.com/Happily-Ever-After-Corp/hea/actions/workflows/backend.yml/badge.svg)](https://github.com/Happily-Ever-After-Corp/hea/actions/workflows/backend.yml)

## Developing

### App

#### Requirements

- [Flutter](https://docs.flutter.dev/get-started/install)
  - (Android) [Android Studio](https://developer.android.com/studio#downloads)
  - or [Android SDK command-line tools](https://developer.android.com/studio#command-tools) and JDK
    - Set `ANDROID_SDK_ROOT`
    - Extract command-line tools into `$ANDROID_SDK_ROOT/cmdline-tools/latest`
	- Add `$ANDROID_SDK_ROOT/cmdline-tools/latest/bin` to `PATH`
  - (iOS) Xcode

#### Setup

1. Clone
2. `cd app`
4. Set up your emulator
   - (Android) [Create device using AVD Manager](https://docs.flutter.dev/get-started/install/linux#set-up-the-android-emulator) or `avdmanager`
   - (iOS) [Start Simulator](https://docs.flutter.dev/get-started/install/macos#set-up-the-ios-simulator)

#### Running

```
flutter run
```

#### Configuring Firebase

1. [`dart pub global activate flutterfire_cli`](https://firebase.flutter.dev/docs/overview#using-the-flutterfire-cli)
   - Depends on [Firebase CLI](https://firebase.google.com/docs/cli)
2. `flutterfire configure`
   1. Login with your Google Account that has been granted access to the
      development Firebase project
   2. Pick the Firebase project
   3. Use the package name or bundle ID `health.happilyeverafter.app`

| Firebase project | Purpose |
|-|-|
| Happily Ever After - Dev | Development and testing |

### Backend

#### Requirements

- [Node.js](https://nodejs.org/en/download/)
- [Docker](https://www.docker.com/get-started)

#### Setup

1. Clone
2. `cd backend`
3. `npm install`

#### Running

```
docker-compose -f docker-compose.dev.yml up -d db adminer
```
