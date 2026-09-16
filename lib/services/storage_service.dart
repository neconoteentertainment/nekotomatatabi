import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/travel_memory.dart';
import '../models/travel_plan.dart';

class StorageService {
  static const _memoriesKey = 'travel_memories_v1';
  static const _stampPathsKey = 'stamp_paths_v1';
  static const _travelPlansKey = 'travel_plans_v1';

  Future<List<TravelMemory>> loadMemories() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_memoriesKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final data = jsonDecode(raw) as List<dynamic>;
      final items = data
          .map((e) => TravelMemory.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      items.sort((a, b) => b.visitedAt.compareTo(a.visitedAt));
      return items;
    } catch (_) {
      return [];
    }
  }

  Future<void> saveMemories(List<TravelMemory> memories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _memoriesKey,
      jsonEncode(memories.map((e) => e.toJson()).toList()),
    );
  }


  Future<List<TravelPlan>> loadTravelPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_travelPlansKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final data = jsonDecode(raw) as List<dynamic>;
      final plans = data
          .map((e) => TravelPlan.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      plans.sort((a, b) => a.date.compareTo(b.date));
      return plans;
    } catch (_) {
      return [];
    }
  }

  Future<void> saveTravelPlans(List<TravelPlan> plans) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _travelPlansKey,
      jsonEncode(plans.map((e) => e.toJson()).toList()),
    );
  }

  Future<List<String?>> loadStampPaths() async {
    final prefs = await SharedPreferences.getInstance();
    final values = prefs.getStringList(_stampPathsKey) ?? const [];
    return List<String?>.generate(4, (i) => i < values.length && values[i].isNotEmpty ? values[i] : null);
  }

  Future<void> saveStampPaths(List<String?> paths) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_stampPathsKey, paths.map((e) => e ?? '').toList());
  }

  Future<String> copyStampIntoApp(File source, int slot) async {
    final dir = await getApplicationDocumentsDirectory();
    final stampDir = Directory(p.join(dir.path, 'stamps'));
    await stampDir.create(recursive: true);
    final ext = p.extension(source.path).isEmpty ? '.png' : p.extension(source.path);
    // 差し替え時に同じパスを再利用すると Image.file のキャッシュで旧画像が
    // 表示されることがあるため、更新ごとに一意なファイル名で保存する。
    final target = File(p.join(stampDir.path, 'stamp_${slot}_${DateTime.now().microsecondsSinceEpoch}$ext'));
    await source.copy(target.path);
    return target.path;
  }

  Future<String> persistPhoto(File source) async {
    final dir = await getApplicationDocumentsDirectory();
    final photoDir = Directory(p.join(dir.path, 'travel_photos'));
    await photoDir.create(recursive: true);
    final filename = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final target = File(p.join(photoDir.path, filename));
    await source.copy(target.path);
    return target.path;
  }
}
