import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';
import '../../services/game_config_service.dart';

/// Shows active resistance events
class EventNotifications extends StatelessWidget {
  final GameConfigService configService;

  const EventNotifications({
    super.key,
    required this.configService,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        final activeEvents = gameState.activeEvents.entries
            .where((entry) => gameState.isEventActive(entry.key))
            .toList();

        if (activeEvents.isEmpty) {
          return const SizedBox.shrink();
        }

        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Column(
              children: activeEvents.map((entry) {
                final eventId = entry.key;
                final endTime = entry.value;
                final event = configService.getEvent(eventId);

                if (event == null) return const SizedBox.shrink();

                final remainingSeconds = endTime.difference(DateTime.now()).inSeconds;

                return _EventCard(
                  eventName: event.name,
                  description: event.description,
                  remainingSeconds: remainingSeconds,
                  icon: _getEventIcon(event.effectType.name),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  IconData _getEventIcon(String effectType) {
    switch (effectType) {
      case 'reduceTapPower':
        return Icons.touch_app_outlined;
      case 'reducePassiveIncome':
        return Icons.trending_down;
      case 'pausePassiveIncome':
        return Icons.pause_circle_outline;
      case 'increaseUpgradeCosts':
        return Icons.trending_up;
      default:
        return Icons.warning;
    }
  }
}

class _EventCard extends StatelessWidget {
  final String eventName;
  final String description;
  final int remainingSeconds;
  final IconData icon;

  const _EventCard({
    required this.eventName,
    required this.description,
    required this.remainingSeconds,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade900.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.shade400,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.shade700,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // Event info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventName.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Timer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${remainingSeconds}s',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
