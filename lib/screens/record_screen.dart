import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/travel_memory.dart';
import '../services/app_repository.dart';
import '../services/location_service.dart';
import '../widgets/app_scaffold.dart';
import 'camera_screen.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key, required this.repository});
  final AppRepository repository;
  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final _locationService = LocationService();
  Position? _position;
  List<NearbyPlace> _places = [];
  bool _loading = false;
  String? _error;
  String? _selectedMemoryId;

  Future<void> _loadPlaces() async {
    setState(() { _loading = true; _error = null; });
    try {
      final pos = await _locationService.getCurrentPosition();
      final places = await _locationService.findNearbyPlaces(pos.latitude, pos.longitude);
      if (!mounted) return;
      setState(() { _position = pos; _places = places; });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _record(NearbyPlace place) async {
    final memoController = TextEditingController();
    final ok = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: Text('${place.name} を記録'),
      content: TextField(controller: memoController, maxLines: 3, decoration: const InputDecoration(labelText: '一言メモ・感想（任意）', border: OutlineInputBorder())),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('キャンセル')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('記録する')),
      ],
    ));
    if (ok != true) return;
    final prefecture = await _locationService.reversePrefecture(place.latitude, place.longitude);
    final memory = TravelMemory(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      placeName: place.name,
      latitude: place.latitude,
      longitude: place.longitude,
      prefecture: prefecture,
      visitedAt: DateTime.now(),
      memo: memoController.text.trim(),
      photoPaths: const [],
    );
    await widget.repository.addMemory(memory);
    if (!mounted) return;
    setState(() => _selectedMemoryId = memory.id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${place.name} を記録しました（+1P）')));
  }

  Future<void> _manualRecord() async {
    if (_position == null) return;
    final name = TextEditingController();
    final memo = TextEditingController();
    final ok = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: const Text('場所を手入力'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: name, decoration: const InputDecoration(labelText: '場所・施設名')),
        const SizedBox(height: 12),
        TextField(controller: memo, maxLines: 2, decoration: const InputDecoration(labelText: '一言メモ・感想')),
      ]),
      actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('キャンセル')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('記録'))],
    ));
    if (ok != true || name.text.trim().isEmpty) return;
    final prefecture = await _locationService.reversePrefecture(_position!.latitude, _position!.longitude);
    final memory = TravelMemory(id: DateTime.now().microsecondsSinceEpoch.toString(), placeName: name.text.trim(), latitude: _position!.latitude, longitude: _position!.longitude, prefecture: prefecture, visitedAt: DateTime.now(), memo: memo.text.trim(), photoPaths: const []);
    await widget.repository.addMemory(memory);
    if (mounted) setState(() => _selectedMemoryId = memory.id);
  }

  Future<void> _openCamera() async {
    final memories = widget.repository.memories;
    if (memories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('先に観光地を1件記録してください。写真は記録した場所に紐づきます。')));
      return;
    }
    _selectedMemoryId ??= memories.first.id;
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => CameraScreen(repository: widget.repository, memoryId: _selectedMemoryId!)));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '旅の思い出を記録する',
      child: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('① 観光地を記録する', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          FilledButton.icon(onPressed: _loading ? null : _loadPlaces, icon: const Icon(Icons.my_location), label: Text(_position == null ? '現在地から周辺を探す' : '周辺候補を更新')),
          if (_loading) const Padding(padding: EdgeInsets.all(12), child: Center(child: CircularProgressIndicator())),
          if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
          if (_position != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text('現在地: ${_position!.latitude.toStringAsFixed(5)}, ${_position!.longitude.toStringAsFixed(5)}')),
          if (_position != null) TextButton.icon(onPressed: _manualRecord, icon: const Icon(Icons.edit_location_alt), label: const Text('候補にない場所を手入力')),
        ]))),
        if (_places.isNotEmpty) ...[
          const SizedBox(height: 10),
          const Text('周辺の候補', style: TextStyle(fontWeight: FontWeight.bold)),
          ..._places.map((p) => Card(child: ListTile(
            leading: const Icon(Icons.place_outlined),
            title: Text(p.name),
            subtitle: Text('${p.category} ・ ${_position == null ? '' : '${(Geolocator.distanceBetween(_position!.latitude, _position!.longitude, p.latitude, p.longitude) / 1000).toStringAsFixed(1)}km'}'),
            trailing: FilledButton.tonal(onPressed: () => _record(p), child: const Text('記録')),
          ))),
        ],
        const SizedBox(height: 16),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('② 写真を撮る', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('自作スタンプまたは文字スタンプをカメラ上に表示して撮影します。写真は選択した訪問記録に保存されます。'),
          const SizedBox(height: 12),
          if (widget.repository.memories.isNotEmpty)
            DropdownButtonFormField<String>(
              value: _selectedMemoryId ?? widget.repository.memories.first.id,
              decoration: const InputDecoration(labelText: '写真を紐づける場所', border: OutlineInputBorder()),
              items: widget.repository.memories.take(20).map((m) => DropdownMenuItem(value: m.id, child: Text(m.placeName, overflow: TextOverflow.ellipsis))).toList(),
              onChanged: (v) => setState(() => _selectedMemoryId = v),
            ),
          const SizedBox(height: 12),
          FilledButton.icon(onPressed: _openCamera, icon: const Icon(Icons.camera_alt), label: const Text('写真を撮る')),
        ]))),
      ]),
    );
  }
}
