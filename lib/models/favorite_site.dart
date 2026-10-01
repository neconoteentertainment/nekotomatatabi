import 'dart:convert';
import 'dart:io';

class FavoriteSite {
  const FavoriteSite({
    required this.id,
    required this.prefecture,
    required this.title,
    required this.url,
    required this.createdAt,
  });

  final String id;
  final String prefecture;
  final String title;
  final String url;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'prefecture': prefecture,
        'title': title,
        'url': url,
        'createdAt': createdAt.toIso8601String(),
      };

  factory FavoriteSite.fromJson(Map<String, dynamic> json) => FavoriteSite(
        id: json['id'] as String? ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        prefecture: json['prefecture'] as String? ?? '',
        title: json['title'] as String? ?? '',
        url: json['url'] as String? ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );
}

class FavoriteSiteBundle {
  const FavoriteSiteBundle({
    required this.prefecture,
    required this.sites,
  });

  final String prefecture;
  final List<FavoriteSite> sites;

  String toShareText() {
    final json = jsonEncode({
      'type': 'nekotomatatabi_favorite_sites_v1',
      'prefecture': prefecture,
      'sites': sites
          .map((site) => {
                'title': site.title,
                'url': site.url,
              })
          .toList(growable: false),
    });
    final compressed = GZipCodec().encode(utf8.encode(json));
    return 'NKS1:${base64UrlEncode(compressed)}';
  }

  static FavoriteSiteBundle? fromShareText(String raw) {
    try {
      final jsonText = raw.startsWith('NKS1:')
          ? utf8.decode(
              GZipCodec().decode(base64Url.decode(raw.substring(5))),
            )
          : raw;
      final data = jsonDecode(jsonText) as Map<String, dynamic>;
      if (data['type'] != 'nekotomatatabi_favorite_sites_v1') return null;
      final prefecture = data['prefecture'] as String? ?? '';
      if (prefecture.isEmpty) return null;
      final now = DateTime.now();
      final sites = (data['sites'] as List<dynamic>? ?? const [])
          .map((entry) => Map<String, dynamic>.from(entry as Map))
          .where((entry) => (entry['url'] as String? ?? '').isNotEmpty)
          .map(
            (entry) => FavoriteSite(
              id: "${now.microsecondsSinceEpoch}_${entry['url'].hashCode}",
              prefecture: prefecture,
              title: entry['title'] as String? ?? '',
              url: entry['url'] as String,
              createdAt: now,
            ),
          )
          .toList(growable: false);
      return FavoriteSiteBundle(prefecture: prefecture, sites: sites);
    } catch (_) {
      return null;
    }
  }
}
