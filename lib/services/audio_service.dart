import 'package:audioplayers/audioplayers.dart';

/// Handles all game audio
class AudioService {
  final AudioPlayer _sfxPlayer = AudioPlayer();
  bool _soundEnabled = true;

  bool get soundEnabled => _soundEnabled;

  /// Toggle sound on/off
  void toggleSound() {
    _soundEnabled = !_soundEnabled;
  }

  /// Set sound enabled state
  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  /// Play tap sound
  Future<void> playTap() async {
    if (!_soundEnabled) return;

    try {
      await _sfxPlayer.play(AssetSource('sounds/tap.mp3'));
    } catch (e) {
      // Sound file may not exist yet, silent fail
    }
  }

  /// Play purchase sound
  Future<void> playPurchase() async {
    if (!_soundEnabled) return;

    try {
      await _sfxPlayer.play(AssetSource('sounds/purchase.mp3'));
    } catch (e) {
      // Sound file may not exist yet, silent fail
    }
  }

  /// Play event sound
  Future<void> playEvent() async {
    if (!_soundEnabled) return;

    try {
      await _sfxPlayer.play(AssetSource('sounds/event.mp3'));
    } catch (e) {
      // Sound file may not exist yet, silent fail
    }
  }

  /// Play location unlock sound
  Future<void> playLocationUnlock() async {
    if (!_soundEnabled) return;

    try {
      await _sfxPlayer.play(AssetSource('sounds/unlock.mp3'));
    } catch (e) {
      // Sound file may not exist yet, silent fail
    }
  }

  /// Cleanup
  void dispose() {
    _sfxPlayer.dispose();
  }
}
