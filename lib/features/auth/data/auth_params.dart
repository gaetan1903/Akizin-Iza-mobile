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
  final String name;
  final String email;
  final String password;
  final String? phone;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
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
  final String token;
  final String refreshToken;
  final Map<String, dynamic> user;

  const AuthResponse({
    required this.token,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      user: json['user'] as Map<String, dynamic>,
    );
  }
}
