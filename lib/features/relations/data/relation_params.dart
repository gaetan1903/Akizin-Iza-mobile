/// Paramètres pour créer une demande de relation
class CreateRelationParams {
  final String targetUserId;
  final String? message;

  const CreateRelationParams({
    required this.targetUserId,
    this.message,
  });

  Map<String, dynamic> toJson() => {
        'targetUserId': targetUserId,
        if (message != null) 'message': message,
      };
}

/// Paramètres pour répondre à une demande de relation
class RespondToRelationParams {
  final String relationId;
  final bool accept;

  const RespondToRelationParams({
    required this.relationId,
    required this.accept,
  });

  Map<String, dynamic> toJson() => {
        'relationId': relationId,
        'accept': accept,
      };
}
