import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// 広告SDKと同意管理を一か所にまとめます。
///
/// 現在はGoogle公式のテスト用IDだけを使います。本番公開前にAdMobで発行した
/// アプリID・広告ユニットIDへ差し替えてください。
class AdService {
  AdService._();

  static final AdService instance = AdService._();

  static const _androidBannerTestId =
      'ca-app-pub-3940256099942544/9214589741';
  static const _iosBannerTestId =
      'ca-app-pub-3940256099942544/2435281174';

  final ValueNotifier<bool> canLoadAds = ValueNotifier<bool>(false);
  final ValueNotifier<bool> privacyOptionsRequired =
      ValueNotifier<bool>(false);

  bool _started = false;
  bool _sdkInitialized = false;

  bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  String get bannerAdUnitId =>
      defaultTargetPlatform == TargetPlatform.android
          ? _androidBannerTestId
          : _iosBannerTestId;

  Future<void> initialize() async {
    if (!isSupported || _started) return;
    _started = true;

    final information = ConsentInformation.instance;
    information.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        await _refreshPrivacyOptionsStatus();
        ConsentForm.loadAndShowConsentFormIfRequired((_) async {
          await _refreshPrivacyOptionsStatus();
          await _initializeAdsIfAllowed();
        });
      },
      (_) async {
        // 通信失敗時も、以前保存された同意状態で広告を要求できる場合だけ開始します。
        await _refreshPrivacyOptionsStatus();
        await _initializeAdsIfAllowed();
      },
    );
  }

  Future<void> _initializeAdsIfAllowed() async {
    if (!await ConsentInformation.instance.canRequestAds()) return;
    if (!_sdkInitialized) {
      _sdkInitialized = true;
      await MobileAds.instance.initialize();
    }
    canLoadAds.value = true;
  }

  Future<void> _refreshPrivacyOptionsStatus() async {
    final status = await ConsentInformation.instance
        .getPrivacyOptionsRequirementStatus();
    privacyOptionsRequired.value =
        status == PrivacyOptionsRequirementStatus.required;
  }

  Future<FormError?> showPrivacyOptions() async {
    if (!isSupported) return null;
    FormError? result;
    await ConsentForm.showPrivacyOptionsForm((error) {
      result = error;
    });
    await _refreshPrivacyOptionsStatus();
    await _initializeAdsIfAllowed();
    return result;
  }
}
