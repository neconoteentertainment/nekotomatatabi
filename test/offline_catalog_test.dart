import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nekotomatatabi/services/offline_place_service.dart';

class DiskCatalogBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async =>
      ByteData.sublistView(Uint8List.fromList(await File(key).readAsBytes()));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'national catalog manifest counts and compressed cells are consistent',
    () {
      final manifest = jsonDecode(
        File('assets/offline_places/manifest.json').readAsStringSync(),
      ) as Map;
      var total = 0;
      final ids = <String>{};
      for (final entry in (manifest['cells'] as Map).entries) {
        final rows = jsonDecode(
          utf8.decode(
            gzip.decode(
              File('assets/offline_places/${entry.value['file']}')
                  .readAsBytesSync(),
            ),
          ),
        ) as List;
        expect(rows.length, entry.value['count']);
        total += rows.length;
        for (final row in rows) {
          expect(ids.add(row[0] as String), isTrue);
          expect(
            '${(row[2] as num).floor()}_${(row[3] as num).floor()}',
            entry.key,
          );
          expect((row[1] as String).trim(), isNotEmpty);
        }
      }
      expect(total, 216406);
      expect(total, manifest['count']);
    },
  );
  for (final point in [
    ('札幌時計台', 43.0626, 141.3537),
    ('浅草', 35.7148, 139.7967),
    ('大阪城', 34.6873, 135.5262),
    ('首里城', 26.2170, 127.7195),
  ]) {
    test(
      'real bundled catalog returns local candidates near ${point.$1}',
      () async {
        final service = OfflinePlaceService(bundle: DiskCatalogBundle());
        final places = await service.findNearbyPlaces(
          point.$2,
          point.$3,
          radiusMeters: 1000,
        );
        expect(places, isNotEmpty);
        expect(places.length, lessThanOrEqualTo(30));
        expect(service.snapshot, '2026-10-19');
      },
    );
  }
}
