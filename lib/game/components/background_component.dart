import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../models/game_state.dart';
import '../../services/game_config_service.dart';

/// Background component that changes based on location
class BackgroundComponent extends PositionComponent with HasGameRef {
  final GameState gameState;
  final GameConfigService configService;

  int _currentLocationId = 0;

  BackgroundComponent({
    required this.gameState,
    required this.configService,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Set size to match game size
    size = gameRef.size;

    // Listen for location changes
    gameState.addListener(_onLocationChanged);
    _updateBackground();
  }

  @override
  void onRemove() {
    gameState.removeListener(_onLocationChanged);
    super.onRemove();
  }

  void _onLocationChanged() {
    if (_currentLocationId != gameState.currentLocation) {
      _currentLocationId = gameState.currentLocation;
      _updateBackground();
    }
  }

  void _updateBackground() {
    // Remove all existing children
    removeAll(children);

    // Get current location
    final location = configService.getLocation(_currentLocationId);
    if (location == null) return;

    // For now, use colored rectangles as placeholders
    // In production, load actual sprite images
    final bgColor = _getLocationColor(_currentLocationId);

    add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = bgColor,
      ),
    );
  }

  Color _getLocationColor(int locationId) {
    switch (locationId) {
      case 0: // Classroom
        return const Color(0xFFE8DCC4); // Beige
      case 1: // Gym
        return const Color(0xFF90C1E0); // Light blue
      case 2: // Street
        return const Color(0xFFB0B0B0); // Gray
      case 3: // Internet
        return const Color(0xFF1A1A2E); // Dark purple
      default:
        return const Color(0xFF87CEEB); // Sky blue
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw location name text
    final location = configService.getLocation(_currentLocationId);
    if (location != null) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: location.name.toUpperCase(),
          style: TextStyle(
            color: Colors.white.withOpacity(0.2),
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          (size.x - textPainter.width) / 2,
          size.y * 0.3,
        ),
      );
    }
  }
}
