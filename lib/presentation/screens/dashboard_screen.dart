import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/assets.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final _menus = const [
    {'label': 'Dashboard', 'icon': Icons.dashboard_outlined},
    {'label': 'Profil', 'icon': Icons.person_outline},
    {'label': 'Abonnement', 'icon': Icons.workspace_premium_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    final drawerWidth = 260.0;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppAssets.logoApp, height: 30),
            const SizedBox(width: 8),
            const Text('Akizniz', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          LayoutBuilder(
            builder: (context, constraints) {
              // On small screens, show only icons
              final isSmall = MediaQuery.of(context).size.width < 600;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isSmall)
                    TextButton.icon(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(AppColors.primary),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      icon: const Icon(Icons.diamond, size: 16),
                      label: const Text('Points'),
                    )
                  else
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.diamond, size: 20),
                      tooltip: 'Points',
                    ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_none),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CircleAvatar(
                      backgroundColor: const Color(AppColors.primary).withValues(alpha: 30),
                      radius: 16,
                      child: const Icon(Icons.person, size: 18, color: Color(AppColors.primary)),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Text('Menu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: _menus.length,
                  itemBuilder: (ctx, i) {
                    final sel = i == _selectedIndex;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: sel ? const Color(AppColors.primary) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(_menus[i]['icon'] as IconData, color: sel ? Colors.white : const Color(AppColors.dark)),
                        title: Text(_menus[i]['label'] as String, style: TextStyle(color: sel ? Colors.white : const Color(AppColors.dark))),
                        onTap: () => setState(() => _selectedIndex = i),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(AppColors.primaryOrange),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.help_outline, color: Color(AppColors.primaryOrange)),
                      ),
                      const SizedBox(height: 12),
                      const Text('Besoin d\'aide ?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      const Text('Contactez-nous ici', style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(AppColors.dark),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {},
                        child: const Text('Prendre contact'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Row(
        children: [
          // Permanent drawer for large screens
          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 900;
            if (!isWide) return const SizedBox.shrink();
            return SizedBox(
              width: drawerWidth,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text('Menu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _menus.length,
                      itemBuilder: (ctx, i) {
                        final sel = i == _selectedIndex;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: sel ? const Color(AppColors.primary) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Icon(_menus[i]['icon'] as IconData, color: sel ? Colors.white : const Color(AppColors.dark)),
                            title: Text(_menus[i]['label'] as String, style: TextStyle(color: sel ? Colors.white : const Color(AppColors.dark))),
                            onTap: () => setState(() => _selectedIndex = i),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
          // Content area
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _PageWrapper(
                key: ValueKey(_selectedIndex),
                title: _menus[_selectedIndex]['label'] as String,
                child: _buildContent(_selectedIndex),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(int index) {
    switch (index) {
      case 0:
        return _DashboardContent(key: const ValueKey('dashboard'));
      case 1:
        return _ProfilContent(key: const ValueKey('profil'));
      case 2:
        return _AbonnementContent(key: const ValueKey('abonnement'));
      default:
        return const SizedBox();
    }
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Contenu principal du dashboard (placeholder).'),
        ],
      ),
    );
  }
}

class _ProfilContent extends StatelessWidget {
  const _ProfilContent({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Informations de profil (placeholder).'),
        ],
      ),
    );
  }
}

class _AbonnementContent extends StatelessWidget {
  const _AbonnementContent({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Gestion des abonnements (placeholder).'),
        ],
      ),
    );
  }
}

class _PageWrapper extends StatelessWidget {
  final String title;
  final Widget child;
  const _PageWrapper({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
