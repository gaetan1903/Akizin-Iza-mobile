/// Paramètres pour la connexion
class LoginParams {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

/// Paramètres pour l'inscription
class RegisterParams {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? phone;

  const RegisterParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.phone,
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
      };
}

/// Paramètres pour la vérification
class VerificationParams {
  final String code;
  final String userId;

  const VerificationParams({
    required this.code,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
        'code': code,
        'userId': userId,
      };
}

/// Réponse d'authentification
class AuthResponse {
  final String accessToken;
  final Map<String, dynamic> user;

  const AuthResponse({
    required this.accessToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'] as String,
      user: json['user'] as Map<String, dynamic>,
    );
  }
}
