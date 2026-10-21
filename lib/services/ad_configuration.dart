import 'package:flutter/foundation.dart';

/// 本番配布と開発・実機テストで使用する広告ユニットを切り替えます。
class AdConfiguration {
  const AdConfiguration({required this.isRelease, this.forceTestAds = false});

  static const current = AdConfiguration(
    isRelease: kReleaseMode,
    forceTestAds: bool.fromEnvironment('USE_TEST_ADS'),
  );

  final bool isRelease;
  final bool forceTestAds;

  bool get useTestAds => !isRelease || forceTestAds;

  String bannerAdUnitId(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
        return useTestAds
            ? 'ca-app-pub-3940256099942544/9214589741'
            : 'ca-app-pub-4121724126236374/6239139049';
      case TargetPlatform.iOS:
        return useTestAds
            ? 'ca-app-pub-3940256099942544/2435281174'
            : 'ca-app-pub-4121724126236374/9003621928';
      default:
        throw UnsupportedError('広告はAndroidとiOSのみ対応しています。');
    }
  }
}
