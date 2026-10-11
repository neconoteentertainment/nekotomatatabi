import 'package:flutter_test/flutter_test.dart';
import 'package:nekotomatatabi/models/travel_memory.dart';
import 'package:nekotomatatabi/services/app_repository.dart';
import 'package:nekotomatatabi/services/storage_service.dart';

class _MemoryStorage extends StorageService {
  @override
  Future<void> saveMemories(List<TravelMemory> memories) async {}
}

TravelMemory _memory({
  required String id,
  required String placeName,
  required String prefecture,
}) =>
    TravelMemory(
      id: id,
      placeName: placeName,
      latitude: 0,
      longitude: 0,
      prefecture: prefecture,
      visitedAt: DateTime(2026, 10, 11),
      memo: '',
      photoPaths: const [],
    );

void main() {
  test('名産品ポイントは県ごとの重複しない訪問地数で計算する', () async {
    final repository = AppRepository(_MemoryStorage());

    expect(repository.pointsForPrefecture('東京都'), 0);

    await repository.addMemory(
      _memory(id: '1', placeName: '東京タワー', prefecture: '東京都'),
    );
    await repository.addMemory(
      _memory(id: '2', placeName: '東京 タワー', prefecture: '東京都'),
    );
    await repository.addMemory(
      _memory(id: '3', placeName: '浅草寺', prefecture: '東京都'),
    );
    await repository.addMemory(
      _memory(id: '4', placeName: '浅草寺', prefecture: '埼玉県'),
    );

    expect(repository.pointsForPrefecture('東京都'), 2);
    expect(repository.pointsForPrefecture('埼玉県'), 1);
  });
}
