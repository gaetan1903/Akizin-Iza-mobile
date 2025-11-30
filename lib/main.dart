import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'presentation/routes/app_router.dart';

void main() {
  runApp(const AkiznizApp());
}

class AkiznizApp extends StatelessWidget {
  const AkiznizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Akizniz?',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: AppRouter.searchCode,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
