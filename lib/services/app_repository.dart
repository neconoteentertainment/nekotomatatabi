import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/travel_memory.dart';
import 'storage_service.dart';

class AppRepository extends ChangeNotifier {
  AppRepository(this._storage);

  final StorageService _storage;
  List<TravelMemory> _memories = [];
  List<String?> _stampPaths = List<String?>.filled(4, null);
  bool _ready = false;

  List<TravelMemory> get memories => List.unmodifiable(_memories);
  List<String?> get stampPaths => List.unmodifiable(_stampPaths);
  bool get ready => _ready;
  int get points => _memories.length;

  Future<void> initialize() async {
    _memories = await _storage.loadMemories();
    _stampPaths = await _storage.loadStampPaths();
    _ready = true;
    notifyListeners();
  }

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

  Future<void> deleteMemory(String memoryId) async {
    _memories = _memories.where((e) => e.id != memoryId).toList();
    await _storage.saveMemories(_memories);
    notifyListeners();
  }

  Future<void> setStamp(int index, File source) async {
    final saved = await _storage.copyStampIntoApp(source, index);
    _stampPaths[index] = saved;
    await _storage.saveStampPaths(_stampPaths);
    notifyListeners();
  }

  Future<void> clearStamp(int index) async {
    final old = _stampPaths[index];
    _stampPaths[index] = null;
    await _storage.saveStampPaths(_stampPaths);
    if (old != null) {
      try { await File(old).delete(); } catch (_) {}
    }
    notifyListeners();
  }
}
