import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/travel_memory.dart';
import '../services/app_repository.dart';
import '../widgets/app_scaffold.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, required this.repository});
  final AppRepository repository;
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this);
  @override
  void dispose() { _tabs.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '過去の思い出を振り返る',
      child: Column(children: [
        TabBar(controller: _tabs, tabs: const [Tab(text: '一覧'), Tab(text: '日本地図'), Tab(text: 'ピン地図')]),
        Expanded(child: AnimatedBuilder(animation: widget.repository, builder: (_, __) => TabBarView(controller: _tabs, children: [
          _MemoryList(memories: widget.repository.memories),
          _PrefectureMap(memories: widget.repository.memories),
          _PinMap(memories: widget.repository.memories),
        ]))),
      ]),
    );
  }
}

class _MemoryList extends StatelessWidget {
  const _MemoryList({required this.memories});
  final List<TravelMemory> memories;
  @override
  Widget build(BuildContext context) {
    if (memories.isEmpty) return const Center(child: Text('まだ旅の記録がありません。'));
    return ListView.builder(padding: const EdgeInsets.all(12), itemCount: memories.length, itemBuilder: (context, i) {
      final m = memories[i];
      return Card(child: ExpansionTile(
        leading: m.photoPaths.isNotEmpty && File(m.photoPaths.first).existsSync() ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(m.photoPaths.first), width: 54, height: 54, fit: BoxFit.cover)) : const CircleAvatar(child: Icon(Icons.place)),
        title: Text(m.placeName),
        subtitle: Text('${m.prefecture} ・ ${_date(m.visitedAt)}'),
        childrenPadding: const EdgeInsets.all(12),
        children: [
          if (m.memo.isNotEmpty) Align(alignment: Alignment.centerLeft, child: Text(m.memo)),
          if (m.photoPaths.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(height: 150, child: ListView(scrollDirection: Axis.horizontal, children: m.photoPaths.where((p) => File(p).existsSync()).map((p) => Padding(padding: const EdgeInsets.only(right: 8), child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(File(p), width: 150, height: 150, fit: BoxFit.cover)))).toList())),
          ],
        ],
      ));
    });
  }
  static String _date(DateTime d) => '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';
}

class _PrefectureMap extends StatelessWidget {
  const _PrefectureMap({required this.memories});
  final List<TravelMemory> memories;
  static const prefectures = [
    '北海道','青森県','岩手県','宮城県','秋田県','山形県','福島県','茨城県','栃木県','群馬県','埼玉県','千葉県','東京都','神奈川県','新潟県','富山県','石川県','福井県','山梨県','長野県','岐阜県','静岡県','愛知県','三重県','滋賀県','京都府','大阪府','兵庫県','奈良県','和歌山県','鳥取県','島根県','岡山県','広島県','山口県','徳島県','香川県','愛媛県','高知県','福岡県','佐賀県','長崎県','熊本県','大分県','宮崎県','鹿児島県','沖縄県'
  ];
  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{};
    for (final m in memories) { counts[m.prefecture] = (counts[m.prefecture] ?? 0) + 1; }
    return ListView(padding: const EdgeInsets.all(16), children: [
      const Text('訪問済み都道府県を色付きで表示します。初版では見やすさを優先した「47都道府県マップ」です。', style: TextStyle(fontSize: 13)),
      const SizedBox(height: 12),
      GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 3, childAspectRatio: 2.2, mainAxisSpacing: 6, crossAxisSpacing: 6, children: prefectures.map((p) {
        final count = counts[p] ?? 0;
        return Container(decoration: BoxDecoration(color: count > 0 ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(10)), alignment: Alignment.center, child: Text(count > 0 ? '$p  $count' : p, style: TextStyle(fontWeight: count > 0 ? FontWeight.bold : FontWeight.normal)));
      }).toList()),
    ]);
  }
}

class _PinMap extends StatelessWidget {
  const _PinMap({required this.memories});
  final List<TravelMemory> memories;
  @override
  Widget build(BuildContext context) {
    if (memories.isEmpty) return const Center(child: Text('訪問場所を記録すると地図にピンが表示されます。'));
    final center = LatLng(memories.first.latitude, memories.first.longitude);
    return FlutterMap(
      options: MapOptions(initialCenter: center, initialZoom: 6),
      children: [
        TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.neconote.nekotomatatabi'),
        MarkerLayer(markers: memories.map((m) => Marker(point: LatLng(m.latitude, m.longitude), width: 44, height: 44, child: Tooltip(message: m.placeName, child: const Icon(Icons.location_pin, size: 42, color: Colors.red)))).toList()),
        const RichAttributionWidget(attributions: [TextSourceAttribution('OpenStreetMap contributors')]),
      ],
    );
  }
}
