import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';
import '../../services/game_config_service.dart';
import '../../utils/number_formatter.dart';

/// Statistics screen showing lifetime progress
class StatisticsScreen extends StatelessWidget {
  final GameConfigService configService;

  const StatisticsScreen({
    super.key,
    required this.configService,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.indigo.shade900,
            Colors.blue.shade800,
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
                bottom: BorderSide(color: Colors.cyanAccent, width: 3),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.bar_chart, color: Colors.cyanAccent, size: 32),
                const SizedBox(width: 12),
                const Text(
                  'STATISTICS',
                  style: TextStyle(
                    color: Colors.cyanAccent,
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
            child: Consumer<GameState>(
              builder: (context, gameState, child) {
                final playTime = DateTime.now().difference(gameState.gameStartTime);
                final currentLocation = configService.getLocation(gameState.currentLocation);

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Progress stats
                      _buildSection(
                        'Progression',
                        Icons.trending_up,
                        Colors.green,
                        [
                          _buildStat(
                            'Current Location',
                            currentLocation?.name ?? 'Unknown',
                            Icons.location_on,
                          ),
                          _buildStat(
                            'Total Clout',
                            gameState.clout.toString(),
                            Icons.star,
                          ),
                          _buildStat(
                            'Prestige Count',
                            gameState.totalResets.toString(),
                            Icons.replay,
                          ),
                          _buildStat(
                            'Clout Multiplier',
                            '${gameState.cloutMultiplier.toStringAsFixed(2)}x',
                            Icons.multiply,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Energy stats
                      _buildSection(
                        'Energy Generation',
                        Icons.bolt,
                        Colors.yellow,
                        [
                          _buildStat(
                            'Current Energy',
                            NumberFormatter.format(gameState.energy),
                            Icons.battery_charging_full,
                          ),
                          _buildStat(
                            'Total Generated',
                            NumberFormatter.format(gameState.totalEnergyGenerated),
                            Icons.all_inclusive,
                          ),
                          _buildStat(
                            'Energy Per Second',
                            NumberFormatter.format(gameState.energyPerSecond),
                            Icons.speed,
                          ),
                          _buildStat(
                            'Tap Power',
                            NumberFormatter.format(gameState.tapPower),
                            Icons.touch_app,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Activity stats
                      _buildSection(
                        'Activity',
                        Icons.mouse,
                        Colors.purple,
                        [
                          _buildStat(
                            'Total Taps',
                            NumberFormatter.format(gameState.totalTaps.toDouble()),
                            Icons.touch_app,
                          ),
                          _buildStat(
                            'Play Time',
                            _formatDuration(playTime),
                            Icons.access_time,
                          ),
                          _buildStat(
                            'Upgrades Owned',
                            gameState.upgradeLevels.length.toString(),
                            Icons.shopping_cart,
                          ),
                          _buildStat(
                            'Clout Upgrades',
                            '${gameState.cloutUpgrades.length}/5',
                            Icons.star_border,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Calculated stats
                      _buildSection(
                        'Records',
                        Icons.emoji_events,
                        Colors.amber,
                        [
                          _buildStat(
                            'Avg Energy/Tap',
                            gameState.totalTaps > 0
                                ? NumberFormatter.format(
                                    gameState.totalEnergyGenerated / gameState.totalTaps)
                                : '0',
                            Icons.calculate,
                          ),
                          _buildStat(
                            'Avg Energy/Second',
                            playTime.inSeconds > 0
                                ? NumberFormatter.format(
                                    gameState.totalEnergyGenerated / playTime.inSeconds)
                                : '0',
                            Icons.timer,
                          ),
                          _buildStat(
                            'Energy/Prestige',
                            gameState.totalResets > 0
                                ? NumberFormatter.format(
                                    gameState.totalEnergyGenerated / gameState.totalResets)
                                : 'N/A',
                            Icons.trending_up,
                          ),
                          _buildStat(
                            'Efficiency Score',
                            _calculateEfficiency(gameState).toStringAsFixed(1),
                            Icons.grade,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Color color, List<Widget> stats) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5), width: 2),
      ),
      child: Column(
        children: [
          // Section header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Stats
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: stats,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  double _calculateEfficiency(GameState gameState) {
    // Efficiency = (Total Energy / Play Time) * Clout Multiplier / Total Taps
    // Higher is better (more energy with fewer taps/time)
    final playTime = DateTime.now().difference(gameState.gameStartTime);
    if (playTime.inSeconds == 0 || gameState.totalTaps == 0) return 0;

    final energyPerSecond = gameState.totalEnergyGenerated / playTime.inSeconds;
    final energyPerTap = gameState.totalEnergyGenerated / gameState.totalTaps;

    return (energyPerSecond + energyPerTap) * gameState.cloutMultiplier / 100;
  }
}
