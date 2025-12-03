import 'package:equatable/equatable.dart';

/// Entité représentant le portefeuille de points
class Wallet extends Equatable {
  final String id;
  final String userId;
  final int points;
  final DateTime updatedAt;

  const Wallet({
    required this.id,
    required this.userId,
    required this.points,
    required this.updatedAt,
  });

  /// Crée une instance à partir d'un JSON
  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'] as String,
      userId: json['userId'] as String,
      points: json['points'] as int,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convertit vers JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'points': points,
        'updatedAt': updatedAt.toIso8601String(),
      };

  /// Crée une copie avec des modifications
  Wallet copyWith({
    String? id,
    String? userId,
    int? points,
    DateTime? updatedAt,
  }) {
    return Wallet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      points: points ?? this.points,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, points, updatedAt];
}

/// Entité représentant une transaction de points
class PointTransaction extends Equatable {
  final String id;
  final String walletId;
  final int amount;
  final String type; // 'credit', 'debit'
  final String description;
  final DateTime createdAt;

  const PointTransaction({
    required this.id,
    required this.walletId,
    required this.amount,
    required this.type,
    required this.description,
    required this.createdAt,
  });

  /// Crée une instance à partir d'un JSON
  factory PointTransaction.fromJson(Map<String, dynamic> json) {
    return PointTransaction(
      id: json['id'] as String,
      walletId: json['walletId'] as String,
      amount: json['amount'] as int,
      type: json['type'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convertit vers JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'walletId': walletId,
        'amount': amount,
        'type': type,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
      };

  bool get isCredit => type == 'credit';
  bool get isDebit => type == 'debit';

  @override
  List<Object?> get props => [id, walletId, amount, type, description, createdAt];
}
