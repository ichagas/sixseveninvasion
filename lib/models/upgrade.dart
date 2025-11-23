/// Types of upgrades available
enum UpgradeType {
  tapMultiplier,
  passiveGenerator,
}

/// Upgrade definition
class Upgrade {
  final String id;
  final String name;
  final String description;
  final UpgradeType type;
  final double baseCost;
  final double costMultiplier;
  final double baseEffect;
  final double effectMultiplier;
  final int requiredLocation;
  final String? iconPath;

  const Upgrade({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.baseCost,
    this.costMultiplier = 1.15,
    required this.baseEffect,
    this.effectMultiplier = 1.0,
    this.requiredLocation = 0,
    this.iconPath,
  });

  /// Calculate cost for specific level
  double getCost(int currentLevel) {
    return baseCost * (costMultiplier * currentLevel);
  }

  /// Calculate effect for specific level
  double getEffect(int currentLevel) {
    if (type == UpgradeType.passiveGenerator) {
      // Passive generators scale linearly with level
      return baseEffect * currentLevel;
    } else {
      // Tap multipliers add the base effect per level
      return baseEffect * (currentLevel + 1);
    }
  }

  /// Create from JSON
  factory Upgrade.fromJson(Map<String, dynamic> json) {
    return Upgrade(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: UpgradeType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => UpgradeType.tapMultiplier,
      ),
      baseCost: (json['baseCost'] as num).toDouble(),
      costMultiplier: (json['costMultiplier'] as num?)?.toDouble() ?? 1.15,
      baseEffect: (json['baseEffect'] as num).toDouble(),
      effectMultiplier: (json['effectMultiplier'] as num?)?.toDouble() ?? 1.0,
      requiredLocation: json['requiredLocation'] ?? 0,
      iconPath: json['iconPath'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      'baseCost': baseCost,
      'costMultiplier': costMultiplier,
      'baseEffect': baseEffect,
      'effectMultiplier': effectMultiplier,
      'requiredLocation': requiredLocation,
      'iconPath': iconPath,
    };
  }
}
