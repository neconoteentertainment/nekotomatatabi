import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../services/ad_service.dart';

/// 画面幅に合うGoogle公式テストバナー。
/// 非対応OS・未同意・読み込み失敗時は表示領域ごと隠します。
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

    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      width,
    );
    if (!mounted || size == null || _loadingWidth != width) return;

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

    return ValueListenableBuilder<bool>(
      valueListenable: service.canLoadAds,
      builder: (context, allowed, _) {
        if (!allowed) return const SizedBox.shrink();
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.horizontalPadding,
              vertical: widget.verticalPadding,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth.floor();
                if (_loadedWidth != width &&
                    _loadingWidth != width &&
                    _failedWidth != width) {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _load(width));
                }
                final banner = _banner;
                if (banner == null || _loadedWidth != width) {
                  return const SizedBox.shrink();
                }
                return Center(
                  child: SizedBox(
                    width: banner.size.width.toDouble(),
                    height: banner.size.height.toDouble(),
                    child: AdWidget(ad: banner),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
