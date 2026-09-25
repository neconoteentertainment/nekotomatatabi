import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/travel_memory.dart';
import '../models/travel_plan.dart';
import '../models/travel_expense.dart';

class StorageService {
  // 既存ユーザーのデータをアップデート後も引き継ぐため、キー名は変更しない。
  static const _memoriesKey = 'travel_memories_v1';
  static const _stampPathsKey = 'stamp_paths_v1';
  static const _travelPlansKey = 'travel_plans_v1';
  static const _travelExpensesKey = 'travel_expenses_v1';
  static const _bgmEnabledKey = 'bgm_enabled_v1';
  static const _bgmTrackKey = 'bgm_track_v1';

  String _portablePath(String path, String folderName) {
    final normalized = p.normalize(path);
    final parts = p.split(normalized);
    final index = parts.lastIndexOf(folderName);
    if (index >= 0 && index < parts.length - 1) {
      return p.joinAll(parts.sublist(index));
    }
    return path;
  }

  String _resolveStoredPath(String storedPath, String documentsPath) {
    if (storedPath.isEmpty) return storedPath;
    final direct = File(storedPath);
    if (direct.existsSync()) return direct.path;

    final normalized = p.normalize(storedPath);
    final parts = p.split(normalized);
    for (final folderName in const ['travel_photos', 'stamps']) {
      final index = parts.lastIndexOf(folderName);
      if (index >= 0) {
        return p.join(documentsPath, p.joinAll(parts.sublist(index)));
      }
    }

    if (!p.isAbsolute(storedPath)) {
      return p.join(documentsPath, storedPath);
    }
    return storedPath;
  }

  Future<List<TravelMemory>> loadMemories() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_memoriesKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final dir = await getApplicationDocumentsDirectory();
      final data = jsonDecode(raw) as List<dynamic>;
      final items = data.map((e) {
        final memory = TravelMemory.fromJson(Map<String, dynamic>.from(e as Map));
        return memory.copyWith(
          photoPaths: memory.photoPaths
              .map((path) => _resolveStoredPath(path, dir.path))
              .toList(growable: false),
        );
      }).toList();
      items.sort((a, b) => b.visitedAt.compareTo(a.visitedAt));
      return items;
    } catch (_) {
      return [];
    }
  }

  Future<void> saveMemories(List<TravelMemory> memories) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = memories.map((memory) {
      final json = memory.toJson();
      json['photoPaths'] = memory.photoPaths
          .map((path) => _portablePath(path, 'travel_photos'))
          .toList(growable: false);
      return json;
    }).toList(growable: false);
    await prefs.setString(_memoriesKey, jsonEncode(encoded));
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

  Future<List<TravelExpense>> loadTravelExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_travelExpensesKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final data = jsonDecode(raw) as List<dynamic>;
      final expenses = data
          .map((e) => TravelExpense.fromJson(Map<String, dynamic>.from(e as Map)))
          .where((e) => e.amount > 0)
          .toList();
      expenses.sort((a, b) => b.date.compareTo(a.date));
      return expenses;
    } catch (_) {
      return [];
    }
  }

  Future<void> saveTravelExpenses(List<TravelExpense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _travelExpensesKey,
      jsonEncode(expenses.map((e) => e.toJson()).toList()),
    );
  }

  Future<bool> loadBgmEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_bgmEnabledKey) ?? true;
  }

  Future<String> loadBgmTrack() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_bgmTrackKey) ?? 'umibe';
  }

  Future<void> saveBgmEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_bgmEnabledKey, enabled);
  }

  Future<void> saveBgmTrack(String track) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_bgmTrackKey, track);
  }

  Future<List<String?>> loadStampPaths() async {
    final prefs = await SharedPreferences.getInstance();
    final values = prefs.getStringList(_stampPathsKey) ?? const [];
    final dir = await getApplicationDocumentsDirectory();
    return List<String?>.generate(4, (i) {
      if (i >= values.length || values[i].isEmpty) return null;
      return _resolveStoredPath(values[i], dir.path);
    });
  }

  Future<void> saveStampPaths(List<String?> paths) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _stampPathsKey,
      paths
          .map((path) => path == null ? '' : _portablePath(path, 'stamps'))
          .toList(growable: false),
    );
  }

  Future<String> copyStampIntoApp(File source, int slot) async {
    final dir = await getApplicationDocumentsDirectory();
    final stampDir = Directory(p.join(dir.path, 'stamps'));
    await stampDir.create(recursive: true);
    final ext = p.extension(source.path).isEmpty ? '.png' : p.extension(source.path);
    // 差し替え時に同じパスを再利用すると Image.file のキャッシュで旧画像が
    // 表示されることがあるため、更新ごとに一意なファイル名で保存する。
    final target = File(
      p.join(
        stampDir.path,
        'stamp_${slot}_${DateTime.now().microsecondsSinceEpoch}$ext',
      ),
    );
    await source.copy(target.path);
    return target.path;
  }

  Future<String> persistPhoto(File source) async {
    final dir = await getApplicationDocumentsDirectory();
    final photoDir = Directory(p.join(dir.path, 'travel_photos'));
    await photoDir.create(recursive: true);
    final sourceExt = p.extension(source.path).toLowerCase();
    final ext = sourceExt.isEmpty ? '.jpg' : sourceExt;
    final filename = 'photo_${DateTime.now().microsecondsSinceEpoch}$ext';
    final target = File(p.join(photoDir.path, filename));
    await source.copy(target.path);
    return target.path;
  }
}
