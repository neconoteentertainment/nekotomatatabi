import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';

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
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '旅の思い出を振り返る',
      child: Column(
        children: [
          TabBar(
            controller: _tabs,
            tabs: const [Tab(text: '一覧'), Tab(text: '日本地図'), Tab(text: '年月')],
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: widget.repository,
              builder: (_, __) => TabBarView(
                controller: _tabs,
                children: [
                  _MemoryList(memories: widget.repository.memories),
                  _PrefectureMap(memories: widget.repository.memories),
                  _MonthMemories(memories: widget.repository.memories),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MemoryList extends StatelessWidget {
  const _MemoryList({required this.memories, this.emptyText = 'まだ旅の記録がありません。'});
  final List<TravelMemory> memories;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    if (memories.isEmpty) return Center(child: Text(emptyText));
    final sorted = [...memories]..sort((a, b) => b.visitedAt.compareTo(a.visitedAt));
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: sorted.length,
      itemBuilder: (context, i) => _MemoryCard(memory: sorted[i]),
    );
  }
}

class _MemoryCard extends StatelessWidget {
  const _MemoryCard({required this.memory});
  final TravelMemory memory;

  @override
  Widget build(BuildContext context) {
    final photos = memory.photoPaths.where((p) => File(p).existsSync()).toList();
    return Card(
      child: ExpansionTile(
        leading: photos.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(File(photos.first), width: 54, height: 54, fit: BoxFit.cover),
              )
            : const CircleAvatar(child: Icon(Icons.place)),
        title: Text(memory.placeName),
        subtitle: Text('${memory.prefecture} ・ ${_date(memory.visitedAt)}'),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        children: [
          if (memory.memo.isNotEmpty) ...[
            Align(alignment: Alignment.centerLeft, child: Text(memory.memo)),
            const SizedBox(height: 10),
          ],
          if (photos.isNotEmpty)
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: photos.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final path = photos[index];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => _PhotoViewer(paths: photos, initialIndex: index),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          Image.file(File(path), width: 150, height: 150, fit: BoxFit.cover),
                          const Positioned(
                            right: 6,
                            bottom: 6,
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Icon(Icons.fullscreen, color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
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
    for (final m in memories) {
      counts[m.prefecture] = (counts[m.prefecture] ?? 0) + 1;
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          '訪問済み都道府県を色付きで表示します。訪れた県をタップすると、その県で訪れた場所と写真を確認できます。',
          style: TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 2.2,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          children: prefectures.map((prefecture) {
            final count = counts[prefecture] ?? 0;
            final visited = count > 0;
            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: !visited
                  ? null
                  : () {
                      final filtered = memories.where((m) => m.prefecture == prefecture).toList();
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (context) => FractionallySizedBox(
                          heightFactor: .88,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 18, 12, 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '$prefectureの思い出',
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: _MemoryList(
                                  memories: filtered,
                                  emptyText: '$prefectureの記録はありません。',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
              child: Container(
                decoration: BoxDecoration(
                  color: visited
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  visited ? '$prefecture  $count' : prefecture,
                  style: TextStyle(fontWeight: visited ? FontWeight.bold : FontWeight.normal),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _MonthMemories extends StatefulWidget {
  const _MonthMemories({required this.memories});
  final List<TravelMemory> memories;

  @override
  State<_MonthMemories> createState() => _MonthMemoriesState();
}

class _MonthMemoriesState extends State<_MonthMemories> {
  int? _year;
  int? _month;

  void _ensureSelection() {
    if (widget.memories.isEmpty) return;
    final latest = ([...widget.memories]..sort((a, b) => b.visitedAt.compareTo(a.visitedAt))).first.visitedAt;
    _year ??= latest.year;
    _month ??= latest.month;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.memories.isEmpty) return const Center(child: Text('まだ旅の記録がありません。'));
    _ensureSelection();
    final years = widget.memories.map((e) => e.visitedAt.year).toSet().toList()..sort((a, b) => b.compareTo(a));
    final filtered = widget.memories.where((m) => m.visitedAt.year == _year && m.visitedAt.month == _month).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _year,
                  decoration: const InputDecoration(labelText: '年'),
                  items: years.map((y) => DropdownMenuItem(value: y, child: Text('$y年'))).toList(),
                  onChanged: (value) => setState(() => _year = value),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _month,
                  decoration: const InputDecoration(labelText: '月'),
                  items: List.generate(12, (i) => i + 1)
                      .map((m) => DropdownMenuItem(value: m, child: Text('$m月')))
                      .toList(),
                  onChanged: (value) => setState(() => _month = value),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _MemoryList(
            memories: filtered,
            emptyText: '${_year ?? ''}年${_month ?? ''}月の記録はありません。',
          ),
        ),
      ],
    );
  }
}

class _PhotoViewer extends StatefulWidget {
  const _PhotoViewer({required this.paths, required this.initialIndex});
  final List<String> paths;
  final int initialIndex;

  @override
  State<_PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<_PhotoViewer> {
  late final PageController _controller = PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveCurrent() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final bytes = await File(widget.paths[_index]).readAsBytes();
      await Gal.putImageBytes(
        bytes,
        name: 'nekotomatatabi_${DateTime.now().millisecondsSinceEpoch}',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('写真を保存しました。')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('写真を保存できませんでした: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${_index + 1} / ${widget.paths.length}'),
        actions: [
          IconButton(
            tooltip: '写真を保存',
            onPressed: _saving ? null : _saveCurrent,
            icon: _saving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.download_outlined),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.paths.length,
        onPageChanged: (value) => setState(() => _index = value),
        itemBuilder: (context, index) {
          return Center(
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 5,
              child: Image.file(File(widget.paths[index]), fit: BoxFit.contain),
            ),
          );
        },
      ),
    );
  }
}

String _date(DateTime d) => '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';
