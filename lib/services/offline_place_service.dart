import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/travel_memory.dart';

/// The catalog is partitioned into one-degree cells; never decode all of Japan.
class OfflinePlaceService {
  OfflinePlaceService({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  Future<Map<String, dynamic>>? _manifest;
  String? snapshot;
  static const assetRoot = 'assets/offline_places/';

  Future<List<NearbyPlace>> findNearbyPlaces(
    double latitude,
    double longitude, {
    int radiusMeters = 300,
  }) async {
    if (!latitude.isFinite ||
        !longitude.isFinite ||
        latitude.abs() > 90 ||
        longitude.abs() > 180) {
      throw ArgumentError('Invalid coordinates');
    }
    final manifest = await (_manifest ??= _loadManifest());
    snapshot = manifest['snapshot'] as String;
    final cells = manifest['cells'] as Map<String, dynamic>;
    final radius = radiusMeters.clamp(100, 1000);
    // Conservative latitude/longitude bounds, including adjacent cell edges.
    final deltaLat = radius / 110000.0;
    final cosine = math.cos(latitude * math.pi / 180).abs();
    final deltaLon = cosine < 0.001 ? 180.0 : radius / (110000 * cosine);
    final chunks = <Uint8List>[];
    for (var y = (latitude - deltaLat).floor();
        y <= (latitude + deltaLat).floor();
        y++) {
      for (var x = (longitude - deltaLon).floor();
          x <= (longitude + deltaLon).floor();
          x++) {
        final cell = cells['${y}_$x'] as Map<String, dynamic>?;
        if (cell == null) continue;
        final bytes = await _bundle.load('$assetRoot${cell['file']}');
        chunks.add(
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
        );
      }
    }
    return compute(_searchCells, <String, dynamic>{
      'chunks': chunks,
      'categories': manifest['categories'],
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
    });
  }

  Future<Map<String, dynamic>> _loadManifest() async {
    try {
      final result = jsonDecode(
        await _bundle.loadString('${assetRoot}manifest.json'),
      ) as Map<String, dynamic>;
      if (result['schema'] != 1 ||
          result['cells'] is! Map ||
          result['categories'] is! List ||
          result['snapshot'] is! String) {
        throw const FormatException('Unsupported offline catalog');
      }
      return result;
    } catch (_) {
      _manifest = null; // A failed read must not poison subsequent retries.
      rethrow;
    }
  }
}

List<NearbyPlace> _searchCells(Map<String, dynamic> request) {
  final latitude = request['latitude'] as double;
  final longitude = request['longitude'] as double;
  final radius = request['radius'] as int;
  final categories = (request['categories'] as List).cast<String>();
  final matches = <({NearbyPlace place, double distance})>[];
  for (final chunk in request['chunks'] as List<Uint8List>) {
    final rows = jsonDecode(utf8.decode(gzip.decode(chunk))) as List;
    for (final raw in rows) {
      final row = raw as List;
      final lat = (row[2] as num).toDouble();
      final lon = (row[3] as num).toDouble();
      final radians = math.pi / 180;
      final a = math.pow(math.sin((lat - latitude) * radians / 2), 2) +
          math.cos(latitude * radians) *
              math.cos(lat * radians) *
              math.pow(math.sin((lon - longitude) * radians / 2), 2);
      final distance = 6371000 * 2 * math.asin(math.sqrt(a.clamp(0, 1)));
      if (distance > radius) continue;
      matches.add((
        place: NearbyPlace(
          name: row[1] as String,
          latitude: lat,
          longitude: lon,
          category: categories[row[4] as int],
        ),
        distance: distance,
      ));
    }
  }
  matches.sort((a, b) {
    final order = a.distance.compareTo(b.distance);
    return order != 0 ? order : a.place.name.compareTo(b.place.name);
  });
  return matches.take(30).map((item) => item.place).toList();
}
