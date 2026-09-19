import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../models/local_item.dart';
import '../services/app_repository.dart';
import '../services/storage_service.dart';

enum _OverlayKind { stamp, text }

class _OverlayItem {
  _OverlayItem.stamp({
    required this.id,
    required this.offset,
    this.stampIndex,
    this.assetPath,
  })  : kind = _OverlayKind.stamp,
        text = null,
        assert(stampIndex != null || assetPath != null);

  _OverlayItem.text({required this.id, required this.text, required this.offset})
      : kind = _OverlayKind.text,
        stampIndex = null,
        assetPath = null;

  final int id;
  final _OverlayKind kind;
  final int? stampIndex;
  final String? assetPath;
  final String? text;
  final GlobalKey repaintKey = GlobalKey();
  Offset offset;
  double scale = 1.0;
  double gestureStartScale = 1.0;
  double rotation = 0.0;
  double gestureStartRotation = 0.0;
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, required this.repository, required this.memoryId});
  final AppRepository repository;
  final String memoryId;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription> _cameras = const [];
  int _cameraIndex = 0;
  final _previewKey = GlobalKey();
  final _overlays = <_OverlayItem>[];
  int _overlaySerial = 0;
  int? _selectedOverlayId;
  bool _saving = false;
  bool _initializing = true;
  String? _cameraError;
  final _storage = StorageService();

  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  double _zoom = 1.0;
  double _zoomAtGestureStart = 1.0;
  double _minExposure = 0.0;
  double _maxExposure = 0.0;
  double _exposure = 0.0;
  FlashMode _flashMode = FlashMode.off;
  Offset? _focusIndicator;
  Timer? _focusTimer;
  bool _showStampPanel = false;
  int _orientationIndex = 0;
  static const _orientations = <DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
    _init();
  }

  Future<void> _init() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) throw Exception('利用できるカメラがありません。');
      await _initializeCamera(0);
    } catch (e) {
      if (mounted) setState(() => _cameraError = 'カメラを起動できません: $e');
    } finally {
      if (mounted) setState(() => _initializing = false);
    }
  }

  Future<void> _initializeCamera(int index) async {
    final old = _controller;
    _controller = null;
    if (mounted) setState(() {});
    await old?.dispose();

    final controller = CameraController(
      _cameras[index],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    await controller.initialize();
    try {
      await controller.lockCaptureOrientation(_orientations[_orientationIndex]);
    } catch (_) {}

    double minZoom = 1.0;
    double maxZoom = 1.0;
    double minExposure = 0.0;
    double maxExposure = 0.0;
    try {
      minZoom = await controller.getMinZoomLevel();
      maxZoom = await controller.getMaxZoomLevel();
      minExposure = await controller.getMinExposureOffset();
      maxExposure = await controller.getMaxExposureOffset();
      await controller.setFlashMode(FlashMode.off);
    } catch (_) {}

    if (!mounted) {
      await controller.dispose();
      return;
    }
    setState(() {
      _controller = controller;
      _cameraIndex = index;
      _minZoom = minZoom;
      _maxZoom = maxZoom;
      _zoom = minZoom.clamp(minZoom, maxZoom).toDouble();
      _minExposure = minExposure;
      _maxExposure = maxExposure;
      _exposure = 0.0.clamp(minExposure, maxExposure).toDouble();
      _flashMode = FlashMode.off;
      _cameraError = null;
    });
  }

  @override
  void dispose() {
    _focusTimer?.cancel();
    _controller?.dispose();
    SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
    super.dispose();
  }


  Future<void> _cycleOrientation() async {
    final nextIndex = (_orientationIndex + 1) % _orientations.length;
    final next = _orientations[nextIndex];
    setState(() => _orientationIndex = nextIndex);
    await SystemChrome.setPreferredOrientations([next]);
    try {
      await _controller?.lockCaptureOrientation(next);
    } catch (_) {}
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2 || _saving) return;
    final next = (_cameraIndex + 1) % _cameras.length;
    setState(() => _initializing = true);
    try {
      await _initializeCamera(next);
    } catch (e) {
      if (mounted) setState(() => _cameraError = 'カメラ切替に失敗しました: $e');
    } finally {
      if (mounted) setState(() => _initializing = false);
    }
  }

  Future<void> _setZoom(double value) async {
    final controller = _controller;
    if (controller == null) return;
    final next = value.clamp(_minZoom, _maxZoom).toDouble();
    setState(() => _zoom = next);
    try {
      await controller.setZoomLevel(next);
    } catch (_) {}
  }

  Future<void> _setExposure(double value) async {
    final controller = _controller;
    if (controller == null) return;
    final next = value.clamp(_minExposure, _maxExposure).toDouble();
    setState(() => _exposure = next);
    try {
      await controller.setExposureOffset(next);
    } catch (_) {}
  }

  Future<void> _focusAt(TapDownDetails details, Size size) async {
    final controller = _controller;
    if (controller == null || size.width <= 0 || size.height <= 0) return;
    final point = Offset(
      (details.localPosition.dx / size.width).clamp(0.0, 1.0).toDouble(),
      (details.localPosition.dy / size.height).clamp(0.0, 1.0).toDouble(),
    );
    setState(() => _focusIndicator = details.localPosition);
    _focusTimer?.cancel();
    _focusTimer = Timer(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _focusIndicator = null);
    });
    try {
      await controller.setFocusPoint(point);
      await controller.setExposurePoint(point);
    } catch (_) {}
  }

  Future<void> _cycleFlash() async {
    final controller = _controller;
    if (controller == null) return;
    final next = switch (_flashMode) {
      FlashMode.off => FlashMode.auto,
      FlashMode.auto => FlashMode.always,
      FlashMode.always => FlashMode.off,
      FlashMode.torch => FlashMode.off,
    };
    try {
      await controller.setFlashMode(next);
      if (mounted) setState(() => _flashMode = next);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('この端末ではフラッシュを切り替えられません: $e')));
    }
  }

  IconData get _flashIcon => switch (_flashMode) {
        FlashMode.off => Icons.flash_off,
        FlashMode.auto => Icons.flash_auto,
        FlashMode.always => Icons.flash_on,
        FlashMode.torch => Icons.highlight,
      };

  void _addStamp(int index) {
    final path = widget.repository.stampPaths[index];
    if (path == null || !File(path).existsSync()) return;
    final item = _OverlayItem.stamp(
      id: ++_overlaySerial,
      stampIndex: index,
      offset: Offset(70.0 + (_overlays.length % 3) * 24, 120.0 + (_overlays.length % 3) * 24),
    );
    setState(() {
      _overlays.add(item);
      _selectedOverlayId = item.id;
      _showStampPanel = false;
    });
  }

  void _addLocalItemStamp(LocalItem localItem) {
    final item = _OverlayItem.stamp(
      id: ++_overlaySerial,
      assetPath: localItem.assetPath,
      offset: Offset(70.0 + (_overlays.length % 3) * 24, 120.0 + (_overlays.length % 3) * 24),
    );
    setState(() {
      _overlays.add(item);
      _selectedOverlayId = item.id;
      _showStampPanel = false;
    });
  }

  Future<void> _chooseLocalItemStamp() async {
    final region = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('地域を選択'),
        children: [
          for (final value in localItemRegions)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, value),
              child: ListTile(
                leading: const Icon(Icons.landscape_outlined),
                title: Text(value),
                subtitle: const Text('名産スタンプ'),
              ),
            ),
        ],
      ),
    );
    if (region == null || !mounted) return;

    final prefectures = localItems
        .where((e) => e.region == region)
        .map((e) => e.prefecture)
        .toSet()
        .toList();
    final prefecture = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('$region → 都道府県'),
        children: [
          for (final value in prefectures)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, value),
              child: ListTile(
                leading: const Icon(Icons.place_outlined),
                title: Text(value),
                trailing: Text('${widget.repository.pointsForPrefecture(value)}P'),
              ),
            ),
        ],
      ),
    );
    if (prefecture == null || !mounted) return;

    final unlocked = widget.repository.unlockedLocalItems(prefecture: prefecture);
    if (unlocked.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$prefecture で使用できる名産スタンプはまだありません。')),
      );
      return;
    }
    final selected = await showDialog<LocalItem>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$prefecture のスタンプ'),
        content: SizedBox(
          width: 420,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: unlocked.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = unlocked[index];
              return ListTile(
                leading: SizedBox(
                  width: 48,
                  height: 48,
                  child: Image.asset(item.assetPath, fit: BoxFit.contain),
                ),
                title: Text(item.name),
                subtitle: Text('${item.threshold}P'),
                onTap: () => Navigator.pop(context, item),
              );
            },
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('閉じる'))],
      ),
    );
    if (selected != null && mounted) _addLocalItemStamp(selected);
  }

  Future<void> _addText() async {
    final c = TextEditingController(text: 'ねことまた旅');
    final value = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('文字スタンプ'),
        content: TextField(controller: c, maxLength: 30),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('キャンセル')),
          FilledButton(onPressed: () => Navigator.pop(context, c.text.trim()), child: const Text('追加')),
        ],
      ),
    );
    if (value == null || value.isEmpty || !mounted) return;
    final item = _OverlayItem.text(
      id: ++_overlaySerial,
      text: value,
      offset: Offset(70.0 + (_overlays.length % 3) * 24, 120.0 + (_overlays.length % 3) * 24),
    );
    setState(() {
      _overlays.add(item);
      _selectedOverlayId = item.id;
    });
  }

  void _removeSelectedOverlay() {
    if (_selectedOverlayId == null) return;
    setState(() {
      _overlays.removeWhere((e) => e.id == _selectedOverlayId);
      _selectedOverlayId = _overlays.isEmpty ? null : _overlays.last.id;
    });
  }

  Widget _overlayContent(_OverlayItem item) {
    if (item.kind == _OverlayKind.text) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: .82), borderRadius: BorderRadius.circular(20)),
        child: Text(item.text!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
      );
    }
    if (item.assetPath != null) {
      return Image.asset(item.assetPath!, width: 150, fit: BoxFit.contain);
    }
    final stampIndex = item.stampIndex;
    if (stampIndex != null) {
      final path = widget.repository.stampPaths[stampIndex];
      if (path != null && File(path).existsSync()) {
        return Image.file(File(path), width: 150, fit: BoxFit.contain);
      }
    }
    return const SizedBox(width: 1, height: 1);
  }

  Widget _buildOverlay(_OverlayItem item) {
    final selected = item.id == _selectedOverlayId;
    return Positioned(
      left: item.offset.dx,
      top: item.offset.dy,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _selectedOverlayId = item.id),
        onScaleStart: (_) {
          item.gestureStartScale = item.scale;
          item.gestureStartRotation = item.rotation;
          setState(() => _selectedOverlayId = item.id);
        },
        onScaleUpdate: (details) {
          setState(() {
            item.offset += details.focalPointDelta;
            item.scale = (item.gestureStartScale * details.scale).clamp(.25, 4.0);
            item.rotation = item.gestureStartRotation + details.rotation;
          });
        },
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..scale(item.scale)
            ..rotateZ(item.rotation),
          child: Container(
            decoration: selected
                ? BoxDecoration(border: Border.all(color: Colors.white.withValues(alpha: .9), width: 1.5), borderRadius: BorderRadius.circular(8))
                : null,
            child: RepaintBoundary(key: item.repaintKey, child: _overlayContent(item)),
          ),
        ),
      ),
    );
  }

  Future<Uint8List?> _captureOverlay(_OverlayItem item) async {
    await WidgetsBinding.instance.endOfFrame;
    final boundary = item.repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
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
      final baseBytes = await File(shot.path).readAsBytes();
      final base = img.decodeImage(baseBytes);
      if (base == null) throw Exception('写真の読み込みに失敗しました。');

      final previewBox = _previewKey.currentContext?.findRenderObject() as RenderBox?;
      final previewSize = previewBox?.size ?? context.size ?? const Size(1, 1);
      final xRatio = base.width / previewSize.width;
      final yRatio = base.height / previewSize.height;

      for (final item in _overlays) {
        final overlayBytes = await _captureOverlay(item);
        if (overlayBytes == null) continue;
        final overlay = img.decodePng(overlayBytes);
        if (overlay == null) continue;
        final targetW = (overlay.width * item.scale * xRatio / 2.5).round().clamp(1, base.width).toInt();
        final targetH = (overlay.height * item.scale * yRatio / 2.5).round().clamp(1, base.height).toInt();
        final resized = img.copyResize(overlay, width: targetW, height: targetH, interpolation: img.Interpolation.linear);
        final rotated = item.rotation.abs() < .001
            ? resized
            : img.copyRotate(
                resized,
                angle: item.rotation * 180 / math.pi,
                interpolation: img.Interpolation.linear,
              );
        final baseX = item.offset.dx * xRatio;
        final baseY = item.offset.dy * yRatio;
        final x = (baseX - (rotated.width - resized.width) / 2).round().clamp(0, base.width - 1).toInt();
        final y = (baseY - (rotated.height - resized.height) / 2).round().clamp(0, base.height - 1).toInt();
        img.compositeImage(base, rotated, dstX: x, dstY: y);
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

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            return Stack(
              key: _previewKey,
              children: [
                Positioned.fill(
                  child: controller == null || !controller.value.isInitialized
                      ? Center(child: _cameraError == null ? const CircularProgressIndicator() : Text(_cameraError!, style: const TextStyle(color: Colors.white)))
                      : GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapDown: (d) => _focusAt(d, size),
                          onScaleStart: (d) {
                            if (d.pointerCount >= 2) _zoomAtGestureStart = _zoom;
                          },
                          onScaleUpdate: (d) {
                            if (d.pointerCount >= 2) _setZoom(_zoomAtGestureStart * d.scale);
                          },
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: controller.value.previewSize!.height,
                              height: controller.value.previewSize!.width,
                              child: CameraPreview(controller),
                            ),
                          ),
                        ),
                ),
                ..._overlays.map(_buildOverlay),
                if (_focusIndicator != null)
                  Positioned(
                    left: _focusIndicator!.dx - 24,
                    top: _focusIndicator!.dy - 24,
                    child: IgnorePointer(
                      child: Container(width: 48, height: 48, decoration: BoxDecoration(border: Border.all(color: Colors.yellow, width: 2), borderRadius: BorderRadius.circular(8))),
                    ),
                  ),
                Positioned(
                  top: 8,
                  left: 8,
                  right: 8,
                  child: Row(
                    children: [
                      IconButton.filledTonal(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(16)),
                        child: Text('${_zoom.toStringAsFixed(1)}x', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 6),
                      IconButton.filledTonal(onPressed: _cycleFlash, tooltip: 'フラッシュ', icon: Icon(_flashIcon)),
                      if (_cameras.length > 1) ...[
                        const SizedBox(width: 6),
                        IconButton.filledTonal(onPressed: _switchCamera, tooltip: '前後カメラ切替', icon: const Icon(Icons.cameraswitch)),
                      ],
                    ],
                  ),
                ),
                if (_maxExposure > _minExposure)
                  if (constraints.maxWidth > constraints.maxHeight)
                    Positioned(
                      top: 62,
                      left: constraints.maxWidth * .2,
                      right: constraints.maxWidth * .2,
                      child: Container(
                        color: Colors.black38,
                        child: Slider(
                          value: _exposure.clamp(_minExposure, _maxExposure).toDouble(),
                          min: _minExposure,
                          max: _maxExposure,
                          onChanged: _setExposure,
                        ),
                      ),
                    )
                  else
                    Positioned(
                      right: 2,
                      top: 80,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: SizedBox(
                          width: (constraints.maxHeight - 300).clamp(150.0, 320.0),
                          child: Slider(
                            value: _exposure.clamp(_minExposure, _maxExposure).toDouble(),
                            min: _minExposure,
                            max: _maxExposure,
                            onChanged: _setExposure,
                          ),
                        ),
                      ),
                    ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_showStampPanel)
                        Container(
                          color: Colors.black54,
                          height: 62,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            children: [
                              ActionChip(avatar: const Icon(Icons.text_fields), label: const Text('文字追加'), onPressed: () async { await _addText(); if (mounted) setState(() => _showStampPanel = false); }),
                              const SizedBox(width: 8),
                              ActionChip(
                                avatar: const Icon(Icons.card_giftcard_outlined),
                                label: const Text('ご当地'),
                                onPressed: _chooseLocalItemStamp,
                              ),
                              const SizedBox(width: 8),
                              ...List.generate(4, (i) {
                                final path = widget.repository.stampPaths[i];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ActionChip(
                                    label: Text('猫${i + 1}'),
                                    avatar: path != null && File(path).existsSync()
                                        ? CircleAvatar(backgroundImage: FileImage(File(path)))
                                        : const Icon(Icons.pets),
                                    onPressed: path == null ? null : () => _addStamp(i),
                                  ),
                                );
                              }),
                              if (_selectedOverlayId != null) ...[
                                ActionChip(avatar: const Icon(Icons.rotate_left), label: const Text('角度を戻す'), onPressed: () {
                                  for (final item in _overlays) {
                                    if (item.id == _selectedOverlayId) {
                                      setState(() => item.rotation = 0);
                                      break;
                                    }
                                  }
                                }),
                                const SizedBox(width: 8),
                                ActionChip(avatar: const Icon(Icons.delete_outline), label: const Text('選択中を削除'), onPressed: _removeSelectedOverlay),
                              ],
                              if (_overlays.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                ActionChip(
                                  avatar: const Icon(Icons.layers_clear),
                                  label: const Text('全部消す'),
                                  onPressed: () => setState(() {
                                    _overlays.clear();
                                    _selectedOverlayId = null;
                                  }),
                                ),
                              ],
                            ],
                          ),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton.filledTonal(
                            onPressed: () => setState(() => _showStampPanel = !_showStampPanel),
                            tooltip: 'スタンプ',
                            icon: const Icon(Icons.pets),
                          ),
                          const SizedBox(width: 18),
                          FloatingActionButton.large(
                            onPressed: _saving || _initializing ? null : _shoot,
                            child: _saving || _initializing ? const CircularProgressIndicator() : const Icon(Icons.camera_alt, size: 34),
                          ),
                          const SizedBox(width: 18),
                          IconButton.filledTonal(
                            onPressed: _cycleOrientation,
                            tooltip: '画面を回転',
                            icon: const Icon(Icons.screen_rotation),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text('背景をピンチ: ズーム / タップ: フォーカス / スタンプを2本指: 拡大縮小・回転', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
