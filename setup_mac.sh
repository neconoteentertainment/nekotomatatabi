#!/bin/sh
set -e
cd "$(dirname "$0")"

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter command was not found. Add Flutter to PATH first."
  exit 1
fi

# 不足しているプラットフォームだけを生成する。
# 既存のiOSプロジェクトを再生成するとShare Extension設定が失われるため、
# Runner.xcodeprojが存在する場合はiOSへflutter createを実行しない。
if [ ! -f android/app/build.gradle ] && [ ! -f android/app/build.gradle.kts ]; then
  flutter create . --platforms=android --org com.neconote --project-name nekotomatatabi
fi
if [ ! -f ios/Runner.xcodeproj/project.pbxproj ]; then
  flutter create . --platforms=ios --org com.neconote --project-name nekotomatatabi
fi

# flutter createでAndroidを生成した場合も、テスト用AdMobアプリIDを確実に残す。
android_manifest="android/app/src/main/AndroidManifest.xml"
if [ -f "$android_manifest" ] && \
   ! grep -q 'com.google.android.gms.ads.APPLICATION_ID' "$android_manifest"; then
  perl -0pi -e 's!(<application\b[^>]*>)!$1\n        <!-- Google公式テスト用AdMobアプリID。本番公開前に実IDへ差し替えます。 -->\n        <meta-data\n            android:name="com.google.android.gms.ads.APPLICATION_ID"\n            android:value="ca-app-pub-3940256099942544~3347511713" />!' "$android_manifest"
fi

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
  set_plist_string GADApplicationIdentifier "ca-app-pub-3940256099942544~1458002511"
fi
flutter pub get

echo "Setup finished. For iPhone: open ios/Runner.xcworkspace"
