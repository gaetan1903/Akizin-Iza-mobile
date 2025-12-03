/// Paramètres pour la recherche par code
class SearchByCodeParams {
  final String code;

  const SearchByCodeParams({
    required this.code,
  });

  Map<String, dynamic> toJson() => {
        'code': code,
      };
}

/// Paramètres pour la recherche par nom
class SearchByNameParams {
  final String name;

  const SearchByNameParams({
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
