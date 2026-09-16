import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/travel_plan.dart';
import '../services/app_repository.dart';
import '../widgets/app_scaffold.dart';

class TravelPlanScreen extends StatefulWidget {
  const TravelPlanScreen({super.key, required this.repository});
  final AppRepository repository;

  @override
  State<TravelPlanScreen> createState() => _TravelPlanScreenState();
}

class _TravelPlanScreenState extends State<TravelPlanScreen> {
  final _picker = ImagePicker();

  Future<void> _editPlan([TravelPlan? original]) async {
    var date = original?.date ?? DateTime.now();
    final title = TextEditingController(text: original?.title ?? '');
    final items = <TravelPlanItem>[...?original?.items];

    final result = await showDialog<TravelPlan>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setLocalState) => AlertDialog(
          title: Text(original == null ? '旅の予定を作成' : '旅の予定を編集'),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(controller: title, decoration: const InputDecoration(labelText: '予定名（例：名古屋日帰り旅行）')),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_month),
                    label: Text('${date.year}/${date.month}/${date.day}'),
                    onPressed: () async {
                      final picked = await showDatePicker(context: context, initialDate: date, firstDate: DateTime(2020), lastDate: DateTime(2100));
                      if (picked != null) setLocalState(() => date = picked);
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text('1日のスケジュール', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ...List.generate(items.length, (i) {
                    final item = items[i];
                    return Card(
                      child: ListTile(
                        leading: Text(item.time.isEmpty ? '--:--' : item.time),
                        title: Text(item.title),
                        subtitle: item.memo.isEmpty ? null : Text(item.memo),
                        trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => setLocalState(() => items.removeAt(i))),
                        onTap: () async {
                          final edited = await _editPlanItem(context, item);
                          if (edited != null) {
                            setLocalState(() {
                              items[i] = edited;
                              items.sort((a, b) => a.time.compareTo(b.time));
                            });
                          }
                        },
                      ),
                    );
                  }),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final added = await _editPlanItem(context, null);
                      if (added != null) {
                        setLocalState(() {
                          items.add(added);
                          items.sort((a, b) => a.time.compareTo(b.time));
                        });
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('予定を追加'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('キャンセル')),
            FilledButton(
              onPressed: () {
                final name = title.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('予定名を入力してください。')));
                  return;
                }
                Navigator.pop(dialogContext, TravelPlan(id: original?.id ?? DateTime.now().microsecondsSinceEpoch.toString(), title: name, date: date, items: List.unmodifiable(items)));
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
    if (result != null) await widget.repository.saveTravelPlan(result);
  }

