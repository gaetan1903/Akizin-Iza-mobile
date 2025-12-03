import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/entities/user.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../provider/search_provider.dart';

class SearchCodePage extends ConsumerStatefulWidget {
  const SearchCodePage({super.key});

  @override
  ConsumerState<SearchCodePage> createState() => _SearchCodePageState();
}

class _SearchCodePageState extends ConsumerState<SearchCodePage> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<User?> searchState = ref.watch(searchByCodeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche par code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Code utilisateur',
                hintText: 'Entrez le code',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.qr_code),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _handleSearch,
                ),
              ),
              onSubmitted: (_) => _handleSearch(),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: searchState.when(
                data: (User? user) {
                  if (user == null) {
                    return const Center(
                      child: Text('Entrez un code pour rechercher'),
                    );
                  }
                  return _buildUserCard(user);
                },
                loading: () => const LoadingWidget(),
                error: (Object error, StackTrace stackTrace) =>
                    ErrorDisplayWidget(
                  error: error,
                  onRetry: _handleSearch,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(User user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: user.avatarUrl != null
                  ? NetworkImage(user.avatarUrl!)
                  : null,
              child: user.avatarUrl == null
                  ? Text(
                      user.name[0].toUpperCase(),
                      style: const TextStyle(fontSize: 32),
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              user.email,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (user.code != null) ...[
              const SizedBox(height: 8),
              Text(
                'Code: ${user.code}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Ajouter en relation
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Ajouter en relation'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSearch() {
    final String code = _codeController.text.trim();
    if (code.isNotEmpty) {
      ref.read(searchByCodeProvider.notifier).searchByCode(code);
    }
  }
}
