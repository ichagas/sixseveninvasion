/// Clout upgrade (permanent prestige upgrade)
class CloutUpgrade {
  final String id;
  final String name;
  final String description;
  final int cloutCost;
  final double multiplier; // Multiplier bonus
  final String effectType; // 'tap', 'passive', 'all'

  const CloutUpgrade({
    required this.id,
    required this.name,
    required this.description,
    required this.cloutCost,
    required this.multiplier,
    required this.effectType,
  });

  /// Create from JSON
  factory CloutUpgrade.fromJson(Map<String, dynamic> json) {
    return CloutUpgrade(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      cloutCost: json['cloutCost'],
      multiplier: (json['multiplier'] as num).toDouble(),
      effectType: json['effectType'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cloutCost': cloutCost,
      'multiplier': multiplier,
      'effectType': effectType,
    };
  }
}