  Future<TravelPlanItem?> _editPlanItem(BuildContext context, TravelPlanItem? original) async {
    final parsed = _parseTime(original?.time) ?? TimeOfDay.now();
    final hour = TextEditingController(text: parsed.hour.toString().padLeft(2, '0'));
    final minute = TextEditingController(text: parsed.minute.toString().padLeft(2, '0'));
    final title = TextEditingController(text: original?.title ?? '');
    final memo = TextEditingController(text: original?.memo ?? '');
    String? timeError;

    return showDialog<TravelPlanItem>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setLocalState) => AlertDialog(
          title: Text(original == null ? '予定を追加' : '予定を編集'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(child: TextField(controller: hour, keyboardType: TextInputType.number, textAlign: TextAlign.center, maxLength: 2, inputFormatters: [FilteringTextInputFormatter.digitsOnly], decoration: const InputDecoration(labelText: '時', counterText: ''))),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text(':', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                  Expanded(child: TextField(controller: minute, keyboardType: TextInputType.number, textAlign: TextAlign.center, maxLength: 2, inputFormatters: [FilteringTextInputFormatter.digitsOnly], decoration: const InputDecoration(labelText: '分', counterText: ''))),
                ],
              ),
              if (timeError != null) Padding(padding: const EdgeInsets.only(top: 6), child: Text(timeError!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
              const SizedBox(height: 10),
              TextField(controller: title, decoration: const InputDecoration(labelText: '予定・行き先')),
              const SizedBox(height: 10),
              TextField(controller: memo, maxLines: 2, decoration: const InputDecoration(labelText: 'メモ（任意）')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('キャンセル')),
            FilledButton(
              onPressed: () {
                final h = int.tryParse(hour.text);
                final m = int.tryParse(minute.text);
                if (h == null || m == null || h < 0 || h > 23 || m < 0 || m > 59) {
                  setLocalState(() => timeError = '時は0〜23、分は0〜59で入力してください。');
                  return;
                }
                if (title.text.trim().isEmpty) return;
                final time = '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
                Navigator.pop(dialogContext, TravelPlanItem(time: time, title: title.text.trim(), memo: memo.text.trim()));
              },
              child: const Text('決定'),
            ),
          ],
        ),
      ),
    );
  }

  TimeOfDay? _parseTime(String? value) {
    if (value == null) return null;
    final parts = value.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null || h < 0 || h > 23 || m < 0 || m > 59) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  Future<Uint8List> _qrBytes(TravelPlan plan) async {
    final painter = QrPainter(data: plan.toShareText(), version: QrVersions.auto, gapless: true);
    final data = await painter.toImageData(1024, format: ui.ImageByteFormat.png);
    if (data == null) throw Exception('QRコード画像を作成できませんでした。');
    return data.buffer.asUint8List();
  }

  Future<void> _saveQr(TravelPlan plan) async {
    try {
      final bytes = await _qrBytes(plan);
      await Gal.putImageBytes(bytes, name: 'nekotomatatabi_${DateTime.now().millisecondsSinceEpoch}');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('QRコードを写真ライブラリへ保存しました。')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('QRコードの保存に失敗しました: $e')));
    }
  }

  void _showQr(TravelPlan plan) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('QRコードで共有'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('相手の「ねことまた旅」でこのQRコードを読み取ってください。'),
          const SizedBox(height: 16),
          QrImageView(data: plan.toShareText(), version: QrVersions.auto, size: 260),
        ]),
        actions: [
          TextButton.icon(onPressed: () => _saveQr(plan), icon: const Icon(Icons.download), label: const Text('画像を保存')),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('閉じる')),
        ],
      ),
    );
  }

  Future<void> _importRaw(String raw) async {
    final imported = TravelPlan.fromShareText(raw);
    if (imported == null) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('「ねことまた旅」の予定QRコードではありません。')));
      return;
    }
    final plan = TravelPlan(id: DateTime.now().microsecondsSinceEpoch.toString(), title: imported.title, date: imported.date, items: imported.items);
    await widget.repository.saveTravelPlan(plan);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('旅の予定を取り込みました。')));
  }

  Future<void> _scanQr() async {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('QRコードの読み取りはAndroid / iPhoneで利用できます。')));
      return;
    }
    final raw = await Navigator.of(context).push<String>(MaterialPageRoute(builder: (_) => const _QrScannerScreen()));
    if (raw != null) await _importRaw(raw);
  }

  Future<void> _scanQrFromImage() async {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('画像からのQR読み取りはAndroid / iPhoneで利用できます。')));
      return;
    }
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (picked == null) return;
    final controller = MobileScannerController(autoStart: false, formats: const [BarcodeFormat.qrCode]);
    try {
      final capture = await controller.analyzeImage(picked.path);
      final raw = capture == null || capture.barcodes.isEmpty ? null : capture.barcodes.first.rawValue;
      if (raw == null || raw.isEmpty) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('画像からQRコードを読み取れませんでした。')));
        return;
      }
      await _importRaw(raw);
    } finally {
      await controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '旅の予定',
      actions: [
        PopupMenuButton<String>(
          tooltip: 'QRコードを読み取る',
          icon: const Icon(Icons.qr_code_scanner),
          onSelected: (value) {
            if (value == 'camera') _scanQr();
            if (value == 'image') _scanQrFromImage();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'camera', child: ListTile(leading: Icon(Icons.camera_alt_outlined), title: Text('カメラで読み取る'))),
            PopupMenuItem(value: 'image', child: ListTile(leading: Icon(Icons.photo_library_outlined), title: Text('保存画像から読み取る'))),
          ],
        ),
      ],
      child: AnimatedBuilder(
        animation: widget.repository,
        builder: (_, __) {
          final plans = widget.repository.travelPlans;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              FilledButton.icon(onPressed: () => _editPlan(), icon: const Icon(Icons.add), label: const Text('新しい旅の予定を作る')),
              const SizedBox(height: 12),
              if (plans.isEmpty) const Card(child: Padding(padding: EdgeInsets.all(18), child: Text('まだ予定がありません。旅行当日の時刻と行き先を登録できます。'))),
              ...plans.map((plan) => Card(
                    child: ExpansionTile(
                      leading: const CircleAvatar(child: Icon(Icons.route)),
                      title: Text(plan.title),
                      subtitle: Text('${plan.date.year}/${plan.date.month}/${plan.date.day} ・ ${plan.items.length}件'),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      children: [
                        if (plan.items.isEmpty) const ListTile(title: Text('予定はまだ登録されていません。')),
                        ...plan.items.map((e) => ListTile(dense: true, leading: SizedBox(width: 48, child: Text(e.time)), title: Text(e.title), subtitle: e.memo.isEmpty ? null : Text(e.memo))),
                        Wrap(spacing: 8, children: [
                          OutlinedButton.icon(onPressed: () => _editPlan(plan), icon: const Icon(Icons.edit), label: const Text('編集')),
                          OutlinedButton.icon(onPressed: () => _showQr(plan), icon: const Icon(Icons.qr_code_2), label: const Text('QR共有')),
                          TextButton.icon(onPressed: () => widget.repository.deleteTravelPlan(plan.id), icon: const Icon(Icons.delete_outline), label: const Text('削除')),
                        ]),
                      ],
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}

class _QrScannerScreen extends StatefulWidget {
  const _QrScannerScreen();
  @override
  State<_QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<_QrScannerScreen> {
  bool _done = false;
  final _controller = MobileScannerController(formats: const [BarcodeFormat.qrCode]);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('予定QRコードを読み取る')),
      body: MobileScanner(
        controller: _controller,
        onDetect: (capture) {
          if (_done) return;
          final raw = capture.barcodes.isEmpty ? null : capture.barcodes.first.rawValue;
          if (raw == null || raw.isEmpty) return;
          _done = true;
          Navigator.pop(context, raw);
        },
      ),
    );
  }
}
