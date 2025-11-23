import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';
import '../../models/upgrade.dart';
import '../../services/game_config_service.dart';
import '../../services/audio_service.dart';
import '../../game/systems/upgrade_manager.dart';
import '../../utils/number_formatter.dart';

/// Shop panel for purchasing upgrades
class ShopPanel extends StatelessWidget {
  final UpgradeManager upgradeManager;
  final GameConfigService configService;
  final AudioService audioService;

  const ShopPanel({
    super.key,
    required this.upgradeManager,
    required this.configService,
    required this.audioService,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.yellow, width: 2),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.shopping_cart, color: Colors.yellow),
                const SizedBox(width: 12),
                const Text(
                  'UPGRADES',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Upgrades list
          Expanded(
            child: Consumer<GameState>(
              builder: (context, gameState, child) {
                final upgrades = configService.upgrades;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: upgrades.length,
                  itemBuilder: (context, index) {
                    final upgrade = upgrades[index];
                    return _UpgradeCard(
                      upgrade: upgrade,
                      gameState: gameState,
                      upgradeManager: upgradeManager,
                      audioService: audioService,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _UpgradeCard extends StatelessWidget {
  final Upgrade upgrade;
  final GameState gameState;
  final UpgradeManager upgradeManager;
  final AudioService audioService;

  const _UpgradeCard({
    required this.upgrade,
    required this.gameState,
    required this.upgradeManager,
    required this.audioService,
  });

  @override
  Widget build(BuildContext context) {
    final currentLevel = gameState.getUpgradeLevel(upgrade.id);
    final cost = upgradeManager.getUpgradeCost(upgrade.id);
    final canAfford = gameState.energy >= cost;
    final isAvailable = upgradeManager.isUpgradeAvailable(upgrade.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isAvailable
          ? (canAfford ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.2))
          : Colors.red.withOpacity(0.1),
      child: InkWell(
        onTap: isAvailable && canAfford
            ? () {
                if (upgradeManager.purchaseUpgrade(upgrade.id)) {
                  audioService.playPurchase();
                }
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          upgrade.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          upgrade.description,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Lv. $currentLevel',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cost
                  Row(
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        color: Colors.yellow,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        NumberFormatter.format(cost),
                        style: TextStyle(
                          color: canAfford ? Colors.yellow : Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Effect
                  Text(
                    upgrade.type == UpgradeType.tapMultiplier
                        ? '+${NumberFormatter.formatDetailed(upgrade.baseEffect)} per tap'
                        : '+${NumberFormatter.formatDetailed(upgrade.baseEffect)}/sec',
                    style: TextStyle(
                      color: Colors.greenAccent.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              if (!isAvailable)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Unlocks at Location ${upgrade.requiredLocation}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
