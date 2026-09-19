import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';

import '../models/travel_memory.dart';
import '../services/app_repository.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, required this.repository});
  final AppRepository repository;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  static const _gold = Color(0xFFE6C28D);
  static const _background = Color(0xFF171412);
  static const _panel = Color(0xE625211E);

  late final TabController _tabs = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _background,
        body: Stack(
          fit: StackFit.expand,
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF201B18), Color(0xFF171412)],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 16, 8),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
                        ),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '旅の思い出を振り返る',
                                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'MEMORIES OF JOURNEYS',
                                style: TextStyle(color: _gold, fontSize: 9, letterSpacing: 2.1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xC4211B18),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: _gold.withOpacity(.72)),
                      ),
                      child: TabBar(
                        controller: _tabs,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: _gold.withOpacity(.18),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: _gold.withOpacity(.7)),
                        ),
                        dividerColor: Colors.transparent,
                        labelColor: _gold,
                        unselectedLabelColor: Colors.white70,
                        labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                        tabs: const [
                          Tab(icon: Icon(Icons.photo_album_outlined, size: 19), text: '一覧'),
                          Tab(icon: Icon(Icons.map_outlined, size: 19), text: '日本地図'),
                          Tab(icon: Icon(Icons.calendar_month_outlined, size: 19), text: '年月'),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: widget.repository,
                      builder: (_, __) => TabBarView(
                        controller: _tabs,
                        children: [
                          _MemoryList(repository: widget.repository, memories: widget.repository.memories),
                          _PrefectureMap(repository: widget.repository, memories: widget.repository.memories),
                          _MonthMemories(repository: widget.repository, memories: widget.repository.memories),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemoryList extends StatelessWidget {
  const _MemoryList({required this.repository, required this.memories, this.emptyText = 'まだ旅の記録がありません。'});
  final AppRepository repository;
  final List<TravelMemory> memories;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    if (memories.isEmpty) {
      return _EmptyMemory(message: emptyText);
    }
    final sorted = [...memories]..sort((a, b) => b.visitedAt.compareTo(a.visitedAt));
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 24),
      itemCount: sorted.length,
      itemBuilder: (context, i) => _MemoryCard(repository: repository, memory: sorted[i]),
    );
  }
}

class _MemoryCard extends StatelessWidget {
  const _MemoryCard({required this.repository, required this.memory});
  final AppRepository repository;
  final TravelMemory memory;

