/// Types of resistance event effects
enum EventEffectType {
  reduceTapPower,
  reducePassiveIncome,
  pausePassiveIncome,
  increaseUpgradeCosts,
}

/// Resistance event definition
class ResistanceEvent {
  final String id;
  final String name;
  final String description;
  final EventEffectType effectType;
  final double effectStrength; // 0.0 to 1.0 (percentage reduction/increase)
  final Duration duration;
  final int minLocation;
  final String? iconPath;

  const ResistanceEvent({
    required this.id,
    required this.name,
    required this.description,
    required this.effectType,
    required this.effectStrength,
    required this.duration,
    this.minLocation = 0,
    this.iconPath,
  });

  /// Create from JSON
  factory ResistanceEvent.fromJson(Map<String, dynamic> json) {
    return ResistanceEvent(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      effectType: EventEffectType.values.firstWhere(
        (e) => e.name == json['effectType'],
        orElse: () => EventEffectType.reduceTapPower,
      ),
      effectStrength: (json['effectStrength'] as num).toDouble(),
      duration: Duration(seconds: json['durationSeconds']),
      minLocation: json['minLocation'] ?? 0,
      iconPath: json['iconPath'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'effectType': effectType.name,
      'effectStrength': effectStrength,
      'durationSeconds': duration.inSeconds,
      'minLocation': minLocation,
      'iconPath': iconPath,
    };
  }
}
