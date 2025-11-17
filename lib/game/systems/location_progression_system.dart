import 'package:flame/components.dart';
import '../../models/game_state.dart';
import '../../services/game_config_service.dart';
import '../../services/audio_service.dart';

/// System that handles location progression
class LocationProgressionSystem extends Component {
  final GameState gameState;
  final GameConfigService configService;
  final AudioService audioService;

  static const double _checkInterval = 1.0; // Check every second
  double _elapsed = 0.0;

  LocationProgressionSystem({
    required this.gameState,
    required this.configService,
    required this.audioService,
  });

  @override
  void update(double dt) {
    super.update(dt);

    _elapsed += dt;

    if (_elapsed >= _checkInterval) {
      _checkLocationProgression();
      _elapsed = 0.0;
    }
  }

  void _checkLocationProgression() {
    final currentLocation = configService.getLocation(gameState.currentLocation);
    if (currentLocation == null) return;

    // Check if we've reached the saturation threshold
    if (gameState.locationSaturation >= currentLocation.saturationRequired) {
      // Check if there's a next location
      final nextLocation = configService.getLocation(gameState.currentLocation + 1);
      if (nextLocation != null) {
        gameState.advanceLocation();
        audioService.playLocationUnlock();
      }
    }
  }

  /// Get progress percentage for current location
  double getLocationProgress() {
    final currentLocation = configService.getLocation(gameState.currentLocation);
    if (currentLocation == null) return 0.0;

    return (gameState.locationSaturation / currentLocation.saturationRequired)
        .clamp(0.0, 1.0);
  }

  /// Check if at final location
  bool isAtFinalLocation() {
    final nextLocation = configService.getLocation(gameState.currentLocation + 1);
    return nextLocation == null;
  }
}
