import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/favorite_site.dart';

/// iOS Share Extension / Android共有画面で確認済みのお気に入りを取り込む。
class ShareInboxService {
  static const _channel = MethodChannel(
    'com.neconote.nekotomatatabi/share_inbox',
  );

  void startListening(VoidCallback onAvailable) {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'favoriteSitesAvailable') onAvailable();
    });
  }

  void stopListening() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      _channel.setMethodCallHandler(null);
    }
  }

  Future<List<FavoriteSite>> takePendingFavoriteSites() async {
    if (defaultTargetPlatform != TargetPlatform.iOS &&
        defaultTargetPlatform != TargetPlatform.android) {
      return const [];
    }

    try {
      final rows = await _channel.invokeListMethod<dynamic>(
        'takePendingFavoriteSites',
      );
      if (rows == null) return const [];

      final sites = <FavoriteSite>[];
      for (final row in rows.whereType<Map>()) {
        try {
          final site = FavoriteSite.fromJson(Map<String, dynamic>.from(row));
          final uri = Uri.tryParse(site.url);
          if (site.prefecture.isNotEmpty &&
              uri != null &&
              uri.host.isNotEmpty &&
              (uri.scheme == 'http' || uri.scheme == 'https')) {
            sites.add(site);
          }
        } catch (_) {
          // Skip an invalid row without dropping other shared pages.
        }
      }
      return sites;
    } on PlatformException {
      return const [];
    } on MissingPluginException {
      return const [];
    }
  }

  /// Android keeps pending rows until repository persistence has succeeded.
  Future<void> acknowledgeFavoriteSites(Iterable<FavoriteSite> sites) async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _channel.invokeMethod<void>(
        'acknowledgeFavoriteSites',
        sites.map((site) => site.id).toList(growable: false),
      );
    } on PlatformException {
      // Retained rows are retried next time; repository import deduplicates them.
    } on MissingPluginException {
      // Older platform runners can still use manual URL registration.
    }
  }
}
