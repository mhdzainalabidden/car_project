import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final int id;
  final String country;
  final String abbreviation;

  const Country({
    required this.id,
    required this.country,
    required this.abbreviation,
  });

  @override
  List<Object?> get props => [id, country, abbreviation];

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      country: json['country'],
      abbreviation: json['abbreviation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'country': country, 'abbreviation': abbreviation};
  }
}

class User extends Equatable {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final bool phoneIsVerified;
  final Country country;

  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.phoneIsVerified,
    required this.country,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    phone,
    phoneIsVerified,
    country,
  ];

  User copyWith({
    int? id,
    String? fullName,
    String? email,
    String? phone,
    bool? phoneIsVerified,
    Country? country,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      phoneIsVerified: phoneIsVerified ?? this.phoneIsVerified,
      country: country ?? this.country,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'phone_is_verified': phoneIsVerified,
      'country': country.toJson(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      phone: json['phone'],
      phoneIsVerified: json['phone_is_verified'] ?? false,
      country: Country.fromJson(json['country']),
    );
  }
}
