import 'package:flutter/foundation.dart';

/// Main game state holding all player progress and statistics
class GameState extends ChangeNotifier {
  // Core resources
  double _energy = 0.0;
  double _energyPerSecond = 0.0;
  double _tapPower = 1.0;

  // Progression
  int _currentLocation = 0;
  double _locationSaturation = 0.0;

  // Prestige
  int _clout = 0;
  double _cloutMultiplier = 1.0;
  int _totalResets = 0;

  // Purchased upgrades (upgrade ID -> level)
  final Map<String, int> _upgradeLevels = {};

  // Purchased clout upgrades (clout upgrade IDs)
  final Set<String> _cloutUpgrades = {};

  // Active resistance events (event ID -> end timestamp)
  final Map<String, DateTime> _activeEvents = {};

  // Achievements (unlocked achievement IDs)
  final Set<String> _unlockedAchievements = {};

  // Statistics
  int _totalTaps = 0;
  double _totalEnergyGenerated = 0.0;
  int _eventsSurvived = 0;
  DateTime _gameStartTime = DateTime.now();
  DateTime _lastOfflineTime = DateTime.now();

  // Getters
  double get energy => _energy;
  double get energyPerSecond => _energyPerSecond;
  double get tapPower => _tapPower;
  int get currentLocation => _currentLocation;
  double get locationSaturation => _locationSaturation;
  int get clout => _clout;
  double get cloutMultiplier => _cloutMultiplier;
  int get totalResets => _totalResets;
  Map<String, int> get upgradeLevels => Map.unmodifiable(_upgradeLevels);
  Set<String> get cloutUpgrades => Set.unmodifiable(_cloutUpgrades);
  Map<String, DateTime> get activeEvents => Map.unmodifiable(_activeEvents);
  Set<String> get unlockedAchievements => Set.unmodifiable(_unlockedAchievements);
  int get totalTaps => _totalTaps;
  double get totalEnergyGenerated => _totalEnergyGenerated;
  int get eventsSurvived => _eventsSurvived;
  DateTime get gameStartTime => _gameStartTime;
  DateTime get lastOfflineTime => _lastOfflineTime;

  /// Add energy from tap
  void tap() {
    final effectiveTapPower = _tapPower * _cloutMultiplier;
    _energy += effectiveTapPower;
    _totalEnergyGenerated += effectiveTapPower;
    _totalTaps++;
    _locationSaturation += effectiveTapPower;
    notifyListeners();
  }

  /// Add passive energy (called from timer)
  void addPassiveEnergy(double amount) {
    final effectiveAmount = amount * _cloutMultiplier;
    _energy += effectiveAmount;
    _totalEnergyGenerated += effectiveAmount;
    _locationSaturation += effectiveAmount;
    notifyListeners();
  }

  /// Recalculate energy per second based on upgrades
  void recalculateEPS() {
    // Will be calculated based on owned upgrades
    // For now, placeholder
    notifyListeners();
  }

