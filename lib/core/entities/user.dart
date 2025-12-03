import 'package:equatable/equatable.dart';

/// Entité représentant un utilisateur
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? code;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.code,
    this.avatarUrl,
    required this.createdAt,
    this.updatedAt,
  });

  /// Crée une instance à partir d'un JSON de l'API NestJS
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      code: json['code_user'] as String? ?? json['code'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Convertit vers JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        if (phone != null) 'phone': phone,
        if (code != null) 'code': code,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
        'createdAt': createdAt.toIso8601String(),
        if (updatedAt != null) 'updatedAt': updatedAt?.toIso8601String(),
      };

  /// Crée une copie avec des modifications
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? code,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      code: code ?? this.code,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        code,
        avatarUrl,
        createdAt,
        updatedAt,
      ];
}
