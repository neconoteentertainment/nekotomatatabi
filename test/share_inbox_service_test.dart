import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nekotomatatabi/services/share_inbox_service.dart';

const channel = MethodChannel('com.neconote.nekotomatatabi/share_inbox');

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  final service = ShareInboxService();
  tearDown(() {
    service.stopListening();
    debugDefaultTargetPlatformOverride = null;
    binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });
  Map<String, dynamic> page() => {
    'id': 'share1',
    'prefecture': '愛知県',
    'title': '公園',
    'url': 'https://example.org/park?a=1&b=2',
    'createdAt': '2026-10-21T00:00:00.000Z',
  };

  for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
    test(
      '$platform receives confirmed site and selected destination',
      () async {
        debugDefaultTargetPlatformOverride = platform;
        final calls = <String>[];
        binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
          call,
        ) async {
          calls.add(call.method);
          if (call.method == 'takePendingFavoriteSites') return [page()];
          expect(call.arguments, ['share1']);
          return null;
        });
        final sites = await service.takePendingFavoriteSites();
        expect(sites.single.title, '公園');
        expect(sites.single.prefecture, '愛知県');
        expect(sites.single.url, 'https://example.org/park?a=1&b=2');
        await service.acknowledgeFavoriteSites(sites);
        expect(
          calls,
          platform == TargetPlatform.android
              ? ['takePendingFavoriteSites', 'acknowledgeFavoriteSites']
              : ['takePendingFavoriteSites'],
        );
      },
    );
  }
  test('invalid rows do not prevent valid URL import', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (_) async => [
        {...page(), 'url': 'javascript:alert(1)'},
        {...page(), 'url': 'file:///private/file'},
        {...page(), 'url': 'https://'},
        {...page(), 'prefecture': ''},
        {...page(), 'title': 123},
        page(),
      ],
    );
    expect((await service.takePendingFavoriteSites()).length, 1);
  });
  test('older runner without a channel remains usable', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(await service.takePendingFavoriteSites(), isEmpty);
    await service.acknowledgeFavoriteSites(const []);
  });
  test('desktop never calls mobile share inbox', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (_) async => throw StateError('Unexpected native call'),
    );
    expect(await service.takePendingFavoriteSites(), isEmpty);
  });
  test(
    'foreground share notification reaches Flutter and is detached on stop',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      var received = 0;
      service.startListening(() => received++);
      Future<void> send() async {
        await binding.defaultBinaryMessenger.handlePlatformMessage(
          channel.name,
          const StandardMethodCodec().encodeMethodCall(
            const MethodCall('favoriteSitesAvailable'),
          ),
          (_) {},
        );
      }

      await send();
      expect(received, 1);
      service.stopListening();
      await send();
      expect(received, 1);
    },
  );
}