  /// Purchase an upgrade
  bool purchaseUpgrade(String upgradeId, double cost) {
    if (_energy >= cost) {
      _energy -= cost;
      _upgradeLevels[upgradeId] = (_upgradeLevels[upgradeId] ?? 0) + 1;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Get upgrade level
  int getUpgradeLevel(String upgradeId) {
    return _upgradeLevels[upgradeId] ?? 0;
  }

  /// Progress to next location
  void advanceLocation() {
    _currentLocation++;
    _locationSaturation = 0.0;
    notifyListeners();
  }

  /// Add resistance event
  void addEvent(String eventId, Duration duration) {
    _activeEvents[eventId] = DateTime.now().add(duration);
    notifyListeners();
  }

  /// Remove expired events
  void cleanupEvents() {
    final now = DateTime.now();
    final expiredCount = _activeEvents.values.where((time) => time.isBefore(now)).length;
    _eventsSurvived += expiredCount;
    _activeEvents.removeWhere((key, value) => value.isBefore(now));
    if (expiredCount > 0) {
      notifyListeners();
    }
  }

  /// Check if event is active
  bool isEventActive(String eventId) {
    final endTime = _activeEvents[eventId];
    if (endTime == null) return false;
    return DateTime.now().isBefore(endTime);
  }

  /// Purchase clout upgrade
  bool purchaseCloutUpgrade(String upgradeId, int cloutCost) {
    if (_clout >= cloutCost && !_cloutUpgrades.contains(upgradeId)) {
      _clout -= cloutCost;
      _cloutUpgrades.add(upgradeId);
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Check if clout upgrade is purchased
  bool hasCloutUpgrade(String upgradeId) {
    return _cloutUpgrades.contains(upgradeId);
  }

  /// Unlock achievement
  bool unlockAchievement(String achievementId, {int cloutReward = 0}) {
    if (!_unlockedAchievements.contains(achievementId)) {
      _unlockedAchievements.add(achievementId);
      if (cloutReward > 0) {
        _clout += cloutReward;
      }
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Check if achievement is unlocked
  bool hasAchievement(String achievementId) {
    return _unlockedAchievements.contains(achievementId);
  }

  /// Update last offline time (called when app resumes)
  void updateOfflineTime() {
    _lastOfflineTime = DateTime.now();
    notifyListeners();
  }

  /// Calculate clout earned from prestige
  int calculateCloutGain() {
    // Clout based on location reached (1 per location past first)
    return _currentLocation > 0 ? _currentLocation : 0;
  }

  /// Prestige reset
  void prestige(int cloutGained) {
    _clout += cloutGained;
    _totalResets++;

    // Reset progress
    _energy = 0.0;
    _currentLocation = 0;
    _locationSaturation = 0.0;
    _upgradeLevels.clear();
    _activeEvents.clear();
    // Note: clout upgrades persist!

    notifyListeners();
  }

  /// Update tap power (from upgrades)
  void updateTapPower(double newTapPower) {
    _tapPower = newTapPower;
    notifyListeners();
  }

  /// Update EPS (from upgrades)
  void updateEPS(double newEPS) {
    _energyPerSecond = newEPS;
    notifyListeners();
  }

  /// Convert to JSON for saving
  Map<String, dynamic> toJson() {
    return {
      'energy': _energy,
      'energyPerSecond': _energyPerSecond,
      'tapPower': _tapPower,
      'currentLocation': _currentLocation,
      'locationSaturation': _locationSaturation,
      'clout': _clout,
      'cloutMultiplier': _cloutMultiplier,
      'totalResets': _totalResets,
      'upgradeLevels': _upgradeLevels,
      'cloutUpgrades': _cloutUpgrades.toList(),
      'activeEvents': _activeEvents.map((k, v) => MapEntry(k, v.toIso8601String())),
      'unlockedAchievements': _unlockedAchievements.toList(),
      'totalTaps': _totalTaps,
      'totalEnergyGenerated': _totalEnergyGenerated,
      'eventsSurvived': _eventsSurvived,
      'gameStartTime': _gameStartTime.toIso8601String(),
      'lastOfflineTime': _lastOfflineTime.toIso8601String(),
    };
  }

  /// Load from JSON
  void fromJson(Map<String, dynamic> json) {
    _energy = json['energy'] ?? 0.0;
    _energyPerSecond = json['energyPerSecond'] ?? 0.0;
    _tapPower = json['tapPower'] ?? 1.0;
    _currentLocation = json['currentLocation'] ?? 0;
    _locationSaturation = json['locationSaturation'] ?? 0.0;
    _clout = json['clout'] ?? 0;
    _cloutMultiplier = json['cloutMultiplier'] ?? 1.0;
    _totalResets = json['totalResets'] ?? 0;
    _totalTaps = json['totalTaps'] ?? 0;
    _totalEnergyGenerated = json['totalEnergyGenerated'] ?? 0.0;
    _eventsSurvived = json['eventsSurvived'] ?? 0;

    if (json['upgradeLevels'] != null) {
      _upgradeLevels.clear();
      _upgradeLevels.addAll(Map<String, int>.from(json['upgradeLevels']));
    }

    if (json['cloutUpgrades'] != null) {
      _cloutUpgrades.clear();
      _cloutUpgrades.addAll(List<String>.from(json['cloutUpgrades']));
    }

    if (json['unlockedAchievements'] != null) {
      _unlockedAchievements.clear();
      _unlockedAchievements.addAll(List<String>.from(json['unlockedAchievements']));
    }

    if (json['activeEvents'] != null) {
      _activeEvents.clear();
      (json['activeEvents'] as Map<String, dynamic>).forEach((k, v) {
        _activeEvents[k] = DateTime.parse(v);
      });
    }

    if (json['gameStartTime'] != null) {
      _gameStartTime = DateTime.parse(json['gameStartTime']);
    }

    if (json['lastOfflineTime'] != null) {
      _lastOfflineTime = DateTime.parse(json['lastOfflineTime']);
    }

    notifyListeners();
  }
}
