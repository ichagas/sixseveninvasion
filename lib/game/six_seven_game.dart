import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../services/audio_service.dart';
import '../services/game_config_service.dart';
import 'components/tap_particle.dart';
import 'systems/passive_generator_system.dart';
import 'systems/upgrade_manager.dart';

/// Main game class for 6-7 Invasion
class SixSevenGame extends FlameGame {
  final GameState gameState;
  final AudioService audioService;
  final GameConfigService configService;

  late PassiveGeneratorSystem passiveSystem;
  late UpgradeManager upgradeManager;

  SixSevenGame({
    required this.gameState,
    required this.audioService,
    required this.configService,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Initialize background color
    camera.backdrop.add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = const Color(0xFF87CEEB), // Sky blue
      ),
    );

    // Initialize systems
    passiveSystem = PassiveGeneratorSystem(
      gameState: gameState,
      configService: configService,
    );
    await add(passiveSystem);

    upgradeManager = UpgradeManager(
      gameState: gameState,
      configService: configService,
    );
    await add(upgradeManager);
  }

  @override
  void onTapDown(TapDownInfo info) {
    // Add energy from tap
    gameState.tap();

    // Play tap sound
    audioService.playTap();

    // Create particle effect at tap position
    add(
      TapParticle(
        position: info.eventPosition.global,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Clean up expired events
    gameState.cleanupEvents();
  }
}
