import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/local_item.dart';
import '../models/travel_memory.dart';
import '../models/travel_plan.dart';
import '../models/travel_expense.dart';
import 'audio_service.dart';
import 'storage_service.dart';

class AppRepository extends ChangeNotifier {
  AppRepository(this._storage) : _audio = AppAudioService();

  final StorageService _storage;
  final AppAudioService _audio;
  List<TravelMemory> _memories = [];
  List<String?> _stampPaths = List<String?>.filled(4, null);
  List<TravelPlan> _travelPlans = [];
  List<TravelExpense> _travelExpenses = [];
  bool _ready = false;
  bool _bgmEnabled = true;
  String _bgmTrack = 'umibe';

  static const _testBasePoints = 30;

  List<TravelMemory> get memories => List.unmodifiable(_memories);
  List<String?> get stampPaths => List.unmodifiable(_stampPaths);
  List<TravelPlan> get travelPlans => List.unmodifiable(_travelPlans);
  List<TravelExpense> get travelExpenses => List.unmodifiable(_travelExpenses);
  bool get ready => _ready;
  bool get bgmEnabled => _bgmEnabled;
  String get bgmTrack => _bgmTrack;

  int get uniqueVisitCount => _uniqueMemories(_memories).length;

  TravelMemory? memoryById(String id) {
    for (final memory in _memories) {
      if (memory.id == id) return memory;
    }
    return null;
  }

  int pointsForPrefecture(String prefecture) {
    final count = _uniqueMemories(
      _memories.where((m) => m.prefecture == prefecture),
    ).length;
    // 画像確認用ビルドでは、実装済みの全都道府県を30Pから開始する。
    // リリース時はこのテスト加算を0へ戻す。
    final testBonus =
        localItemPrefectures.contains(prefecture) ? _testBasePoints : 0;
    return testBonus + count;
  }

  bool isLocalItemUnlocked(LocalItem item) =>
      pointsForPrefecture(item.prefecture) >= item.threshold;

  List<LocalItem> unlockedLocalItems({String? prefecture}) => localItems
      .where((item) =>
          (prefecture == null || item.prefecture == prefecture) &&
          isLocalItemUnlocked(item))
      .toList(growable: false);

  Iterable<TravelMemory> _uniqueMemories(Iterable<TravelMemory> source) sync* {
    final seen = <String>{};
    for (final memory in source) {
      final name = memory.placeName.trim().replaceAll(RegExp(r'\s+'), '');
      final key = '${memory.prefecture}|$name';
      if (seen.add(key)) yield memory;
    }
  }

  Future<void> initialize() async {
    _memories = await _storage.loadMemories();
    _stampPaths = await _storage.loadStampPaths();
    _travelPlans = await _storage.loadTravelPlans();
    _travelExpenses = await _storage.loadTravelExpenses();
    _bgmEnabled = await _storage.loadBgmEnabled();
    _bgmTrack = await _storage.loadBgmTrack();
    await _audio.configure(
      enabled: _bgmEnabled,
      asset: _bgmAsset(_bgmTrack),
    );
    _ready = true;
    notifyListeners();
  }

  String _bgmAsset(String track) => switch (track) {
        'odayaka' => 'bgm/odayakana_asa.mp3',
        _ => 'bgm/umibe_no_asa.mp3',
      };

  Future<void> setBgmEnabled(bool enabled) async {
    _bgmEnabled = enabled;
    await _storage.saveBgmEnabled(enabled);
    await _audio.setEnabled(enabled);
    notifyListeners();
  }

  Future<void> setBgmTrack(String track) async {
    if (track != 'umibe' && track != 'odayaka') return;
    _bgmTrack = track;
    await _storage.saveBgmTrack(track);
    await _audio.setTrack(_bgmAsset(track));
    notifyListeners();
  }

  Future<void> setAppActive(bool active) => _audio.setAppActive(active);

  Future<void> addMemory(TravelMemory memory) async {
    _memories = [memory, ..._memories];
    await _storage.saveMemories(_memories);
    notifyListeners();
  }

  Future<void> addPhotoToMemory(String memoryId, String path) async {
    _memories = _memories.map((m) {
      if (m.id != memoryId) return m;
      return m.copyWith(photoPaths: [...m.photoPaths, path]);
    }).toList();
    await _storage.saveMemories(_memories);
    notifyListeners();
  }

  Future<void> importPhotoToMemory(String memoryId, File source) async {
    final saved = await _storage.persistPhoto(source);
    await addPhotoToMemory(memoryId, saved);
  }


  Future<void> deletePhotoFromMemory(String memoryId, String path) async {
    _memories = _memories.map((m) {
      if (m.id != memoryId) return m;
      return m.copyWith(photoPaths: m.photoPaths.where((p) => p != path).toList());
    }).toList();
    await _storage.saveMemories(_memories);
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } catch (_) {}
    notifyListeners();
  }

  Future<void> deleteMemory(String memoryId) async {
    final target = _memories.where((e) => e.id == memoryId).toList();
    _memories = _memories.where((e) => e.id != memoryId).toList();
    await _storage.saveMemories(_memories);
    for (final memory in target) {
      for (final path in memory.photoPaths) {
        try {
          final file = File(path);
          if (await file.exists()) await file.delete();
        } catch (_) {}
      }
    }
    notifyListeners();
  }

  Future<void> saveTravelPlan(TravelPlan plan) async {
    final index = _travelPlans.indexWhere((e) => e.id == plan.id);
    if (index >= 0) {
      _travelPlans[index] = plan;
    } else {
      _travelPlans.add(plan);
    }
    _travelPlans.sort((a, b) => a.date.compareTo(b.date));
    await _storage.saveTravelPlans(_travelPlans);
    notifyListeners();
  }

  Future<void> deleteTravelPlan(String planId) async {
    _travelPlans.removeWhere((e) => e.id == planId);
    await _storage.saveTravelPlans(_travelPlans);
    notifyListeners();
  }

  Future<void> saveTravelExpense(TravelExpense expense) async {
    final index = _travelExpenses.indexWhere((e) => e.id == expense.id);
    if (index >= 0) {
      _travelExpenses[index] = expense;
    } else {
      _travelExpenses.add(expense);
    }
    _travelExpenses.sort((a, b) => b.date.compareTo(a.date));
    await _storage.saveTravelExpenses(_travelExpenses);
    notifyListeners();
  }

  Future<void> deleteTravelExpense(String expenseId) async {
    _travelExpenses.removeWhere((e) => e.id == expenseId);
    await _storage.saveTravelExpenses(_travelExpenses);
    notifyListeners();
  }

  Future<void> setStamp(int index, File source) async {
    final old = _stampPaths[index];
    final saved = await _storage.copyStampIntoApp(source, index);
    _stampPaths[index] = saved;
    await _storage.saveStampPaths(_stampPaths);
    if (old != null && old != saved) {
      try {
        await File(old).delete();
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<void> clearStamp(int index) async {
    final old = _stampPaths[index];
    _stampPaths[index] = null;
    await _storage.saveStampPaths(_stampPaths);
    if (old != null) {
      try {
        await File(old).delete();
      } catch (_) {}
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }
}
