import 'package:flutter/material.dart';
import '../../core/assets.dart';
import '../../core/colors.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool showLogin;
  const AppHeader({super.key, this.showLogin = true});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Color(0xFFEDEDED), width: 1)),
        ),
        child: Row(
          children: [
            Image.asset(AppAssets.logoApp, height: 34),
            const SizedBox(width: 42),
            // Navigation placeholders
            _HeaderNavItem(label: 'Accueil', active: true),
            _HeaderNavItem(label: 'Nos offres'),
            _HeaderNavItem(label: 'Nous contacter'),
            const Spacer(),
            // Language switch placeholder
            _LanguageSwitcher(),
            const SizedBox(width: 20),
            if (showLogin)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: const StadiumBorder(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  elevation: 0,
                ),
                onPressed: () {},
                child: const Text(
                  'Se connecter',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HeaderNavItem extends StatelessWidget {
  final String label;
  final bool active;
  const _HeaderNavItem({required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.dark;
    return Padding(
      padding: const EdgeInsets.only(right: 32),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: active ? FontWeight.w600 : FontWeight.w400,
          color: color,
        ),
      ),
    );
  }
}

class _LanguageSwitcher extends StatefulWidget {
  @override
  State<_LanguageSwitcher> createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<_LanguageSwitcher> {
  String _lang = 'fr';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => setState(() => _lang = 'en'),
            child: Text(
              'anglais',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _lang == 'en' ? AppColors.primary : AppColors.dark,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text('|',
              style: TextStyle(fontSize: 12, color: Color(0xFFBBBBBB))),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() => _lang = 'fr'),
            child: Text(
              'français',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _lang == 'fr' ? AppColors.primary : AppColors.dark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
