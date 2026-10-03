import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/favorite_site.dart';

/// iOS Share Extension が App Group に一時保存したお気に入りを取り込む。
///
/// 共有拡張が存在しないプラットフォームでは空の一覧を返すため、
/// Windows / Android の既存動作には影響しない。
class ShareInboxService {
  static const _channel = MethodChannel('com.neconote.nekotomatatabi/share_inbox');

  Future<List<FavoriteSite>> takePendingFavoriteSites() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) return const [];

    try {
      final rows = await _channel.invokeListMethod<dynamic>('takePendingFavoriteSites');
      if (rows == null) return const [];

      return rows
          .whereType<Map>()
          .map((row) => Map<String, dynamic>.from(row))
          .map(FavoriteSite.fromJson)
          .where((site) => site.prefecture.isNotEmpty && site.url.isNotEmpty)
          .toList(growable: false);
    } on PlatformException {
      return const [];
    } on MissingPluginException {
      return const [];
    }
  }
}
