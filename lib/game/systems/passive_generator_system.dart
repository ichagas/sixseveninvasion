import 'package:flame/components.dart';
import '../../models/game_state.dart';
import '../../models/upgrade.dart';
import '../../services/game_config_service.dart';

/// System that handles passive energy generation
class PassiveGeneratorSystem extends Component {
  final GameState gameState;
  final GameConfigService configService;

  static const double _updateInterval = 1.0; // Update every second
  double _elapsed = 0.0;

  PassiveGeneratorSystem({
    required this.gameState,
    required this.configService,
  });

  @override
  void update(double dt) {
    super.update(dt);

    _elapsed += dt;

    if (_elapsed >= _updateInterval) {
      _generatePassiveEnergy();
      _elapsed = 0.0;
    }
  }

  void _generatePassiveEnergy() {
    double totalEPS = 0.0;

    // Calculate energy per second from all passive generators
    for (final entry in gameState.upgradeLevels.entries) {
      final upgrade = configService.getUpgrade(entry.key);
      if (upgrade == null) continue;

      if (upgrade.type == UpgradeType.passiveGenerator) {
        final level = entry.value;
        totalEPS += upgrade.getEffect(level);
      }
    }

    // Check for resistance events that affect passive income
    bool paused = false;
    double reductionMultiplier = 1.0;

    for (final eventId in gameState.activeEvents.keys) {
      if (!gameState.isEventActive(eventId)) continue;

      final event = configService.getEvent(eventId);
      if (event == null) continue;

      switch (event.effectType) {
        case EventEffectType.pausePassiveIncome:
          paused = true;
          break;
        case EventEffectType.reducePassiveIncome:
          reductionMultiplier *= (1.0 - event.effectStrength);
          break;
        default:
          break;
      }
    }

    if (!paused && totalEPS > 0) {
      final effectiveEPS = totalEPS * reductionMultiplier;
      gameState.addPassiveEnergy(effectiveEPS);
      gameState.updateEPS(effectiveEPS);
    } else {
      gameState.updateEPS(0.0);
    }
  }
}
