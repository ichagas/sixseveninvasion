import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../services/audio_service.dart';
import '../services/game_config_service.dart';
import 'components/tap_particle.dart';
import 'components/background_component.dart';
import 'components/character_component.dart';
import 'systems/passive_generator_system.dart';
import 'systems/upgrade_manager.dart';
import 'systems/location_progression_system.dart';
import 'systems/resistance_event_system.dart';

/// Main game class for 6-7 Invasion
class SixSevenGame extends FlameGame {
  final GameState gameState;
  final AudioService audioService;
  final GameConfigService configService;
  final Function(String eventId)? onEventTriggered;

  late PassiveGeneratorSystem passiveSystem;
  late UpgradeManager upgradeManager;
  late LocationProgressionSystem locationSystem;
  late ResistanceEventSystem eventSystem;

  SixSevenGame({
    required this.gameState,
    required this.audioService,
    required this.configService,
    this.onEventTriggered,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add background component (replaces static backdrop)
    await add(
      BackgroundComponent(
        gameState: gameState,
        configService: configService,
      ),
    );

    // Add character/NPC sprites
    await add(
      CharacterComponent(
        gameState: gameState,
        configService: configService,
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

    locationSystem = LocationProgressionSystem(
      gameState: gameState,
      configService: configService,
      audioService: audioService,
    );
    await add(locationSystem);

    eventSystem = ResistanceEventSystem(
      gameState: gameState,
      configService: configService,
      audioService: audioService,
      onEventTriggered: onEventTriggered,
    );
    await add(eventSystem);
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
