import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nekotomatatabi/services/ad_configuration.dart';

void main() {
  const productionIds = {
    TargetPlatform.android: 'ca-app-pub-4121724126236374/6239139049',
    TargetPlatform.iOS: 'ca-app-pub-4121724126236374/9003621928',
  };
  const testIds = {
    TargetPlatform.android: 'ca-app-pub-3940256099942544/9214589741',
    TargetPlatform.iOS: 'ca-app-pub-3940256099942544/2435281174',
  };

  for (final platform in productionIds.keys) {
    test('$platform: release uses the production unit', () {
      const config = AdConfiguration(isRelease: true);
      expect(config.useTestAds, isFalse);
      expect(config.bannerAdUnitId(platform), productionIds[platform]);
    });
    test('$platform: development uses the test unit', () {
      const config = AdConfiguration(isRelease: false);
      expect(config.useTestAds, isTrue);
      expect(config.bannerAdUnitId(platform), testIds[platform]);
    });
    test('$platform: distribution testing overrides release', () {
      const config = AdConfiguration(isRelease: true, forceTestAds: true);
      expect(config.useTestAds, isTrue);
      expect(config.bannerAdUnitId(platform), testIds[platform]);
    });
  }

  test('desktop cannot accidentally request a mobile production unit', () {
    expect(
      () =>
          const AdConfiguration(isRelease: true)
              .bannerAdUnitId(TargetPlatform.windows),
      throwsUnsupportedError,
    );
  });

  test('build-time test override is connected to the active configuration', () {
    expect(AdConfiguration.current.isRelease, kReleaseMode);
    expect(
      AdConfiguration.current.forceTestAds,
      const bool.fromEnvironment('USE_TEST_ADS'),
    );
  });
}
