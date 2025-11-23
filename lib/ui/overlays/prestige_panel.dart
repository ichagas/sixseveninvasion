import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';
import '../../services/game_config_service.dart';
import '../../services/audio_service.dart';
import '../../utils/number_formatter.dart';

/// Prestige panel for resetting with Clout
class PrestigePanel extends StatelessWidget {
  final GameConfigService configService;
  final AudioService audioService;

  const PrestigePanel({
    super.key,
    required this.configService,
    required this.audioService,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        final cloutGain = gameState.calculateCloutGain();
        final canPrestige = cloutGain > 0;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.purple.shade900,
                Colors.deepPurple.shade800,
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.amber, width: 3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 32),
                    const SizedBox(width: 12),
                    const Text(
                      'PRESTIGE',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 28,
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
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Current stats
                      _buildStatsCard(gameState),
                      const SizedBox(height: 20),
                      // Prestige button
                      _buildPrestigeButton(context, gameState, cloutGain, canPrestige),
                      const SizedBox(height: 24),
                      // Clout upgrades
                      const Text(
                        'CLOUT UPGRADES',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...configService.cloutUpgrades.map((upgrade) {
                        return _buildCloutUpgradeCard(context, gameState, upgrade);
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsCard(GameState gameState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.5), width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Current Clout', gameState.clout.toString(), Icons.star),
              _buildStatItem('Total Resets', gameState.totalResets.toString(), Icons.replay),
            ],
          ),
          const Divider(color: Colors.amber, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Location',
                configService.getLocation(gameState.currentLocation)?.name ?? 'Unknown',
                Icons.location_on,
              ),
              _buildStatItem(
                'Total Taps',
                NumberFormatter.format(gameState.totalTaps.toDouble()),
                Icons.touch_app,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.amber, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildPrestigeButton(
    BuildContext context,
    GameState gameState,
    int cloutGain,
    bool canPrestige,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: canPrestige
            ? LinearGradient(
                colors: [Colors.amber.shade700, Colors.orange.shade600],
              )
            : const LinearGradient(
                colors: [Colors.grey, Colors.grey],
              ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: canPrestige
            ? [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          Text(
            canPrestige ? 'RESET FOR CLOUT' : 'REACH LOCATION 1+',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.white, size: 32),
              const SizedBox(width: 8),
              Text(
                '+$cloutGain CLOUT',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: canPrestige
                ? () => _showPrestigeConfirmation(context, gameState, cloutGain)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.amber.shade900,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            child: const Text('PRESTIGE NOW'),
          ),
          const SizedBox(height: 12),
          Text(
            'Reset all progress, keep Clout & upgrades',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloutUpgradeCard(
    BuildContext context,
    GameState gameState,
    dynamic upgrade,
  ) {
    final isPurchased = gameState.hasCloutUpgrade(upgrade.id);
    final canAfford = gameState.clout >= upgrade.cloutCost;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isPurchased
          ? Colors.green.withOpacity(0.3)
          : (canAfford ? Colors.amber.withOpacity(0.2) : Colors.grey.withOpacity(0.2)),
      child: InkWell(
        onTap: !isPurchased && canAfford
            ? () {
                if (gameState.purchaseCloutUpgrade(upgrade.id, upgrade.cloutCost)) {
                  audioService.playPurchase();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Purchased ${upgrade.name}!'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                isPurchased ? Icons.check_circle : Icons.star_border,
                color: isPurchased ? Colors.green : Colors.amber,
                size: 32,
              ),
              const SizedBox(width: 16),
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
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${upgrade.cloutCost}',
                        style: TextStyle(
                          color: isPurchased
                              ? Colors.green
                              : (canAfford ? Colors.amber : Colors.red),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (isPurchased)
                    const Text(
                      'OWNED',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrestigeConfirmation(BuildContext context, GameState gameState, int cloutGain) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.deepPurple.shade900,
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.amber),
            SizedBox(width: 12),
            Text('Confirm Prestige', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Text(
          'Are you sure you want to prestige?\n\n'
          'You will gain +$cloutGain Clout but lose all current progress:\n'
          '• Energy reset to 0\n'
          '• Location reset to Classroom\n'
          '• All upgrades lost\n\n'
          'Clout and Clout upgrades persist!',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              gameState.prestige(cloutGain);
              audioService.playLocationUnlock();
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close prestige panel
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Prestiged! Gained +$cloutGain Clout'),
                  backgroundColor: Colors.amber.shade900,
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            child: const Text('PRESTIGE'),
          ),
        ],
      ),
    );
  }
}
