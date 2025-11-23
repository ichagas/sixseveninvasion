/// Achievement definition
class Achievement {
  final String id;
  final String name;
  final String description;
  final String iconName; // Icon identifier
  final AchievementType type;
  final double target; // Target value to unlock
  final int rewardClout; // Clout reward

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.type,
    required this.target,
    this.rewardClout = 0,
  });

  /// Create from JSON
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      iconName: json['iconName'] ?? 'trophy',
      type: AchievementType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AchievementType.milestone,
      ),
      target: (json['target'] as num).toDouble(),
      rewardClout: json['rewardClout'] ?? 0,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconName': iconName,
      'type': type.name,
      'target': target,
      'rewardClout': rewardClout,
    };
  }
}

/// Types of achievements
enum AchievementType {
  milestone,      // One-time milestones (reach location X)
  cumulative,     // Cumulative stats (10K total taps)
  prestige,       // Prestige-related
  speed,          // Time-based challenges
  collection,     // Collect all X
}
