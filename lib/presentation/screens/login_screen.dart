import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/colors.dart';
import '../../core/design_tokens.dart';
import '../../core/assets.dart';
import '../../core/entities/user.dart';
import '../../features/auth/data/auth_params.dart';
import '../../features/auth/provider/auth_provider.dart';
import '../routes/app_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _showPassword = false;
  bool _isSignupMode = false;

  @override
  void initState() {
    super.initState();
    // Écoute les changements d'état d'authentification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listen<AsyncValue<User?>>(authProvider, (_, AsyncValue<User?> state) {
        state.whenOrNull(
          error: (Object error, StackTrace _) {
            if (mounted) {
              _showSnack(error.toString());
            }
          },
          data: (User? user) {
            if (user != null && mounted) {
              Navigator.of(context).pushReplacementNamed(AppRouter.dashboard);
            }
          },
        );
      });
    });
  }

  void _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final params = LoginParams(
      email: _emailController.text.trim(),
      password: _passController.text,
    );

    await ref.read(authProvider.notifier).login(params);
  }

  void _signup() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final params = RegisterParams(
      email: _emailController.text.trim(),
      password: _passController.text,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
    );

    await ref.read(authProvider.notifier).register(params);
  }

  void _handleGoogleSignIn() async {
    try {
      await ref.read(authProvider.notifier).signInWithGoogle();
    } catch (e) {
      if (mounted) {
        _showSnack('Erreur: $e');
      }
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 600;
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: isSmall ? 24 : 48, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppAssets.logoApp, height: 56),
                      ],
                    ),
                    const SizedBox(height: DT.s7),
                    Text(
                      _isSignupMode ? 'Inscription' : 'Connexion',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: 34,
                                color: AppColors.primary,
                              ),
                    ),
                    const SizedBox(height: DT.s2),
                    Text(
                      _isSignupMode
                          ? 'Créez votre compte pour accéder à toutes les fonctionnalités.'
                          : 'Accédez à votre compte pour consulter les relations et gérer vos points.',
                      style: const TextStyle(fontSize: 15, height: 1.4),
                    ),
                    const SizedBox(height: DT.s6),

                    // Champs firstName/lastName pour inscription
                    if (_isSignupMode) ...[
                      TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'Prénom',
                          hintText: 'Jean',
                        ),
                        validator: (value) {
                          if (_isSignupMode &&
                              (value == null || value.isEmpty)) {
                            return 'Le prénom est requis';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: DT.s4),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Nom',
                          hintText: 'Dupont',
                        ),
                        validator: (value) {
                          if (_isSignupMode &&
                              (value == null || value.isEmpty)) {
                            return 'Le nom est requis';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: DT.s4),
                    ],

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'exemple@mail.com',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'L\'email est requis';
                        }
                        if (!value.contains('@')) {
                          return 'Email invalide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: DT.s4),
                    TextFormField(
                      controller: _passController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        suffixIcon: IconButton(
                          icon: Icon(_showPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () =>
                              setState(() => _showPassword = !_showPassword),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Le mot de passe est requis';
                        }
                        if (_isSignupMode && value.length < 6) {
                          return 'Le mot de passe doit contenir au moins 6 caractères';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: DT.s3),
                    if (!_isSignupMode)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Mot de passe oublié ?'),
                        ),
                      ),
                    const SizedBox(height: DT.s4),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : (_isSignupMode ? _signup : _login),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : Text(
                                _isSignupMode ? 'S\'INSCRIRE' : 'SE CONNECTER'),
                      ),
                    ),
                    const SizedBox(height: DT.s5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_isSignupMode
                            ? 'Déjà un compte ?'
                            : 'Pas de compte ?'),
                        TextButton(
                            onPressed: () {
                              setState(() => _isSignupMode = !_isSignupMode);
                            },
                            child: Text(_isSignupMode
                                ? 'Se connecter'
                                : 'Créer un compte')),
                      ],
                    ),
                    const SizedBox(height: DT.s5),
                    Row(
                      children: const [
                        Expanded(child: Divider()),
                        SizedBox(width: 12),
                        Text('OU'),
                        SizedBox(width: 12),
                        Expanded(child: Divider())
                      ],
                    ),
                    const SizedBox(height: DT.s5),
                    Wrap(
                      runSpacing: 12,
                      children: [
                        _SocialButton(
                            label: 'Continuer avec Google',
                            asset: AppAssets.logoGoogle,
                            onTap: _handleGoogleSignIn),
                        _SocialButton(
                            label: 'Continuer avec Facebook',
                            asset: AppAssets.logoFacebook,
                            onTap: () {}),
                      ],
                    ),
                    const SizedBox(height: DT.s6),
                    Container(
                      padding: const EdgeInsets.all(DT.s5),
                      decoration: BoxDecoration(
                        color: AppColors.primaryWhite,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Vérifier sans compte',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: DT.s2),
                          const Text(
                              'Utilisez un code utilisateur pour savoir si une personne est en couple.'),
                          const SizedBox(height: DT.s3),
                          OutlinedButton(
                            onPressed: () => Navigator.of(context)
                                .pushNamed(AppRouter.searchCode),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 14),
                              shape: const StadiumBorder(),
                              side: BorderSide(color: AppColors.primary),
                            ),
                            child: const Text('VÉRIFIER AVEC UN CODE'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final String asset;
  final VoidCallback onTap;
  const _SocialButton(
      {required this.label, required this.asset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Image.asset(asset, height: 20),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
