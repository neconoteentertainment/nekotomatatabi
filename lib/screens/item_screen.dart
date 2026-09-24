import 'package:flutter/material.dart';

import '../models/local_item.dart';
import '../services/app_repository.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/washi_surface.dart';

class ItemScreen extends StatelessWidget {
  const ItemScreen({super.key, required this.repository});

  final AppRepository repository;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '名産品集め',
      child: AnimatedBuilder(
        animation: repository,
        builder: (_, __) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              '地域を選択',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              '訪れた観光地は県ごとに1か所=1P。\n同じ観光地を複数回訪れても重複して加算しません。',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            for (final region in localItemRegions) ...[
              WashiCard(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppScaffold.gold.withValues(alpha: .12),
                    child: const Icon(Icons.landscape_outlined, color: AppScaffold.gold),
                  ),
                  title: Text(region),
                  subtitle: Text(prefecturesForRegion(region).join('・')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => _PrefectureScreen(
                        repository: repository,
                        region: region,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 8),
            const WashiCard(
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.lock_outline)),
                title: Text('その他の地域'),
                subtitle: Text('名産スタンプは今後追加予定です。'),
                enabled: false,
              ),
            ),
            const SizedBox(height: 16),
            const WashiSurface(
              padding: EdgeInsets.all(12),
              borderRadius: 14,
              child: Text(
                '※動作確認用として、現在は東海4県のみ各30Pから開始しています。リリース時は0P開始に変更します。',
                style: TextStyle(color: WashiSurface.mutedInk, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrefectureScreen extends StatelessWidget {
  const _PrefectureScreen({required this.repository, required this.region});
  final AppRepository repository;
  final String region;

  @override
  Widget build(BuildContext context) {
    final prefectures = prefecturesForRegion(region);
    return AppScaffold(
      title: region,
      child: AnimatedBuilder(
        animation: repository,
        builder: (_, __) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: prefectures.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final prefecture = prefectures[index];
            final points = repository.pointsForPrefecture(prefecture);
            return WashiCard(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppScaffold.gold.withValues(alpha: .12),
                  child: const Icon(Icons.pets, color: AppScaffold.gold),
                ),
                title: Text(prefecture, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('$points P'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => _LocalItemListScreen(
                      repository: repository,
                      prefecture: prefecture,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LocalItemListScreen extends StatelessWidget {
  const _LocalItemListScreen({required this.repository, required this.prefecture});

  final AppRepository repository;
  final String prefecture;

  @override
  Widget build(BuildContext context) {
    final items = localItems.where((e) => e.prefecture == prefecture).toList();
    return AppScaffold(
      title: prefecture,
      child: AnimatedBuilder(
        animation: repository,
        builder: (_, __) {
          final points = repository.pointsForPrefecture(prefecture);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              WashiCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.pets, color: AppScaffold.gold),
                      const SizedBox(width: 10),
                      Text('$prefecture の旅ポイント'),
                      const Spacer(),
                      Text(
                        '$points P',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppScaffold.gold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...items.map((item) {
                final unlocked = repository.isLocalItemUnlocked(item);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: WashiCard(
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 92,
                            height: 92,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  item.assetPath,
                                  fit: BoxFit.contain,
                                  color: unlocked ? null : Colors.black54,
                                  colorBlendMode: unlocked ? null : BlendMode.srcATop,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.image_not_supported_outlined,
                                    color: WashiSurface.mutedInk,
                                    size: 34,
                                  ),
                                ),
                                if (!unlocked)
                                  const Center(
                                    child: Icon(Icons.lock, color: Colors.white70, size: 34),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.name,
                                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      '${item.threshold}P',
                                      style: const TextStyle(color: AppScaffold.gold, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(item.description, style: const TextStyle(color: WashiSurface.mutedInk, height: 1.4)),
                                const SizedBox(height: 8),
                                Text(
                                  unlocked ? '入手済み・カメラで使用できます' : 'あと${item.threshold - points}P',
                                  style: TextStyle(
                                    color: unlocked ? const Color(0xFF76501F) : WashiSurface.mutedInk,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
