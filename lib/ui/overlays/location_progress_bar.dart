import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';
import '../../services/game_config_service.dart';

/// Shows progress toward next location
class LocationProgressBar extends StatelessWidget {
  final GameConfigService configService;

  const LocationProgressBar({
    super.key,
    required this.configService,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        final currentLocation = configService.getLocation(gameState.currentLocation);
        final nextLocation = configService.getLocation(gameState.currentLocation + 1);

        if (currentLocation == null) return const SizedBox.shrink();

        final progress = (gameState.locationSaturation / currentLocation.saturationRequired)
            .clamp(0.0, 1.0);
        final isMaxLocation = nextLocation == null;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Location info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.yellow.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        currentLocation.name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (!isMaxLocation)
                    Text(
                      'Next: ${nextLocation.name}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // Progress bar
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.yellow.shade700,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: [
                      // Progress fill
                      FractionallySizedBox(
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade400,
                                Colors.yellow.shade600,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Progress text
                      Center(
                        child: Text(
                          isMaxLocation
                              ? 'MAX LOCATION'
                              : '${(progress * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
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
}
