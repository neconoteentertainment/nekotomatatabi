import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/travel_memory.dart';
import '../models/travel_plan.dart';
import 'storage_service.dart';

class AppRepository extends ChangeNotifier {
  AppRepository(this._storage);

  final StorageService _storage;
  List<TravelMemory> _memories = [];
  List<String?> _stampPaths = List<String?>.filled(4, null);
  List<TravelPlan> _travelPlans = [];
  bool _ready = false;

  List<TravelMemory> get memories => List.unmodifiable(_memories);
  List<String?> get stampPaths => List.unmodifiable(_stampPaths);
  List<TravelPlan> get travelPlans => List.unmodifiable(_travelPlans);
  bool get ready => _ready;
  int get points => _memories.length;

  Future<void> initialize() async {
    _memories = await _storage.loadMemories();
    _stampPaths = await _storage.loadStampPaths();
    _travelPlans = await _storage.loadTravelPlans();
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

  Future<void> setStamp(int index, File source) async {
    final old = _stampPaths[index];
    final saved = await _storage.copyStampIntoApp(source, index);
    _stampPaths[index] = saved;
    await _storage.saveStampPaths(_stampPaths);
    if (old != null && old != saved) {
      try { await File(old).delete(); } catch (_) {}
    }
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
