import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/colors.dart';
import '../../core/design_tokens.dart';
import '../../core/assets.dart';
import '../../core/entities/public_status.dart';
import '../../features/search/provider/search_provider.dart';
import '../routes/app_router.dart';

class SearchCodeScreen extends ConsumerStatefulWidget {
  const SearchCodeScreen({super.key});
  @override
  ConsumerState<SearchCodeScreen> createState() => _SearchCodeScreenState();
}

class _SearchCodeScreenState extends ConsumerState<SearchCodeScreen> {
  final _controller = TextEditingController();

  void _submit() async {
    final code = _controller.text.trim();
    if (code.isEmpty) {
      _showSnack('Entrez un code', isError: true);
      return;
    }

    // Lance la recherche via le provider
    await ref.read(publicStatusSearchProvider.notifier).search(code);
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(msg)),
          ],
        ),
        backgroundColor: isError ? Colors.red[700] : Colors.green[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showErrorSnack(String error) {
    String message = error;

    // Parse les messages d'erreur connus
    if (error.contains('Invalid or expired code')) {
      message = 'Code invalide ou expiré';
    } else if (error.contains('Ressource non trouvée')) {
      message = 'Utilisateur introuvable avec ce code';
    } else if (error.contains('Pas de connexion Internet')) {
      message = 'Vérifiez votre connexion Internet';
    } else if (error.contains('Délai de connexion dépassé')) {
      message = 'Le serveur met trop de temps à répondre';
    }

    _showSnack(message, isError: true);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 700;

    // Écoute les erreurs pour afficher les toasts
    ref.listen<AsyncValue<PublicStatus?>>(
      publicStatusSearchProvider,
      (previous, next) {
        // Affiche le toast seulement si on passe d'un état non-erreur à erreur
        if (previous?.hasError != true && next.hasError) {
          next.whenOrNull(
            error: (error, stackTrace) {
              _showErrorSnack(error.toString());
            },
          );
        }
      },
    );

    // Écoute l'état de la recherche
    final searchState = ref.watch(publicStatusSearchProvider);
    final isLoading = searchState.isLoading;
    final publicStatus = searchState.valueOrNull;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient + subtle decorative hero illustration placeholder
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFF5F7), Colors.white],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 80 : 24,
                vertical: 32,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(AppAssets.logoApp, height: 40),
                        const Spacer(),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context).pushNamed(AppRouter.login),
                          child: const Text('Se connecter'),
                        ),
                      ],
                    ),
                    const SizedBox(height: DT.s7),
                    Text(
                      'Découvrez la vérité maintenant',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                    ),
                    const SizedBox(height: DT.s2),
                    const Text(
                      'Est-il/elle vraiment disponible ? Entrez son code et obtenez la réponse en moins de 5 secondes. 100% gratuit et anonyme.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: DT.s6),
                    if (isTablet)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildForm(isLoading)),
                          const SizedBox(width: DT.s7),
                          Expanded(child: _buildIllustration()),
                        ],
                      )
                    else ...[
                      _buildForm(isLoading),
                      const SizedBox(height: DT.s7),
                      _buildIllustration(),
                    ],
                    const SizedBox(height: DT.s8),
                    // _buildSecondaryInfo(),
                    // const SizedBox(height: DT.s9),
                  ],
                ),
              ),
            ),
          ),
          if (publicStatus != null)
            _ResultBottomSheet(
              publicStatus: publicStatus,
              onClose: () =>
                  ref.read(publicStatusSearchProvider.notifier).reset(),
            ),
        ],
      ),
    );
  }

  Widget _buildForm(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
          decoration: const InputDecoration(
            labelText: 'Code utilisateur',
            hintText: 'Ex: AKNZ-8492',
          ),
        ),
        const SizedBox(height: DT.s4),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 2,
              shadowColor: AppColors.primary.withValues(alpha: 0.3),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'DÉCOUVRIR LA VÉRITÉ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: DT.s3),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8F0),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.primaryOrange.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: AppColors.primaryOrange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Pas de code ? Recherchez par nom',
                  style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRouter.searchName),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Premium →',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIllustration() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF0F3), Color(0xFFFFF8FA)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(DT.s6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shield_outlined,
              color: AppColors.primary,
              size: 48,
            ),
          ),
          const SizedBox(height: DT.s4),
          const Text(
            'Protégez votre cœur',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: DT.s2),
          const Text(
            'Vérifiez avant de vous attacher. Aucune information sur le partenaire n\'est révélée sans connexion.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildSecondaryInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pourquoi nous faire confiance ?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.dark,
          ),
        ),
        const SizedBox(height: DT.s4),
        Wrap(
          spacing: DT.s4,
          runSpacing: DT.s4,
          children: [
            _InfoBadge(
              icon: Icons.lock_outline,
              title: '100% Anonyme',
              text: 'Aucune donnée personnelle collectée.',
              color: AppColors.primary,
            ),
            _InfoBadge(
              icon: Icons.flash_on,
              title: 'Instantané',
              text: 'Réponse en moins de 5 secondes.',
              color: AppColors.primaryOrange,
            ),
            _InfoBadge(
              icon: Icons.verified_user,
              title: 'Fiable à 99%',
              text: 'Des milliers de vérifications par jour.',
              color: AppColors.green,
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final Color color;
  const _InfoBadge({
    required this.icon,
    required this.title,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              height: 1.4,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultBottomSheet extends StatelessWidget {
  final PublicStatus publicStatus;
  final VoidCallback onClose;

  const _ResultBottomSheet({
    required this.publicStatus,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isCouple = publicStatus.isInCouple;
    final fullName = publicStatus.fullName;
    final avatarUrl = publicStatus.avatarUrl;
    final situation = publicStatus.situation;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedSlide(
        duration: DT.dFast,
        offset: Offset.zero,
        child: AnimatedOpacity(
          duration: DT.dFast,
          opacity: 1,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 16,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Profil trouvé',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: onClose,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // User Profile Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE9ECEF)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.network(
                            avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.person, size: 32);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fullName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              situation,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.verified,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isCouple
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCouple
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : Colors.green.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isCouple ? Icons.favorite : Icons.check_circle,
                        color: isCouple ? AppColors.primary : Colors.green,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          situation,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isCouple ? AppColors.primary : Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isCouple
                        ? AppColors.primary.withValues(alpha: 0.08)
                        : Colors.green.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isCouple
                        ? "💡 Vous voulez savoir avec qui ? Connectez-vous pour accéder à la recherche avancée et découvrir l'identité du partenaire."
                        : "💎 Créez un compte premium pour accéder à la recherche avancée par nom et consulter l'historique complet des relations.",
                    style: const TextStyle(fontSize: 13, height: 1.5),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRouter.login),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: const StadiumBorder(),
                      side: BorderSide(color: AppColors.primary),
                    ),
                    child: const Text('SE CONNECTER / CRÉER UN COMPTE'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
