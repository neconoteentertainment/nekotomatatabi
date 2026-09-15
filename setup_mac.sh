#!/bin/sh
set -e
cd "$(dirname "$0")"

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter command was not found. Add Flutter to PATH first."
  exit 1
fi

# Android/iOS project files are generated on the Mac. Existing app source and Info.plist are preserved.
flutter create . --platforms=android,ios --org com.neconote --project-name nekotomatatabi
flutter pub get

echo "Setup finished. For iPhone: open ios/Runner.xcworkspace"
