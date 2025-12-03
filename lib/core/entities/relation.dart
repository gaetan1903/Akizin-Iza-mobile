import 'package:equatable/equatable.dart';
import 'user.dart';

/// Entité représentant une relation entre utilisateurs
class Relation extends Equatable {
  final String id;
  final User user;
  final String status; // 'pending', 'accepted', 'rejected'
  final DateTime createdAt;
  final DateTime? acceptedAt;

  const Relation({
    required this.id,
    required this.user,
    required this.status,
    required this.createdAt,
    this.acceptedAt,
  });

  /// Crée une instance à partir d'un JSON
  factory Relation.fromJson(Map<String, dynamic> json) {
    return Relation(
      id: json['id'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      acceptedAt: json['acceptedAt'] != null
          ? DateTime.parse(json['acceptedAt'] as String)
          : null,
    );
  }

  /// Convertit vers JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user.toJson(),
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        if (acceptedAt != null) 'acceptedAt': acceptedAt?.toIso8601String(),
      };

  /// Crée une copie avec des modifications
  Relation copyWith({
    String? id,
    User? user,
    String? status,
    DateTime? createdAt,
    DateTime? acceptedAt,
  }) {
    return Relation(
      id: id ?? this.id,
      user: user ?? this.user,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
    );
  }

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';

  @override
  List<Object?> get props => [id, user, status, createdAt, acceptedAt];
}
