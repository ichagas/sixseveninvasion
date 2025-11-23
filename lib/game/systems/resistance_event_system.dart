import 'dart:math';
import 'package:flame/components.dart';
import '../../models/game_state.dart';
import '../../services/game_config_service.dart';
import '../../services/audio_service.dart';

/// System that triggers resistance events
class ResistanceEventSystem extends Component {
  final GameState gameState;
  final GameConfigService configService;
  final AudioService audioService;
  final Function(String eventId)? onEventTriggered;

  static const double _minTimeBetweenEvents = 30.0; // 30 seconds minimum
  static const double _maxTimeBetweenEvents = 90.0; // 90 seconds maximum
  static const double _eventChance = 0.3; // 30% chance when checking

  double _timeSinceLastEvent = 0.0;
  double _nextEventCheckTime = 0.0;
  final Random _random = Random();

  ResistanceEventSystem({
    required this.gameState,
    required this.configService,
    required this.audioService,
    this.onEventTriggered,
  }) {
    _scheduleNextCheck();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _timeSinceLastEvent += dt;

    // Check if it's time to potentially trigger an event
    if (_timeSinceLastEvent >= _nextEventCheckTime) {
      _checkTriggerEvent();
      _scheduleNextCheck();
    }
  }

  void _scheduleNextCheck() {
    _nextEventCheckTime = _minTimeBetweenEvents +
        _random.nextDouble() * (_maxTimeBetweenEvents - _minTimeBetweenEvents);
    _timeSinceLastEvent = 0.0;
  }

  void _checkTriggerEvent() {
    // Random chance to trigger event
    if (_random.nextDouble() > _eventChance) {
      return;
    }

    // Get available events for current location
    final availableEvents = configService.events
        .where((event) => event.minLocation <= gameState.currentLocation)
        .toList();

    if (availableEvents.isEmpty) return;

    // Pick a random event
    final event = availableEvents[_random.nextInt(availableEvents.length)];

    // Check if event is already active
    if (gameState.isEventActive(event.id)) return;

    // Trigger the event
    gameState.addEvent(event.id, event.duration);
    audioService.playEvent();

    // Notify listeners
    onEventTriggered?.call(event.id);
  }

  /// Manually trigger a specific event (for testing)
  void triggerEvent(String eventId) {
    final event = configService.getEvent(eventId);
    if (event == null) return;

    gameState.addEvent(eventId, event.duration);
    audioService.playEvent();
    onEventTriggered?.call(eventId);
  }
}
