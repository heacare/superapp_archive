fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios development_pull

```sh
[bundle exec] fastlane ios development_pull
```

Pull code-signing certificates for development

### ios cs_sync

```sh
[bundle exec] fastlane ios cs_sync
```

Synchronise all code-signing certificates. Useful when entitlements have changed

### ios development_sync

```sh
[bundle exec] fastlane ios development_sync
```

Synchronise code-signing certificates for development. Useful when devices have changed

### ios appstore_sync

```sh
[bundle exec] fastlane ios appstore_sync
```

Synchronise code-signing certificates for App Store

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Push a new beta build to TestFlight

### ios beta_distribute

```sh
[bundle exec] fastlane ios beta_distribute
```

Distribute the TestFlight beta build

----


## Android

### android beta

```sh
[bundle exec] fastlane android beta
```

Push a new beta build to Firebase

### android deploy

```sh
[bundle exec] fastlane android deploy
```

Deploy a new version to the Google Play

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
