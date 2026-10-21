import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nekotomatatabi/models/favorite_site.dart';
import 'package:nekotomatatabi/services/app_repository.dart';
import 'package:nekotomatatabi/services/storage_service.dart';

class TestStorage extends StorageService {
  bool fail = false;
  Completer<void>? gate;
  final started = Completer<void>();
  List<FavoriteSite> saved = [];
  @override
  Future<void> saveFavoriteSites(List<FavoriteSite> sites) async {
    if (!started.isCompleted) started.complete();
    await gate?.future;
    if (fail) throw StateError('Disk failure');
    saved = List.of(sites);
  }
}

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  const inbox = MethodChannel('com.neconote.nekotomatatabi/share_inbox');
  final eventChannels = <String>[];
  var pending = <Map<String, dynamic>>[];
  var acknowledgements = 0;
  Map<String, dynamic> page(String id) => {
        'id': id,
        'prefecture': '愛知県',
        'title': id,
        'url': 'https://example.org/$id',
        'createdAt': '2026-10-21T00:00:00Z'
      };
  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    pending = [page('first')];
    acknowledgements = 0;
    for (final name in [
      'xyz.luan/audioplayers.global',
      'xyz.luan/audioplayers.global/events'
    ]) {
      binding.defaultBinaryMessenger
          .setMockMethodCallHandler(MethodChannel(name), (_) async => null);
    }
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('xyz.luan/audioplayers'), (call) async {
      if (call.method == 'create') {
        final id = (call.arguments as Map)['playerId'];
        final name = 'xyz.luan/audioplayers/events/$id';
        eventChannels.add(name);
        binding.defaultBinaryMessenger
            .setMockMethodCallHandler(MethodChannel(name), (_) async => null);
      }
      return null;
    });
    binding.defaultBinaryMessenger.setMockMethodCallHandler(inbox,
        (call) async {
      if (call.method == 'takePendingFavoriteSites') return List.of(pending);
      if (call.method == 'acknowledgeFavoriteSites') {
        acknowledgements++;
        final ids = (call.arguments as List).cast<String>();
        pending.removeWhere((row) => ids.contains(row['id']));
      }
      return null;
    });
  });
  tearDown(() async {
    await Future<void>.delayed(Duration.zero);
    debugDefaultTargetPlatformOverride = null;
    for (final name in [
      inbox.name,
      'xyz.luan/audioplayers.global',
      'xyz.luan/audioplayers.global/events',
      'xyz.luan/audioplayers',
      ...eventChannels
    ]) {
      binding.defaultBinaryMessenger
          .setMockMethodCallHandler(MethodChannel(name), null);
    }
    eventChannels.clear();
  });
  test(
      'acknowledges only after successful persistence and deduplicates re-delivery',
      () async {
    final storage = TestStorage()..gate = Completer<void>();
    final repository = AppRepository(storage);
    final import = repository.importSharedFavoriteSites();
    await storage.started.future;
    expect(acknowledgements, 0);
    storage.gate!.complete();
    expect(await import, 1);
    expect(storage.saved.single.title, 'first');
    expect(acknowledgements, 1);
    pending.add(page('first'));
    expect(await repository.importSharedFavoriteSites(), 0);
    expect(repository.favoriteSites.length, 1);
    repository.dispose();
  });
  test('failed persistence retains inbox and retry really writes data',
      () async {
    final storage = TestStorage()..fail = true;
    final repository = AppRepository(storage);
    expect(await repository.importSharedFavoriteSites(), 0);
    expect(pending.length, 1);
    expect(acknowledgements, 0);
    expect(repository.favoriteSites, isEmpty);
    storage.fail = false;
    expect(await repository.importSharedFavoriteSites(), 1);
    expect(storage.saved.single.id, 'first');
    expect(pending, isEmpty);
    repository.dispose();
  });
  test(
      'new share during an active import is drained without losing either page',
      () async {
    final storage = TestStorage()..gate = Completer<void>();
    final repository = AppRepository(storage);
    final first = repository.importSharedFavoriteSites();
    await storage.started.future;
    pending.add(page('second'));
    final second = repository.importSharedFavoriteSites();
    storage.gate!.complete();
    expect(await first, 2);
    expect(await second, 2);
    expect(storage.saved.map((site) => site.id).toSet(), {'first', 'second'});
    expect(pending, isEmpty);
    repository.dispose();
  });
}
