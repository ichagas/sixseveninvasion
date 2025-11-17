import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../models/game_state.dart';
import '../../services/game_config_service.dart';

/// Simple character/NPC that appears based on location
class CharacterComponent extends PositionComponent with HasGameRef {
  final GameState gameState;
  final GameConfigService configService;

  int _currentLocationId = 0;
  final List<_Character> _characters = [];
  final Random _random = Random();

  CharacterComponent({
    required this.gameState,
    required this.configService,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    size = gameRef.size;
    gameState.addListener(_onLocationChanged);
    _spawnCharacters();
  }

  @override
  void onRemove() {
    gameState.removeListener(_onLocationChanged);
    super.onRemove();
  }

  void _onLocationChanged() {
    if (_currentLocationId != gameState.currentLocation) {
      _currentLocationId = gameState.currentLocation;
      _spawnCharacters();
    }
  }

  void _spawnCharacters() {
    _characters.clear();

    // Spawn 2-4 characters based on location
    final characterCount = 2 + _random.nextInt(3);

    for (int i = 0; i < characterCount; i++) {
      _characters.add(
        _Character(
          emoji: _getLocationEmoji(_currentLocationId),
          position: Vector2(
            _random.nextDouble() * size.x,
            size.y * 0.4 + _random.nextDouble() * size.y * 0.3,
          ),
          size: 40.0 + _random.nextDouble() * 20.0,
        ),
      );
    }
  }

  String _getLocationEmoji(int locationId) {
    switch (locationId) {
      case 0: // Classroom
        final emojis = ['👨‍🎓', '👩‍🎓', '📚', '✏️', '🎒'];
        return emojis[_random.nextInt(emojis.length)];
      case 1: // Gym
        final emojis = ['🏃', '🏋️', '⚽', '🏀', '🤸'];
        return emojis[_random.nextInt(emojis.length)];
      case 2: // Street
        final emojis = ['🚶', '🚗', '🛴', '🚦', '🏪'];
        return emojis[_random.nextInt(emojis.length)];
      case 3: // Internet
        final emojis = ['💻', '📱', '🌐', '🤖', '👾'];
        return emojis[_random.nextInt(emojis.length)];
      default:
        return '👤';
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Simple bobbing animation
    for (final character in _characters) {
      character.time += dt;
      character.offset = sin(character.time * 2) * 5;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    for (final character in _characters) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: character.emoji,
          style: TextStyle(
            fontSize: character.size,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      // Apply bobbing offset
      final renderPosition = Offset(
        character.position.x - textPainter.width / 2,
        character.position.y - textPainter.height / 2 + character.offset,
      );

      textPainter.paint(canvas, renderPosition);
    }
  }
}

class _Character {
  final String emoji;
  final Vector2 position;
  final double size;
  double time = 0.0;
  double offset = 0.0;

  _Character({
    required this.emoji,
    required this.position,
    required this.size,
  });
}
