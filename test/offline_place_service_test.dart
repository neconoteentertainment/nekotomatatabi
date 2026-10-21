import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nekotomatatabi/services/location_service.dart';
import 'package:nekotomatatabi/services/offline_place_service.dart';

class CatalogBundle extends CachingAssetBundle {
  final loaded = <String>[];
  bool corrupt = false;
  @override
  Future<ByteData> load(String key) async {
    loaded.add(key);
    final manifest = {
      'schema': 1,
      'snapshot': '2026-10-19',
      'categories': ['公園'],
      'cells': {
        '34_134': {'file': 'west.gz'},
        '34_135': {'file': 'east.gz'},
      },
    };
    final rows = key.endsWith('west.gz')
        ? [
            ['n1', '西', 34.5, 134.999, 0],
          ]
        : [
            ['n2', '東', 34.5, 135.001, 0],
            ['n3', '範囲外', 34.5, 135.02, 0],
            for (var i = 0; i < 35; i++)
              ['n${i + 4}', '候補$i', 34.5005 + i * .00001, 135.002, 0],
          ];
    final bytes = key.endsWith('manifest.json')
        ? utf8.encode(jsonEncode(manifest))
        : corrupt
            ? [0, 1, 2]
            : gzip.encode(utf8.encode(jsonEncode(rows)));
    return ByteData.sublistView(Uint8List.fromList(bytes));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'search crosses cell edge, filters radius, sorts distance and limits to 30',
    () async {
      final bundle = CatalogBundle();
      final offline = OfflinePlaceService(bundle: bundle);
      final places = await offline.findNearbyPlaces(34.5, 135.0005);
      expect(places.length, 30);
      expect(places.first.name, '東');
      expect(places.any((p) => p.name == '西'), isTrue);
      expect(places.any((p) => p.name == '範囲外'), isFalse);
      expect(
        bundle.loaded,
        containsAll([
          'assets/offline_places/west.gz',
          'assets/offline_places/east.gz',
        ]),
      );
      expect(offline.snapshot, '2026-10-19');
      expect(await offline.findNearbyPlaces(0, 0), isEmpty);
    },
  );
  test(
    'corrupt cell and invalid coordinates do not return false empty success',
    () async {
      final bundle = CatalogBundle()..corrupt = true;
      final offline = OfflinePlaceService(bundle: bundle);
      await expectLater(offline.findNearbyPlaces(34.5, 135), throwsA(anything));
      await expectLater(
        offline.findNearbyPlaces(double.nan, 135),
        throwsArgumentError,
      );
    },
  );
  test('valid online result (including empty) skips offline assets', () async {
    final bundle = CatalogBundle();
    final service = LocationService(
      offline: OfflinePlaceService(bundle: bundle),
      clientFactory: () =>
          MockClient((_) async => http.Response('{"elements":[]}', 200)),
    );
    expect(await service.findNearbyPlaces(34.5, 135), isEmpty);
    expect(service.lastSearchUsedOffline, isFalse);
    expect(bundle.loaded, isEmpty);
  });
  test('first successful online endpoint wins after another fails', () async {
    var requests = 0;
    final bundle = CatalogBundle();
    final service = LocationService(
        offline: OfflinePlaceService(bundle: bundle),
        endpointStartInterval: const Duration(milliseconds: 2),
        clientFactory: () => MockClient((_) async {
              requests++;
              if (requests == 1) return http.Response('unavailable', 503);
              return http.Response(
                  jsonEncode({
                    'elements': [
                      {
                        'lat': 34.5,
                        'lon': 135.001,
                        'tags': {'name': '公園', 'leisure': 'park'}
                      },
                    ]
                  }),
                  200,
                  headers: {'content-type': 'application/json; charset=utf-8'});
            }));
    final places = await service.findNearbyPlaces(34.5, 135);
    expect(places.single.name, '公園');
    expect(places.single.category, '公園');
    expect(service.lastSearchUsedOffline, isFalse);
    expect(bundle.loaded, isEmpty);
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(requests, 2);
  });
  for (final body in [
    '{"remark":"runtime error","elements":[]}',
    '{"bad":true}',
    'invalid',
  ]) {
    test('HTTP 200 error or malformed response falls back: $body', () async {
      final service = LocationService(
        offline: OfflinePlaceService(bundle: CatalogBundle()),
        endpointStartInterval: const Duration(milliseconds: 1),
        clientFactory: () => MockClient((_) async => http.Response(body, 200)),
      );
      expect(await service.findNearbyPlaces(34.5, 135), isNotEmpty);
      expect(service.lastSearchUsedOffline, isTrue);
    });
  }
  test(
    'network failure falls back and corrupt fallback shows friendly message',
    () async {
      final bundle = CatalogBundle();
      final service = LocationService(
        offline: OfflinePlaceService(bundle: bundle),
        endpointStartInterval: const Duration(milliseconds: 1),
        clientFactory: () =>
            MockClient((_) async => throw http.ClientException('DNS')),
      );
      expect(await service.findNearbyPlaces(34.5, 135), isNotEmpty);
      bundle.corrupt = true;
      await expectLater(
        service.findNearbyPlaces(34.5, 135),
        throwsA(isA<NearbyPlaceFetchException>()),
      );
    },
  );
  test(
    'total deadline starts offline and cancels later endpoint starts',
    () async {
      var calls = 0;
      final service = LocationService(
        offline: OfflinePlaceService(bundle: CatalogBundle()),
        onlineBudget: const Duration(milliseconds: 20),
        endpointStartInterval: const Duration(milliseconds: 70),
        clientFactory: () => MockClient((_) async {
          calls++;
          await Future<void>.delayed(const Duration(milliseconds: 100));
          return http.Response('{"elements":[]}', 200);
        }),
      );
      expect(await service.findNearbyPlaces(34.5, 135), isNotEmpty);
      expect(service.lastSearchUsedOffline, isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 250));
      expect(calls, 1);
    },
  );
}
