import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/app_repository.dart';
import '../widgets/app_scaffold.dart';

class StampEditorScreen extends StatelessWidget {
  StampEditorScreen({super.key, required this.repository});
  final AppRepository repository;
  final _picker = ImagePicker();

  Future<void> _pick(BuildContext context, int index) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (picked == null) return;
    await repository.setStamp(index, File(picked.path));
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('スタンプ${index + 1}を保存しました。')));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'スタンプエディット',
      child: AnimatedBuilder(animation: repository, builder: (context, _) => ListView(padding: const EdgeInsets.all(16), children: [
        const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('背景を透過した猫のPNG画像などを登録してください。全部で4つまで保存できます。画像はアプリ内へコピーして保持します。'))),
        const SizedBox(height: 8),
        ...List.generate(4, (i) {
          final path = repository.stampPaths[i];
          final exists = path != null && File(path).existsSync();
          return Card(child: Padding(padding: const EdgeInsets.all(12), child: Row(children: [
            Container(width: 88, height: 88, decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(16)), child: exists ? Padding(padding: const EdgeInsets.all(6), child: Image.file(File(path), fit: BoxFit.contain)) : const Icon(Icons.pets, size: 42)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('スタンプ ${i + 1}', style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 8), Wrap(spacing: 8, children: [FilledButton.tonalIcon(onPressed: () => _pick(context, i), icon: const Icon(Icons.photo_library), label: Text(exists ? '差し替え' : '選択')), if (exists) TextButton.icon(onPressed: () => repository.clearStamp(i), icon: const Icon(Icons.delete_outline), label: const Text('削除'))])]))
          ])));
        }),
      ])),
    );
  }
}
