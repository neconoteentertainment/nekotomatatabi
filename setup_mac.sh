#!/bin/sh
set -e
cd "$(dirname "$0")"

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter command was not found. Add Flutter to PATH first."
  exit 1
fi

# Android/iOS project files are generated on the Mac. Existing app source and Info.plist are preserved.
flutter create . --platforms=android,ios --org com.neconote --project-name nekotomatatabi

# iOSのビルド環境を15.5以上へ統一する。
if [ -f ios/Podfile ]; then
  sed -i '' -E "s/^#?[[:space:]]*platform :ios, '[0-9.]+'/platform :ios, '15.5'/" ios/Podfile
fi
if [ -f ios/Runner.xcodeproj/project.pbxproj ]; then
  sed -i '' -E 's/IPHONEOS_DEPLOYMENT_TARGET = [0-9.]+;/IPHONEOS_DEPLOYMENT_TARGET = 15.5;/g' ios/Runner.xcodeproj/project.pbxproj
fi
if [ -f ios/Runner/Info.plist ]; then
  set_plist_string() {
    key="$1"
    value="$2"
    /usr/libexec/PlistBuddy -c "Set :$key $value" ios/Runner/Info.plist 2>/dev/null || \
      /usr/libexec/PlistBuddy -c "Add :$key string $value" ios/Runner/Info.plist
  }
  set_plist_string NSCameraUsageDescription "旅の写真を撮影するためにカメラを使用します。"
  set_plist_string NSPhotoLibraryUsageDescription "写真と電子チケットを選択するために写真ライブラリを使用します。"
  set_plist_string NSPhotoLibraryAddUsageDescription "撮影した画像を写真ライブラリへ保存するために使用します。"
  set_plist_string NSLocationWhenInUseUsageDescription "現在地周辺の観光地を検索するために位置情報を使用します。"
fi
flutter pub get

echo "Setup finished. For iPhone: open ios/Runner.xcworkspace"
