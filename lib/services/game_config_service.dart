import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/upgrade.dart';
import '../models/location.dart';
import '../models/resistance_event.dart';
import '../models/clout_upgrade.dart';

/// Loads and manages game configuration from JSON files
class GameConfigService {
  List<Upgrade> _upgrades = [];
  List<GameLocation> _locations = [];
  List<ResistanceEvent> _events = [];
  List<CloutUpgrade> _cloutUpgrades = [];

  List<Upgrade> get upgrades => List.unmodifiable(_upgrades);
  List<GameLocation> get locations => List.unmodifiable(_locations);
  List<ResistanceEvent> get events => List.unmodifiable(_events);
  List<CloutUpgrade> get cloutUpgrades => List.unmodifiable(_cloutUpgrades);

  /// Load all configuration files
  Future<void> loadConfigs() async {
    await Future.wait([
      _loadUpgrades(),
      _loadLocations(),
      _loadEvents(),
      _loadCloutUpgrades(),
    ]);
  }

  /// Load upgrades from JSON
  Future<void> _loadUpgrades() async {
    try {
      final jsonString = await rootBundle.loadString('lib/config/upgrades.json');
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final upgradeList = json['upgrades'] as List<dynamic>;

      _upgrades = upgradeList
          .map((e) => Upgrade.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading upgrades: $e');
      _upgrades = _getDefaultUpgrades();
    }
  }

  /// Load locations from JSON
  Future<void> _loadLocations() async {
    try {
      final jsonString = await rootBundle.loadString('lib/config/locations.json');
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final locationList = json['locations'] as List<dynamic>;

      _locations = locationList
          .map((e) => GameLocation.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading locations: $e');
      _locations = _getDefaultLocations();
    }
  }

  /// Load events from JSON
  Future<void> _loadEvents() async {
    try {
      final jsonString = await rootBundle.loadString('lib/config/events.json');
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final eventList = json['events'] as List<dynamic>;

      _events = eventList
          .map((e) => ResistanceEvent.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading events: $e');
      _events = _getDefaultEvents();
    }
  }

  /// Load clout upgrades from JSON
  Future<void> _loadCloutUpgrades() async {
    try {
      final jsonString = await rootBundle.loadString('lib/config/clout_upgrades.json');
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final upgradeList = json['cloutUpgrades'] as List<dynamic>;

      _cloutUpgrades = upgradeList
          .map((e) => CloutUpgrade.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading clout upgrades: $e');
      _cloutUpgrades = _getDefaultCloutUpgrades();
    }
  }

  /// Get upgrade by ID
  Upgrade? getUpgrade(String id) {
    try {
      return _upgrades.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get location by ID
  GameLocation? getLocation(int id) {
    try {
      return _locations.firstWhere((l) => l.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get event by ID
  ResistanceEvent? getEvent(String id) {
    try {
      return _events.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get clout upgrade by ID
  CloutUpgrade? getCloutUpgrade(String id) {
    try {
      return _cloutUpgrades.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Default upgrades if JSON fails to load
  List<Upgrade> _getDefaultUpgrades() {
    return [
      const Upgrade(
        id: 'finger_guns',
        name: 'Finger Guns',
        description: 'Double tap power',
        type: UpgradeType.tapMultiplier,
        baseCost: 10,
        baseEffect: 1,
      ),
      const Upgrade(
        id: 'bot_army',
        name: 'Bot Army',
        description: 'Auto-generate 1 energy/sec',
        type: UpgradeType.passiveGenerator,
        baseCost: 50,
        baseEffect: 1,
      ),
    ];
  }

  /// Default locations if JSON fails to load
  List<GameLocation> _getDefaultLocations() {
    return [
      const GameLocation(
        id: 0,
        name: 'Classroom',
        description: 'Where it all began',
        saturationRequired: 100,
        backgroundPath: 'assets/images/bg_classroom.png',
      ),
      const GameLocation(
        id: 1,
        name: 'Gym',
        description: 'Spreading to the sports crowd',
        saturationRequired: 1000,
        backgroundPath: 'assets/images/bg_gym.png',
      ),
    ];
  }

  /// Default events if JSON fails to load
  List<ResistanceEvent> _getDefaultEvents() {
    return [
      const ResistanceEvent(
        id: 'teacher_silencer',
        name: 'Teacher Silencer',
        description: 'Teacher reduces your influence',
        effectType: EventEffectType.reduceTapPower,
        effectStrength: 0.5,
        duration: Duration(seconds: 30),
      ),
    ];
  }

  /// Default clout upgrades if JSON fails to load
  List<CloutUpgrade> _getDefaultCloutUpgrades() {
    return [
      const CloutUpgrade(
        id: 'clout_all_boost',
        name: 'Meme Lord',
        description: 'Permanent +25% to all energy',
        cloutCost: 2,
        multiplier: 0.25,
        effectType: 'all',
      ),
    ];
  }
}
