/// Game location definition
class GameLocation {
  final int id;
  final String name;
  final String description;
  final double saturationRequired;
  final String backgroundPath;
  final List<String> characterPaths;

  const GameLocation({
    required this.id,
    required this.name,
    required this.description,
    required this.saturationRequired,
    required this.backgroundPath,
    this.characterPaths = const [],
  });

  /// Create from JSON
  factory GameLocation.fromJson(Map<String, dynamic> json) {
    return GameLocation(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      saturationRequired: (json['saturationRequired'] as num).toDouble(),
      backgroundPath: json['backgroundPath'],
      characterPaths: (json['characterPaths'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'saturationRequired': saturationRequired,
      'backgroundPath': backgroundPath,
      'characterPaths': characterPaths,
    };
  }
}
