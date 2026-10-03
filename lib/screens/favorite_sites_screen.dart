import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/favorite_site.dart';
import '../models/local_item.dart';
import '../services/app_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/washi_surface.dart';

class FavoriteSitesScreen extends StatefulWidget {
  const FavoriteSitesScreen({super.key, required this.repository});

  final AppRepository repository;

  @override
  State<FavoriteSitesScreen> createState() => _FavoriteSitesScreenState();
}

class _FavoriteSitesScreenState extends State<FavoriteSitesScreen> {
  final _picker = ImagePicker();

  Future<void> _importRaw(String raw) async {
    final bundle = FavoriteSiteBundle.fromShareText(raw);
    if (bundle == null || !localItemPrefectures.contains(bundle.prefecture)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('「ねことまた旅」のお気に入りQRコードではありません。')),
        );
      }
      return;
    }
    final added = await widget.repository.importFavoriteSites(bundle.sites);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            added == 0
                ? 'すべて登録済みのサイトです。'
                : '${bundle.prefecture}へ$added件取り込みました。',
          ),
        ),
      );
    }
  }

  Future<void> _scanQr() async {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      _message('QRコードの読み取りはAndroid / iPhoneで利用できます。');
      return;
    }
    final raw = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const _FavoriteQrScannerScreen()),
    );
    if (raw != null) await _importRaw(raw);
  }

  Future<void> _scanQrFromImage() async {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      _message('画像からのQR読み取りはAndroid / iPhoneで利用できます。');
      return;
    }
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    if (picked == null) return;
    final controller = MobileScannerController(
      autoStart: false,
      formats: const [BarcodeFormat.qrCode],
    );
    try {
      final capture = await controller.analyzeImage(picked.path);
      final raw = capture == null || capture.barcodes.isEmpty
          ? null
          : capture.barcodes.first.rawValue;
      if (raw == null || raw.isEmpty) {
        _message('画像からQRコードを読み取れませんでした。');
        return;
      }
      await _importRaw(raw);
    } finally {
      await controller.dispose();
    }
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return AppScaffold(
      title: 'お気に入りのサイト',
      subtitle: 'FAVORITE PLACES',
      actions: [
        PopupMenuButton<String>(
          tooltip: 'お気に入りQRコードを読み取る',
          icon: const Icon(Icons.qr_code_scanner),
          onSelected: (value) {
            if (value == 'camera') _scanQr();
            if (value == 'image') _scanQrFromImage();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: 'camera',
              child: ListTile(
                leading: Icon(Icons.camera_alt_outlined),
                title: Text('カメラで読み取る'),
              ),
            ),
            PopupMenuItem(
              value: 'image',
              child: ListTile(
                leading: Icon(Icons.photo_library_outlined),
                title: Text('保存画像から読み取る'),
              ),
            ),
          ],
        ),
      ],
      child: AnimatedBuilder(
        animation: widget.repository,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const WashiCard(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Safariの共有ボタンから「ねことまた旅に登録」を選ぶと、保存先の都道府県を指定して直接登録できます。URLをコピーして「URLを追加」から登録することもできます。',
                ),
              ),
            ),
            const SizedBox(height: 12),
            for (final region in localItemRegions) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 12, 4, 6),
                child: Text(
                  region,
                  style: TextStyle(
                    color: palette.accent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              for (final prefecture in prefecturesForRegion(region))
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: WashiCard(
                    child: ListTile(
                      leading: const Icon(Icons.bookmark_outline),
                      title: Text(
                        prefecture,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${widget.repository.favoriteSitesFor(prefecture).length}件',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => _PrefectureSitesScreen(
                            repository: widget.repository,
                            prefecture: prefecture,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PrefectureSitesScreen extends StatefulWidget {
  const _PrefectureSitesScreen({
    required this.repository,
    required this.prefecture,
  });

  final AppRepository repository;
  final String prefecture;

  @override
  State<_PrefectureSitesScreen> createState() =>
      _PrefectureSitesScreenState();
}

class _PrefectureSitesScreenState extends State<_PrefectureSitesScreen> {
  Future<void> _addSite() async {
    final title = TextEditingController();
    final url = TextEditingController();
    final result = await showDialog<(String, String)>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${widget.prefecture}へサイトを追加'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(
                labelText: '名前（任意）',
                hintText: '例：○○水族館',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: url,
              autofocus: true,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'URL',
                hintText: 'https://example.com',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(
              context,
              (title.text.trim(), url.text.trim()),
            ),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (result == null) return;
    final uri = Uri.tryParse(result.$2);
    if (uri == null ||
        !uri.hasAuthority ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      _message('http:// または https:// から始まるURLを入力してください。');
      return;
    }
    final site = FavoriteSite(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      prefecture: widget.prefecture,
      title: result.$1.isEmpty ? uri.host : result.$1,
      url: uri.toString(),
      createdAt: DateTime.now(),
    );
    await widget.repository.saveFavoriteSite(site);
  }

  Future<void> _openSite(FavoriteSite site) async {
    final uri = Uri.tryParse(site.url);
    if (uri == null ||
        !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _message('サイトを開けませんでした。');
    }
  }

  Future<Uint8List> _qrBytes(String raw) async {
    final painter = QrPainter(
      data: raw,
      version: QrVersions.auto,
      gapless: true,
    );
    final data = await painter.toImageData(
      1024,
      format: ui.ImageByteFormat.png,
    );
    if (data == null) throw Exception('QRコード画像を作成できませんでした。');
    return data.buffer.asUint8List();
  }

  Future<void> _saveQr(String raw) async {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      _message('QRコードの写真保存はAndroid / iPhoneで利用できます。');
      return;
    }
    try {
      final bytes = await _qrBytes(raw);
      await Gal.putImageBytes(
        bytes,
        name: 'nekotomatatabi_sites_${DateTime.now().millisecondsSinceEpoch}',
      );
      _message('QRコードを写真ライブラリへ保存しました。');
    } catch (e) {
      _message('QRコードの保存に失敗しました: $e');
    }
  }

  void _showQr(List<FavoriteSite> sites) {
    if (sites.isEmpty) {
      _message('共有するサイトがありません。');
      return;
    }
    final raw = FavoriteSiteBundle(
      prefecture: widget.prefecture,
      sites: sites,
    ).toShareText();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${widget.prefecture}のお気に入りを共有'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${sites.length}件のURLをまとめたQRコードです。'),
              const SizedBox(height: 16),
              QrImageView(data: raw, version: QrVersions.auto, size: 260),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _saveQr(raw),
            icon: const Icon(Icons.download),
            label: const Text('画像を保存'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteSite(FavoriteSite site) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('お気に入りを削除'),
        content: Text('「${site.title}」を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('削除'),
          ),
        ],
      ),
    );
    if (ok == true) await widget.repository.deleteFavoriteSite(site.id);
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: widget.prefecture,
      subtitle: 'FAVORITE PLACES',
      child: AnimatedBuilder(
        animation: widget.repository,
        builder: (context, _) {
          final sites = widget.repository.favoriteSitesFor(widget.prefecture);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _addSite,
                      icon: const Icon(Icons.add_link),
                      label: const Text('URLを追加'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: sites.isEmpty ? null : () => _showQr(sites),
                    icon: const Icon(Icons.qr_code_2),
                    label: const Text('QR共有'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (sites.isEmpty)
                const WashiCard(
                  child: Padding(
                    padding: EdgeInsets.all(22),
                    child: Center(child: Text('保存されたサイトはまだありません。')),
                  ),
                ),
              for (final site in sites)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: WashiCard(
                    child: ListTile(
                      leading: const Icon(Icons.language),
                      title: Text(
                        site.title.isEmpty ? site.url : site.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        site.url,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        tooltip: '削除',
                        onPressed: () => _deleteSite(site),
                        icon: const Icon(Icons.delete_outline),
                      ),
                      onTap: () => _openSite(site),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _FavoriteQrScannerScreen extends StatefulWidget {
  const _FavoriteQrScannerScreen();

  @override
  State<_FavoriteQrScannerScreen> createState() =>
      _FavoriteQrScannerScreenState();
}

class _FavoriteQrScannerScreenState
    extends State<_FavoriteQrScannerScreen> {
  bool _done = false;
  final _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('お気に入りQRを読み取る')),
      body: MobileScanner(
        controller: _controller,
        onDetect: (capture) {
          if (_done) return;
          final raw = capture.barcodes.isEmpty
              ? null
              : capture.barcodes.first.rawValue;
          if (raw == null || raw.isEmpty) return;
          _done = true;
          Navigator.pop(context, raw);
        },
      ),
    );
  }
}
