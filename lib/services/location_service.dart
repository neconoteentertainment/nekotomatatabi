import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../models/travel_memory.dart';

class LocationService {
  static const _userAgent = 'nekotomatatabi/0.1 (travel memory app)';

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

  Future<List<NearbyPlace>> findNearbyPlaces(double lat, double lon) async {
    final query = '''
[out:json][timeout:15];
(
  nwr(around:2500,$lat,$lon)[tourism];
  nwr(around:2500,$lat,$lon)[amenity~"museum|theatre|arts_centre|place_of_worship"];
  nwr(around:2500,$lat,$lon)[historic];
);
out center 30;
''';
    final response = await http.post(
      Uri.parse('https://overpass-api.de/api/interpreter'),
      headers: {'User-Agent': _userAgent, 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
      body: {'data': query},
    ).timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) {
      throw Exception('周辺施設の取得に失敗しました（${response.statusCode}）');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
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
      final key = '${name.trim()}_${plat.toStringAsFixed(4)}_${plon.toStringAsFixed(4)}';
      if (!seen.add(key)) continue;
      places.add(NearbyPlace(
        name: name.trim(),
        latitude: plat,
        longitude: plon,
        category: (tags['tourism'] ?? tags['historic'] ?? tags['amenity'] ?? '施設').toString(),
      ));
    }
    places.sort((a, b) {
      final da = Geolocator.distanceBetween(lat, lon, a.latitude, a.longitude);
      final db = Geolocator.distanceBetween(lat, lon, b.latitude, b.longitude);
      return da.compareTo(db);
    });
    return places.take(20).toList();
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
