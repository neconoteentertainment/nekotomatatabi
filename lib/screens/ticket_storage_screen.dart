import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../widgets/app_scaffold.dart';

class TicketStorageScreen extends StatefulWidget {
  const TicketStorageScreen({super.key});

  @override
  State<TicketStorageScreen> createState() => _TicketStorageScreenState();
}

class _TicketStorageScreenState extends State<TicketStorageScreen> {
  final _picker = ImagePicker();
  Directory? _root;
  List<Directory> _folders = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final documents = await getApplicationDocumentsDirectory();
      final root = Directory(p.join(documents.path, 'ticket_folders'));
      await root.create(recursive: true);
      final folders = await root
          .list()
          .where((entry) => entry is Directory)
          .cast<Directory>()
          .toList();
      folders.sort((a, b) => p.basename(a.path).compareTo(p.basename(b.path)));
      if (!mounted) return;
      setState(() {
        _root = root;
        _folders = folders;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _message('保存先を準備できませんでした: $e');
    }
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  String? _safeFolderName(String value) {
    final name = value.trim();
    if (name.isEmpty || name == '.' || name == '..') return null;
    if (RegExp(r'[\\/:*?"<>|]').hasMatch(name)) return null;
    return name;
  }

  Future<void> _createFolder() async {
    final controller = TextEditingController();
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('フォルダを作成'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 40,
          decoration: const InputDecoration(labelText: 'フォルダ名', hintText: '例: 京都旅行 2026'),
          onSubmitted: (value) => Navigator.pop(context, value),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('キャンセル')),
          FilledButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('作成')),
        ],
      ),
    );
    if (value == null || _root == null) return;
    final name = _safeFolderName(value);
    if (name == null) {
      _message('使用できないフォルダ名です。記号 \\ / : * ? " < > | は使えません。');
      return;
    }
    final folder = Directory(p.join(_root!.path, name));
    if (await folder.exists()) {
      _message('同じ名前のフォルダがあります。');
      return;
    }
    await folder.create();
    await _load();
  }

  Future<void> _addImages(Directory folder) async {
    final images = await _picker.pickMultiImage(imageQuality: 100);
    if (images.isEmpty) return;
    var copied = 0;
    for (final image in images) {
      try {
        final extension = p.extension(image.path).isEmpty ? '.jpg' : p.extension(image.path);
        final target = File(p.join(
          folder.path,
          'ticket_${DateTime.now().microsecondsSinceEpoch}_$copied$extension',
        ));
        await File(image.path).copy(target.path);
        copied++;
      } catch (_) {}
    }
    if (mounted) setState(() {});
    _message('$copied枚の画像を保存しました。');
  }

  List<File> _images(Directory folder) {
    if (!folder.existsSync()) return const [];
    final files = folder
        .listSync()
        .whereType<File>()
        .where((file) => ['.jpg', '.jpeg', '.png', '.webp'].contains(p.extension(file.path).toLowerCase()))
        .toList();
    files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    return files;
  }

  Future<void> _deleteImage(File file) async {
    await file.delete();
    if (mounted) setState(() {});
  }

  Future<void> _deleteFolder(Directory folder) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('フォルダを削除'),
        content: Text('「${p.basename(folder.path)}」と、中の画像をすべて削除しますか？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('キャンセル')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('削除')),
        ],
      ),
    );
    if (ok != true) return;
    await folder.delete(recursive: true);
    await _load();
  }

  void _showImage(File file) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            InteractiveViewer(child: Image.file(file, fit: BoxFit.contain)),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton.filledTonal(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '電子チケット保存',
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                FilledButton.icon(
                  onPressed: _createFolder,
                  icon: const Icon(Icons.create_new_folder_outlined),
                  label: const Text('新しいフォルダを作る'),
                ),
                const SizedBox(height: 10),
                const Text('画像はこの端末のアプリ内に保存されます。大切なチケットは元画像も残してください。'),
                const SizedBox(height: 12),
                if (_folders.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('まだフォルダがありません。')),
                    ),
                  ),
                for (final folder in _folders) _FolderCard(
                  folder: folder,
                  images: _images(folder),
                  onAdd: () => _addImages(folder),
                  onDeleteFolder: () => _deleteFolder(folder),
                  onOpenImage: _showImage,
                  onDeleteImage: _deleteImage,
                ),
              ],
            ),
    );
  }
}

class _FolderCard extends StatelessWidget {
  const _FolderCard({
    required this.folder,
    required this.images,
    required this.onAdd,
    required this.onDeleteFolder,
    required this.onOpenImage,
    required this.onDeleteImage,
  });

  final Directory folder;
  final List<File> images;
  final VoidCallback onAdd;
  final VoidCallback onDeleteFolder;
  final ValueChanged<File> onOpenImage;
  final ValueChanged<File> onDeleteImage;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: const Icon(Icons.folder_outlined),
        title: Text(p.basename(folder.path), style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${images.length}枚'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'add') onAdd();
            if (value == 'delete') onDeleteFolder();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'add', child: Text('画像を追加')),
            PopupMenuItem(value: 'delete', child: Text('フォルダを削除')),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  label: const Text('スマホから画像を追加'),
                ),
                if (images.isNotEmpty)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final file = images[index];
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          InkWell(
                            onTap: () => onOpenImage(file),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(file, fit: BoxFit.cover),
                            ),
                          ),
                          Positioned(
                            top: 2,
                            right: 2,
                            child: IconButton.filled(
                              visualDensity: VisualDensity.compact,
                              onPressed: () => onDeleteImage(file),
                              icon: const Icon(Icons.delete_outline, size: 18),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
