import 'package:equatable/equatable.dart';

/// Entité représentant le statut public d'un utilisateur
/// Retourné par l'endpoint public /api/search/public-status
class PublicStatus extends Equatable {
  final String firstName;
  final String lastName;
  final String avatarUrl;
  final String situation; // "En couple" | "Célibataire"

  const PublicStatus({
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
    required this.situation,
  });

  /// Crée une instance à partir du JSON de l'API NestJS
  factory PublicStatus.fromJson(Map<String, dynamic> json) {
    return PublicStatus(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      avatarUrl: json['avatarUrl'] as String,
      situation: json['situation'] as String,
    );
  }

  /// Convertit vers JSON
  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'avatarUrl': avatarUrl,
        'situation': situation,
      };

  /// Nom complet de l'utilisateur
  String get fullName => '$firstName $lastName';

  /// Vérifie si l'utilisateur est en couple
  bool get isInCouple => situation.toLowerCase() == 'en couple';

  @override
  List<Object?> get props => [firstName, lastName, avatarUrl, situation];
}
