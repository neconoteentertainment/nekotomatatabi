import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../services/ad_service.dart';

/// 画面幅に合うGoogle公式テストバナー。
///
/// 対応OSでは読み込み前から広告枠の高さを確保し、広告の成否によって
/// ページ本体が伸縮しないようにします。
class AppBannerAd extends StatefulWidget {
  const AppBannerAd({
    super.key,
    this.horizontalPadding = 12,
    this.verticalPadding = 4,
  });

  final double horizontalPadding;
  final double verticalPadding;

  @override
  State<AppBannerAd> createState() => _AppBannerAdState();
}

class _AppBannerAdState extends State<AppBannerAd> {
  static const double _maxAdHeight = 60;

  BannerAd? _banner;
  int? _loadedWidth;
  int? _loadingWidth;
  int? _failedWidth;

  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }

  Future<void> _load(int width) async {
    if (!mounted ||
        width <= 0 ||
        _loadingWidth == width ||
        _loadedWidth == width) {
      return;
    }
    _loadingWidth = width;
    _failedWidth = null;

    final adaptiveSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      width,
    );
    if (!mounted || _loadingWidth != width) return;
    if (adaptiveSize == null) {
      setState(() {
        _loadingWidth = null;
        _failedWidth = width;
      });
      return;
    }

    // 大画面で広告が固定枠より高くなる場合は、標準バナーへ切り替える。
    // これにより広告が本文へはみ出したり、本文を押し出したりしない。
    final size = adaptiveSize.height <= _maxAdHeight
        ? adaptiveSize
        : AdSize.banner;
    if (size.width > width) {
      setState(() {
        _loadingWidth = null;
        _failedWidth = width;
      });
      return;
    }

    final previous = _banner;
    final banner = BannerAd(
      adUnitId: AdService.instance.bannerAdUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted || _loadingWidth != width) {
            ad.dispose();
            return;
          }
          previous?.dispose();
          setState(() {
            _banner = ad as BannerAd;
            _loadedWidth = width;
            _loadingWidth = null;
          });
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          if (!mounted || _loadingWidth != width) return;
          _banner?.dispose();
          setState(() {
            _loadingWidth = null;
            _failedWidth = width;
            _banner = null;
            _loadedWidth = null;
          });
        },
      ),
    );
    await banner.load();
  }

  @override
  Widget build(BuildContext context) {
    final service = AdService.instance;
    if (!service.isSupported) return const SizedBox.shrink();

    return SafeArea(
      top: false,
      child: SizedBox(
        height: _maxAdHeight + widget.verticalPadding * 2,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widget.horizontalPadding,
            vertical: widget.verticalPadding,
          ),
          child: ValueListenableBuilder<bool>(
            valueListenable: service.canLoadAds,
            builder: (context, allowed, _) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth.floor();
                  if (allowed &&
                      _loadedWidth != width &&
                      _loadingWidth != width &&
                      _failedWidth != width) {
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => _load(width));
                  }
                  final banner = _banner;
                  if (banner == null || _loadedWidth != width) {
                    return const SizedBox.expand();
                  }
                  return Center(
                    child: SizedBox(
                      width: banner.size.width.toDouble(),
                      height: banner.size.height.toDouble(),
                      child: AdWidget(ad: banner),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
