import 'package:audioplayers/audioplayers.dart';

class AppAudioService {
  AppAudioService() : _player = AudioPlayer();

  final AudioPlayer _player;
  String? _currentAsset;
  bool _enabled = true;
  bool _appActive = true;

  Future<void> configure({required bool enabled, required String asset}) async {
    _enabled = enabled;
    _currentAsset = asset;
    await _safe(_apply);
  }

  Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
    await _safe(_apply);
  }

  Future<void> setTrack(String asset) async {
    if (_currentAsset == asset) return;
    _currentAsset = asset;
    if (!_enabled || !_appActive) return;
    await _safe(() async {
      await _player.stop();
      await _playCurrent();
    });
  }

  Future<void> setAppActive(bool active) async {
    _appActive = active;
    await _safe(() async {
      if (!active) {
        await _player.pause();
      } else if (_enabled && _currentAsset != null) {
        if (_player.state == PlayerState.paused) {
          await _player.resume();
        } else if (_player.state != PlayerState.playing) {
          await _playCurrent();
        }
      }
    });
  }

  Future<void> _apply() async {
    if (!_enabled || !_appActive) {
      await _player.pause();
      return;
    }
    if (_currentAsset == null) return;
    await _player.stop();
    await _playCurrent();
  }

  Future<void> _playCurrent() async {
    final asset = _currentAsset;
    if (asset == null) return;
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource(asset), volume: 0.45);
  }

  Future<void> _safe(Future<void> Function() action) async {
    try {
      await action();
    } catch (_) {
      // 音声初期化に失敗してもアプリ本体は起動できるようにする。
    }
  }

  Future<void> dispose() async {
    await _safe(_player.dispose);
  }
}
