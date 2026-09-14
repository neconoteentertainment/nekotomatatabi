import 'package:flutter/material.dart';

import '../services/app_repository.dart';
import '../widgets/app_scaffold.dart';

class ItemScreen extends StatelessWidget {
  const ItemScreen({super.key, required this.repository});

  final AppRepository repository;
  static const thresholds = [5, 10, 20, 30, 40, 50];
  static const itemNames = [
    '旅ねこステッカー',
    'ご当地首輪',
    '旅の小判',
    '猫又のお守り',
    '金の肉球',
    '黄金の招き猫',
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'ご当地アイテム',
      child: AnimatedBuilder(
        animation: repository,
        builder: (_, __) {
          final points = repository.points;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      const Text('現在の旅ポイント'),
                      Text(
                        '$points P',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Text('観光地を1件記録するたびに1P獲得'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '地域共通アイテム（初版）',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text('仕様書の「各地域6個」は地域区分が未定のため、まず共通6段階として実装しています。'),
              const SizedBox(height: 8),
              ...List.generate(thresholds.length, (i) {
                final unlocked = points >= thresholds[i];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(unlocked ? Icons.pets : Icons.lock_outline),
                    ),
                    title: Text(itemNames[i]),
                    subtitle: Text('${thresholds[i]}Pで入手'),
                    trailing: Text(
                      unlocked ? '入手済み' : 'あと${thresholds[i] - points}P',
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
