import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/assets.dart';
import '../widgets/stat_card.dart';
import '../widgets/app_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _stats = [
    {
      'icon': Icons.favorite,
      'number': '10K+',
      'title': 'Membres',
      'text': 'Plus de 10 milles personnes utilisent Akizniz',
    },
    {
      'icon': Icons.sentiment_satisfied_alt,
      'number': '95%',
      'title': 'Satisfaits',
      'text': 'Un système fiable avec un taux de précision de 99%',
    },
    {
      'icon': Icons.verified,
      'number': '50K+',
      'title': 'Relations vérifiées',
      'text': 'Des milliers ont déjà vérifié leur statut relationnel',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 700;
    return Scaffold(
      appBar: const AppHeader(showLogin: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero section
            Container(
              padding: EdgeInsets.only(
                top: isSmall ? 70 : 130,
                left: 28,
                right: 28,
                bottom: 50,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final twoColumns = width > 900;
                  return twoColumns
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: _buildHeroText(context, isSmall: false),
                            ),
                            const SizedBox(width: 40),
                            Expanded(child: _HeroImages(width: width / 2)),
                          ],
                        )
                      : Column(
                          children: [
                            _buildHeroText(context, isSmall: true),
                            const SizedBox(height: 40),
                            _HeroImages(width: width),
                          ],
                        );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isSmall ? 24 : 60),
              child: Wrap(
                spacing: 18,
                runSpacing: 18,
                alignment: WrapAlignment.start,
                children: _stats
                    .map(
                      (st) => StatCard(
                        icon: st['icon'] as IconData,
                        number: st['number'] as String,
                        title: st['title'] as String,
                        text: st['text'] as String,
                        width: isSmall
                            ? (MediaQuery.of(context).size.width - 72)
                            : 240,
                      ),
                    )
                    .toList(),
              ),
            ),
            // Verification methods section
            Container(
              color: AppColors.primaryWhite,
              padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 32),
              child: Column(
                children: [
                  Text(
                    'Est-il/elle vraiment célibataire ?',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Protégez votre cœur. Connaissez la vérité avant de vous engager.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.4, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final maxWidth = constraints.maxWidth;
                      final isSmall = maxWidth < 700;

                      if (isSmall) {
                        return Column(
                          children: [
                            _VerificationCard(
                              color: AppColors.primary,
                              icon: Icons.qr_code_2,
                              badge: 'GRATUIT',
                              badgeColor: AppColors.green,
                              title: 'Code de vérification instantané',
                              sub:
                                  'Ils vous ont donné leur code ? Découvrez immédiatement s\'ils sont vraiment disponibles. Aucune inscription requise.',
                              actionLabel: 'Vérifier maintenant',
                              features: const [
                                '✓ 100% gratuit et anonyme',
                                '✓ Réponse en moins de 5 secondes',
                                '✓ Aucun compte nécessaire',
                              ],
                            ),
                            const SizedBox(height: 22),
                            _VerificationCard(
                              color: AppColors.primaryOrange,
                              icon: Icons.search,
                              badge: 'PREMIUM',
                              badgeColor: AppColors.primaryOrange,
                              title: 'Recherche avancée',
                              sub:
                                  'Vous n\'avez pas leur code ? Recherchez par nom et découvrez non seulement leur statut, mais aussi avec qui ils sont en couple.',
                              actionLabel: 'Voir les offres Premium',
                              features: const [
                                '✓ Recherche illimitée par nom',
                                '✓ Identité du partenaire révélée',
                                '✓ Accès à l\'historique complet',
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: _VerificationCard(
                                color: AppColors.primary,
                                icon: Icons.qr_code_2,
                                badge: 'GRATUIT',
                                badgeColor: AppColors.green,
                                title: 'Code de vérification instantané',
                                sub:
                                    'Ils vous ont donné leur code ? Découvrez immédiatement s\'ils sont vraiment disponibles. Aucune inscription requise.',
                                actionLabel: 'Vérifier maintenant',
                                features: const [
                                  '✓ 100% gratuit et anonyme',
                                  '✓ Réponse en moins de 5 secondes',
                                  '✓ Aucun compte nécessaire',
                                ],
                              ),
                            ),
                            const SizedBox(width: 32),
                            Flexible(
                              child: _VerificationCard(
                                color: AppColors.primaryOrange,
                                icon: Icons.search,
                                badge: 'PREMIUM',
                                badgeColor: AppColors.primaryOrange,
                                title: 'Recherche avancée',
                                sub:
                                    'Vous n\'avez pas leur code ? Recherchez par nom et découvrez non seulement leur statut, mais aussi avec qui ils sont en couple.',
                                actionLabel: 'Voir les offres Premium',
                                features: const [
                                  '✓ Recherche illimitée par nom',
                                  '✓ Identité du partenaire révélée',
                                  '✓ Accès à l\'historique complet',
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 38),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFF1F1F3)),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      'Nous vous répondrons le plus tôt possible. Notre équipe est toujours là.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeroText(BuildContext context, {required bool isSmall}) {
  return Column(
    crossAxisAlignment:
        isSmall ? CrossAxisAlignment.center : CrossAxisAlignment.start,
    children: [
      Text(
        'La doute est en vous mais,',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        textAlign: isSmall ? TextAlign.center : TextAlign.start,
      ),
      const SizedBox(height: 14),
      Text(
        'La vérité se trouve ici et nulle part ailleurs',
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: isSmall ? 34 : 56,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              height: 1.15,
            ),
        textAlign: isSmall ? TextAlign.center : TextAlign.start,
      ),
      const SizedBox(height: 14),
      Text(
        'Découvrez instantanément si quelqu\'un est célibataire, en couple ou c\'est compliqué !',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
        textAlign: isSmall ? TextAlign.center : TextAlign.start,
      ),
      const SizedBox(height: 34),
      SizedBox(
        width: isSmall ? double.infinity : 270,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 0,
          ),
          onPressed: () => Navigator.of(context).pushNamed('/dashboard'),
          child: const Text('VÉRIFIEZ MAINTENANT'),
        ),
      ),
      const SizedBox(height: 40),
      Align(
        alignment: isSmall ? Alignment.center : Alignment.centerLeft,
        child: Image.asset(
          AppAssets.arrow,
          width: isSmall ? 120 : 160,
          fit: BoxFit.contain,
        ),
      ),
    ],
  );
}

class _HeroImages extends StatelessWidget {
  final double width;
  const _HeroImages({required this.width});

  @override
  Widget build(BuildContext context) {
    final baseW = width < 400 ? width * 0.7 : 340.0;
    return SizedBox(
      height: baseW + 40,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 30,
            child: Transform.rotate(
              angle: -0.08,
              child: _MockCard(
                color: AppColors.primary,
                label: 'Trouve ton partenaire',
                width: baseW,
              ),
            ),
          ),
          Positioned(
            left: 0,
            child: Transform.rotate(
              angle: 0.03,
              child: _MockCard(
                color: Colors.black,
                label: 'Découvre l\'identité',
                width: baseW * 0.92,
              ),
            ),
          ),
          Positioned(
            bottom: -10,
            child: Transform.rotate(
              angle: -0.02,
              child: _MockCard(
                color: const Color(0xFFE6E6E6),
                label: 'Reconnais ta rivale',
                width: baseW * 0.88,
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Image.asset(
              AppAssets.groupImage,
              width: baseW * 0.75,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

class _MockCard extends StatelessWidget {
  final Color color;
  final String label;
  final double width;
  const _MockCard({
    required this.color,
    required this.label,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width * 1.32,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.all(18),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _VerificationCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String badge;
  final Color badgeColor;
  final String title;
  final String sub;
  final String actionLabel;
  final List<String> features;

  const _VerificationCard({
    required this.color,
    required this.icon,
    required this.badge,
    required this.badgeColor,
    required this.title,
    required this.sub,
    required this.actionLabel,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F1F3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: badgeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            sub,
            style: TextStyle(
              color: AppColors.dark,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                feature,
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () {},
              child: Text(
                actionLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
