import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../services/app_repository.dart';
import '../services/storage_service.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, required this.repository, required this.memoryId});
  final AppRepository repository;
  final String memoryId;
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  final _overlayKey = GlobalKey();
  int? _stampIndex;
  String _textStamp = 'ねことまた旅';
  bool _showText = false;
  Offset _offset = const Offset(120, 180);
  double _scale = 1.0;
  bool _saving = false;
  final _storage = StorageService();

  @override
  void initState() { super.initState(); _init(); }

  Future<void> _init() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw Exception('利用できるカメラがありません。');
      final controller = CameraController(cameras.first, ResolutionPreset.high, enableAudio: false, imageFormatGroup: ImageFormatGroup.jpeg);
      await controller.initialize();
      if (!mounted) { await controller.dispose(); return; }
      setState(() => _controller = controller);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('カメラを起動できません: $e')));
    }
  }

  @override
  void dispose() { _controller?.dispose(); super.dispose(); }

  Widget _overlayContent() {
    if (_showText) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: .82), borderRadius: BorderRadius.circular(20)),
        child: Text(_textStamp, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
      );
    }
    if (_stampIndex != null) {
      final path = widget.repository.stampPaths[_stampIndex!];
      if (path != null && File(path).existsSync()) return Image.file(File(path), width: 150, fit: BoxFit.contain);
    }
    return const SizedBox(width: 1, height: 1);
  }

  Future<Uint8List?> _captureOverlay() async {
    await WidgetsBinding.instance.endOfFrame;
    final boundary = _overlayKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: 2.5);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data?.buffer.asUint8List();
  }

  Future<void> _shoot() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _saving) return;
    setState(() => _saving = true);
    try {
      final shot = await controller.takePicture();
      final overlayBytes = await _captureOverlay();
      final baseBytes = await File(shot.path).readAsBytes();
      final base = img.decodeImage(baseBytes);
      if (base == null) throw Exception('写真の読み込みに失敗しました。');
      if (overlayBytes != null && (_showText || _stampIndex != null)) {
        final overlay = img.decodePng(overlayBytes);
        if (overlay != null) {
          final previewSize = context.size ?? const Size(1, 1);
          final xRatio = base.width / previewSize.width;
          final yRatio = base.height / previewSize.height;
          final targetW = (overlay.width * _scale * xRatio / 2.5).round().clamp(1, base.width);
          final targetH = (overlay.height * _scale * yRatio / 2.5).round().clamp(1, base.height);
          final resized = img.copyResize(overlay, width: targetW, height: targetH, interpolation: img.Interpolation.linear);
          final x = (_offset.dx * xRatio).round().clamp(0, base.width - 1);
          final y = (_offset.dy * yRatio).round().clamp(0, base.height - 1);
          img.compositeImage(base, resized, dstX: x, dstY: y);
        }
      }
      final temp = await getTemporaryDirectory();
      final composed = File('${temp.path}/nekotabi_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await composed.writeAsBytes(img.encodeJpg(base, quality: 94));
      final saved = await _storage.persistPhoto(composed);
      await widget.repository.addPhotoToMemory(widget.memoryId, saved);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('写真を思い出に保存しました。')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('撮影に失敗しました: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _editText() async {
    final c = TextEditingController(text: _textStamp);
    final value = await showDialog<String>(context: context, builder: (_) => AlertDialog(
      title: const Text('文字スタンプ'),
      content: TextField(controller: c, maxLength: 20),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('キャンセル')), FilledButton(onPressed: () => Navigator.pop(context, c.text.trim()), child: const Text('決定'))],
    ));
    if (value != null && value.isNotEmpty) setState(() { _textStamp = value; _showText = true; _stampIndex = null; });
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: Stack(children: [
        Positioned.fill(child: controller == null || !controller.value.isInitialized ? const Center(child: CircularProgressIndicator()) : FittedBox(fit: BoxFit.cover, child: SizedBox(width: controller.value.previewSize!.height, height: controller.value.previewSize!.width, child: CameraPreview(controller)))),
        Positioned(left: _offset.dx, top: _offset.dy, child: GestureDetector(
          onPanUpdate: (d) => setState(() => _offset += d.delta),
          onScaleUpdate: (d) => setState(() => _scale = d.scale.clamp(.4, 2.5)),
          child: Transform.scale(scale: _scale, alignment: Alignment.topLeft, child: RepaintBoundary(key: _overlayKey, child: _overlayContent())),
        )),
        Positioned(top: 8, left: 8, child: IconButton.filledTonal(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))),
        Positioned(left: 0, right: 0, bottom: 12, child: Column(children: [
          SizedBox(height: 72, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12), children: [
            ChoiceChip(label: const Text('なし'), selected: !_showText && _stampIndex == null, onSelected: (_) => setState(() { _showText = false; _stampIndex = null; })),
            const SizedBox(width: 8),
            ActionChip(avatar: const Icon(Icons.text_fields), label: const Text('文字'), onPressed: _editText),
            const SizedBox(width: 8),
            ...List.generate(4, (i) {
              final path = widget.repository.stampPaths[i];
              return Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text('猫${i + 1}'), selected: _stampIndex == i, avatar: path != null && File(path).existsSync() ? CircleAvatar(backgroundImage: FileImage(File(path))) : const Icon(Icons.pets), onSelected: path == null ? null : (_) => setState(() { _stampIndex = i; _showText = false; })));
            }),
          ])),
          FloatingActionButton.large(onPressed: _saving ? null : _shoot, child: _saving ? const CircularProgressIndicator() : const Icon(Icons.camera_alt, size: 34)),
        ])),
      ])),
    );
  }
}
