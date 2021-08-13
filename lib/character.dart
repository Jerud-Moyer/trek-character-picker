class Character {
  final String id;
  final String name;
  final String affiliation;
  final String origin;
  final String race;
  final String imageUrl;

  Character({
    required this.id,
    required this.name,
    required this.affiliation,
    required this.origin,
    required this.race,
    required this.imageUrl,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      affiliation: json['affiliation'],
      origin: json['origin'],
      race: json['race'],
      imageUrl: json['imageUrl'],
    );
  }
}