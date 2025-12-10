import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/app_theme.dart';
import 'core/sources/secure_storage_service.dart';
import 'features/auth/provider/auth_provider.dart';
import 'presentation/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Chargement des variables d'environnement
  await dotenv.load(fileName: ".env");

  // Initialisation de SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Active seulement en mode debug
      builder: (context) => ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const AkiznizApp(),
      ),
    ),
  );
}

class AkiznizApp extends ConsumerWidget {
  const AkiznizApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialise le DeepLinkService au démarrage
    ref.watch(deepLinkServiceProvider);

    return MaterialApp(
      // Configuration DevicePreview
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      title: 'Akizniz?',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: AppRouter.searchCode,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
