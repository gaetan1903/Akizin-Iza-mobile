import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/design_tokens.dart';
import '../../core/assets.dart';
import '../routes/app_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _loading = false;
  bool _showPassword = false;

  void _login() async {
    if (_userController.text.isEmpty || _passController.text.isEmpty) {
      _showSnack('Champs requis');
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(DT.dBase);
    setState(() => _loading = false);
    // Navigate to dashboard after mock login
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRouter.dashboard);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 600;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isSmall ? 24 : 48, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
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
                    'Connexion',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 34,
                          color: const Color(AppColors.primary),
                        ),
                  ),
                  const SizedBox(height: DT.s2),
                  const Text(
                    'Accédez à votre compte pour consulter les relations et gérer vos points.',
                    style: TextStyle(fontSize: 15, height: 1.4),
                  ),
                  const SizedBox(height: DT.s6),
                  TextField(
                    controller: _userController,
                    decoration: const InputDecoration(
                      labelText: 'Email ou Nom d\'utilisateur',
                      hintText: 'exemple@mail.com',
                    ),
                  ),
                  const SizedBox(height: DT.s4),
                  TextField(
                    controller: _passController,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      suffixIcon: IconButton(
                        icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _showPassword = !_showPassword),
                      ),
                    ),
                  ),
                  const SizedBox(height: DT.s3),
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
                      onPressed: _loading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _loading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('SE CONNECTER'),
                    ),
                  ),
                  const SizedBox(height: DT.s5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Pas de compte ?'),
                      TextButton(onPressed: () {}, child: const Text('Créer un compte')),
                    ],
                  ),
                  const SizedBox(height: DT.s5),
                  Row(
                    children: const [Expanded(child: Divider()), SizedBox(width: 12), Text('OU'), SizedBox(width: 12), Expanded(child: Divider())],
                  ),
                  const SizedBox(height: DT.s5),
                  Wrap(
                    runSpacing: 12,
                    children: [
                      _SocialButton(label: 'Continuer avec Google', asset: AppAssets.logoGoogle, onTap: () {}),
                      _SocialButton(label: 'Continuer avec Facebook', asset: AppAssets.logoFacebook, onTap: () {}),
                    ],
                  ),
                  const SizedBox(height: DT.s6),
                  Container(
                    padding: const EdgeInsets.all(DT.s5),
                    decoration: BoxDecoration(
                      color: const Color(AppColors.primaryWhite),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Vérifier sans compte', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: DT.s2),
                        const Text('Utilisez un code utilisateur pour savoir si une personne est en couple.'),
                        const SizedBox(height: DT.s3),
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).pushNamed(AppRouter.searchCode),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                            shape: const StadiumBorder(),
                            side: const BorderSide(color: Color(AppColors.primary)),
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
    );
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final String asset;
  final VoidCallback onTap;
  const _SocialButton({required this.label, required this.asset, required this.onTap});

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
