import 'package:flame/components.dart';
import '../../models/game_state.dart';
import '../../models/upgrade.dart';
import '../../models/resistance_event.dart';
import '../../services/game_config_service.dart';

/// Manages upgrade effects and calculations
class UpgradeManager extends Component {
  final GameState gameState;
  final GameConfigService configService;

  UpgradeManager({
    required this.gameState,
    required this.configService,
  });

  /// Purchase an upgrade
  bool purchaseUpgrade(String upgradeId) {
    final upgrade = configService.getUpgrade(upgradeId);
    if (upgrade == null) return false;

    // Check if upgrade is unlocked
    if (upgrade.requiredLocation > gameState.currentLocation) {
      return false;
    }

    final currentLevel = gameState.getUpgradeLevel(upgradeId);
    double cost = upgrade.getCost(currentLevel);

    // Apply event cost modifiers
    for (final eventId in gameState.activeEvents.keys) {
      if (!gameState.isEventActive(eventId)) continue;

      final event = configService.getEvent(eventId);
      if (event == null) continue;

      if (event.effectType == EventEffectType.increaseUpgradeCosts) {
        cost *= (1.0 + event.effectStrength);
      }
    }

    // Try to purchase
    if (gameState.purchaseUpgrade(upgradeId, cost)) {
      _recalculateTapPower();
      return true;
    }

    return false;
  }

  /// Recalculate tap power from all upgrades
  void _recalculateTapPower() {
    double totalTapPower = 1.0; // Base tap power

    for (final entry in gameState.upgradeLevels.entries) {
      final upgrade = configService.getUpgrade(entry.key);
      if (upgrade == null) continue;

      if (upgrade.type == UpgradeType.tapMultiplier) {
        final level = entry.value;
        totalTapPower += upgrade.getEffect(level);
      }
    }

    // Apply resistance event modifiers
    double eventMultiplier = 1.0;
    for (final eventId in gameState.activeEvents.keys) {
      if (!gameState.isEventActive(eventId)) continue;

      final event = configService.getEvent(eventId);
      if (event == null) continue;

      if (event.effectType == EventEffectType.reduceTapPower) {
        eventMultiplier *= (1.0 - event.effectStrength);
      }
    }

    gameState.updateTapPower(totalTapPower * eventMultiplier);
  }

  /// Get cost for purchasing an upgrade
  double getUpgradeCost(String upgradeId) {
    final upgrade = configService.getUpgrade(upgradeId);
    if (upgrade == null) return double.infinity;

    final currentLevel = gameState.getUpgradeLevel(upgradeId);
    double cost = upgrade.getCost(currentLevel);

    // Apply event cost modifiers
    for (final eventId in gameState.activeEvents.keys) {
      if (!gameState.isEventActive(eventId)) continue;

      final event = configService.getEvent(eventId);
      if (event == null) continue;

      if (event.effectType == EventEffectType.increaseUpgradeCosts) {
        cost *= (1.0 + event.effectStrength);
      }
    }

    return cost;
  }

  /// Check if upgrade is available for purchase
  bool isUpgradeAvailable(String upgradeId) {
    final upgrade = configService.getUpgrade(upgradeId);
    if (upgrade == null) return false;

    return upgrade.requiredLocation <= gameState.currentLocation;
  }
}
