import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../models/travel_memory.dart';

class NearbyPlaceFetchException implements Exception {
  const NearbyPlaceFetchException(this.message);
  final String message;
  @override
  String toString() => message;
}

class LocationService {
  static const _userAgent = 'nekotomatatabi/0.2 (travel memory app)';
  static const _overpassEndpoints = [
    'https://overpass-api.de/api/interpreter',
    'https://overpass.kumi.systems/api/interpreter',
    'https://overpass.nchc.org.tw/api/interpreter',
  ];

  Future<Position> getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('位置情報サービスがOFFです。端末の設定からONにしてください。');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      throw Exception('位置情報の権限が必要です。端末の設定から許可してください。');
    }
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<List<NearbyPlace>> findNearbyPlaces(double lat, double lon, {int radiusMeters = 300}) async {
    final radius = radiusMeters.clamp(100, 1000);
    final query = '''
[out:json][timeout:12];
(
  nwr(around:$radius,$lat,$lon)[tourism~"attraction|museum|gallery|zoo|aquarium|viewpoint|hotel|guest_house|theme_park"];
  nwr(around:$radius,$lat,$lon)[amenity~"place_of_worship|arts_centre"];
  nwr(around:$radius,$lat,$lon)[historic];
  nwr(around:$radius,$lat,$lon)[leisure~"park|garden"];
  nwr(around:$radius,$lat,$lon)[castle_type];
  nwr(around:$radius,$lat,$lon)[shop~"department_store|mall"];
);
out center 40;
''';

    Object? lastError;
    for (var endpointIndex = 0; endpointIndex < _overpassEndpoints.length; endpointIndex++) {
      final endpoint = _overpassEndpoints[endpointIndex];
      for (var attempt = 0; attempt < 3; attempt++) {
        try {
          final response = await http.post(
            Uri.parse(endpoint),
            headers: {'User-Agent': _userAgent, 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
            body: {'data': query},
          ).timeout(const Duration(seconds: 15));

          if (response.statusCode == 200) {
            return _parsePlaces(response.body, lat, lon);
          }
          lastError = 'HTTP ${response.statusCode}';
          if (response.statusCode != 429 && response.statusCode != 502 && response.statusCode != 503 && response.statusCode != 504) {
            break;
          }
        } on TimeoutException catch (e) {
          lastError = e;
        } catch (e) {
          lastError = e;
        }
        if (attempt < 2) await Future<void>.delayed(Duration(milliseconds: 700 * (attempt + 1)));
      }
      if (endpointIndex < _overpassEndpoints.length - 1) {
        await Future<void>.delayed(const Duration(milliseconds: 600));
      }
    }
    throw NearbyPlaceFetchException('周辺施設の取得に失敗しました。現在地は取得できています。少し時間を置いて再試行するか、施設名を手入力してください。${lastError == null ? '' : ' ($lastError)'}');
  }

  List<NearbyPlace> _parsePlaces(String body, double lat, double lon) {
    final json = jsonDecode(body) as Map<String, dynamic>;
    final elements = json['elements'] as List<dynamic>? ?? const [];
    final places = <NearbyPlace>[];
    final seen = <String>{};
    for (final raw in elements) {
      final item = Map<String, dynamic>.from(raw as Map);
      final tags = Map<String, dynamic>.from(item['tags'] as Map? ?? const {});
      final name = (tags['name:ja'] ?? tags['name'] ?? tags['official_name'])?.toString();
      if (name == null || name.trim().isEmpty) continue;
      final center = item['center'] is Map ? Map<String, dynamic>.from(item['center'] as Map) : null;
      final plat = (item['lat'] as num?)?.toDouble() ?? (center?['lat'] as num?)?.toDouble();
      final plon = (item['lon'] as num?)?.toDouble() ?? (center?['lon'] as num?)?.toDouble();
      if (plat == null || plon == null) continue;
      final key = '${name.trim()}_${plat.toStringAsFixed(5)}_${plon.toStringAsFixed(5)}';
      if (!seen.add(key)) continue;
      places.add(NearbyPlace(
        name: name.trim(),
        latitude: plat,
        longitude: plon,
        category: _localizedCategory(tags),
      ));
    }
    places.sort((a, b) {
      final da = Geolocator.distanceBetween(lat, lon, a.latitude, a.longitude);
      final db = Geolocator.distanceBetween(lat, lon, b.latitude, b.longitude);
      return da.compareTo(db);
    });
    return places.take(30).toList();
  }

  String _localizedCategory(Map<String, dynamic> tags) {
    final tourism = tags['tourism']?.toString();
    final amenity = tags['amenity']?.toString();
    final historic = tags['historic']?.toString();
    final leisure = tags['leisure']?.toString();
    final shop = tags['shop']?.toString();

    switch (tourism) {
      case 'attraction': return '観光名所・ランドマーク';
      case 'museum': return '博物館・美術館';
      case 'gallery': return 'ギャラリー';
      case 'zoo': return '動物園';
      case 'aquarium': return '水族館';
      case 'viewpoint': return '展望台';
      case 'hotel':
      case 'guest_house': return 'ホテル・旅館';
      case 'theme_park': return 'テーマパーク';
    }
    if (amenity == 'place_of_worship') return '寺社・教会';
    if (amenity == 'arts_centre') return 'ギャラリー・文化施設';
    if (leisure == 'park') return '公園';
    if (leisure == 'garden') return '庭園';
    if (shop == 'department_store' || shop == 'mall') return '有名な商業施設';
    if (historic != null || tags['castle_type'] != null) return '城・史跡';
    return '観光施設';
  }

  Future<String> reversePrefecture(double lat, double lon) async {
    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
        'format': 'jsonv2',
        'lat': '$lat',
        'lon': '$lon',
        'accept-language': 'ja',
        'zoom': '8',
      });
      final response = await http.get(uri, headers: {'User-Agent': _userAgent}).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return '不明';
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final address = Map<String, dynamic>.from(json['address'] as Map? ?? const {});
      return (address['province'] ?? address['state'] ?? address['region'] ?? '不明').toString();
    } catch (_) {
      return '不明';
    }
  }
}
