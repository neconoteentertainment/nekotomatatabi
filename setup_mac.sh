#!/bin/sh
set -e
cd "$(dirname "$0")"
flutter create . --platforms=android,ios --org com.neconote --project-name nekotomatatabi
flutter pub get
echo "Setup finished. Run: flutter run"