  Future<bool> _confirm(BuildContext context, String title, String message) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('キャンセル')),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('削除'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _deleteMemory(BuildContext context) async {
    final ok = await _confirm(
      context,
      '訪問場所を削除しますか？',
      '「${memory.placeName}」の記録と、この場所に保存されている写真を削除します。',
    );
    if (!ok) return;
    await repository.deleteMemory(memory.id);
  }

  Future<void> _deletePhoto(BuildContext context, String path) async {
    final ok = await _confirm(context, '写真を削除しますか？', 'この写真だけを旅の記録から削除します。');
    if (!ok) return;
    await repository.deletePhotoFromMemory(memory.id, path);
  }

  @override
  Widget build(BuildContext context) {
    final photos = memory.photoPaths.where((p) => File(p).existsSync()).toList();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xE628211D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6C28D).withOpacity(.48)),
        boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 12, offset: Offset(0, 6))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: const Color(0xFFE6C28D),
          collapsedIconColor: Colors.white70,
          tilePadding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
          leading: photos.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(File(photos.first), width: 56, height: 56, fit: BoxFit.cover),
                )
              : Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B3029),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE6C28D).withOpacity(.45)),
                  ),
                  child: const Icon(Icons.place_outlined, color: Color(0xFFE6C28D)),
                ),
          title: Text(memory.placeName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          subtitle: Text(
            '${memory.prefecture} ・ ${_date(memory.visitedAt)}',
            style: const TextStyle(color: Colors.white70),
          ),
          trailing: IconButton(
            tooltip: 'この場所を削除',
            onPressed: () => _deleteMemory(context),
            icon: const Icon(Icons.delete_outline, color: Color(0xFFE6C28D)),
          ),
          children: [
            if (memory.memo.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(memory.memo, style: const TextStyle(color: Colors.white70)),
              ),
              const SizedBox(height: 10),
            ],
            if (photos.isEmpty)
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('写真はまだありません。', style: TextStyle(color: Colors.white54)),
              ),
            if (photos.isNotEmpty)
              SizedBox(
                height: 154,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: photos.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final path = photos[index];
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => _PhotoViewer(paths: photos, initialIndex: index),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(File(path), width: 150, height: 150, fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Material(
                            color: Colors.black54,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () => _deletePhoto(context, path),
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: Icon(Icons.delete_outline, color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                        ),
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
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PrefectureMap extends StatelessWidget {
  const _PrefectureMap({required this.repository, required this.memories});
  final AppRepository repository;
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
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 24),
      children: [
        _TravelHeader(
          icon: Icons.map_outlined,
          title: '日本を旅した足あと',
          subtitle: '訪れた都道府県が金色に灯ります。タップすると、その土地の写真と思い出を開けます。',
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 2.1,
          mainAxisSpacing: 7,
          crossAxisSpacing: 7,
          children: prefectures.map((prefecture) {
            final count = counts[prefecture] ?? 0;
            final visited = count > 0;
            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: !visited
                  ? null
                  : () {
                      final filtered = memories.where((m) => m.prefecture == prefecture).toList();
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        backgroundColor: const Color(0xFF171412),
                        builder: (context) => FractionallySizedBox(
                          heightFactor: .9,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 16, 10, 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '$prefectureの思い出',
                                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: const Icon(Icons.close, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: _MemoryList(
                                  repository: repository,
                                  memories: filtered,
                                  emptyText: '$prefectureの記録はありません。',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  color: visited ? const Color(0xFF5A432E) : const Color(0xB92B2521),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: visited ? const Color(0xFFE6C28D) : Colors.white12,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  visited ? '$prefecture  $count' : prefecture,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: visited ? const Color(0xFFFFE4B8) : Colors.white54,
                    fontWeight: visited ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
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
  const _MonthMemories({required this.repository, required this.memories});
  final AppRepository repository;
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
    if (widget.memories.isEmpty) return const _EmptyMemory(message: 'まだ旅の記録がありません。');
    _ensureSelection();
    final years = widget.memories.map((e) => e.visitedAt.year).toSet().toList()..sort((a, b) => b.compareTo(a));
    final filtered = widget.memories.where((m) => m.visitedAt.year == _year && m.visitedAt.month == _month).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 4, 14, 8),
          child: Column(
            children: [
              const _TravelHeader(
                icon: Icons.calendar_month_outlined,
                title: '季節をめくるように',
                subtitle: '年月を選んで、その頃の旅をまとめて振り返れます。',
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _DarkDropdown<int>(
                      value: _year,
                      label: '年',
                      items: years.map((y) => DropdownMenuItem(value: y, child: Text('$y年'))).toList(),
                      onChanged: (value) => setState(() => _year = value),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _DarkDropdown<int>(
                      value: _month,
                      label: '月',
                      items: List.generate(12, (i) => i + 1)
                          .map((m) => DropdownMenuItem(value: m, child: Text('$m月')))
                          .toList(),
                      onChanged: (value) => setState(() => _month = value),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: _MemoryList(
            repository: widget.repository,
            memories: filtered,
            emptyText: '${_year ?? ''}年${_month ?? ''}月の記録はありません。',
          ),
        ),
      ],
    );
  }
}

class _DarkDropdown<T> extends StatelessWidget {
  const _DarkDropdown({required this.value, required this.label, required this.items, required this.onChanged});
  final T? value;
  final String label;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      dropdownColor: const Color(0xFF2A231F),
      style: const TextStyle(color: Colors.white),
      iconEnabledColor: const Color(0xFFE6C28D),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xCC28211D),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0x88E6C28D)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE6C28D)),
        ),
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}

class _TravelHeader extends StatelessWidget {
  const _TravelHeader({required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xD925201D),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x66E6C28D)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF40342B),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE6C28D)),
            ),
            child: Icon(icon, color: const Color(0xFFE6C28D)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 3),
                Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyMemory extends StatelessWidget {
  const _EmptyMemory({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xC925201D),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0x66E6C28D)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.luggage_outlined, color: Color(0xFFE6C28D), size: 40),
            const SizedBox(height: 10),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
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
      await Gal.putImageBytes(bytes, name: 'nekotomatatabi_${DateTime.now().millisecondsSinceEpoch}');
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
          return InteractiveViewer(
            minScale: 1,
            maxScale: 5,
            child: Center(child: Image.file(File(widget.paths[index]), fit: BoxFit.contain)),
          );
        },
      ),
    );
  }
}

String _date(DateTime d) => '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';
