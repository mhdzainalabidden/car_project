class Country {
  final int id;
  final String country;
  final String abbreviation;

  const Country({
    required this.id,
    required this.country,
    required this.abbreviation,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] as int,
      country: json['country'] as String,
      abbreviation: json['abbreviation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'country': country, 'abbreviation': abbreviation};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Country && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => country;
}
