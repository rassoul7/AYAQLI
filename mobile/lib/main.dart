import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/auth_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const AyaqliApp(),
    ),
  );
}

class AyaqliApp extends StatelessWidget {
  const AyaqliApp({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return MaterialApp(
      title: 'Ayaqli',
      debugShowCheckedModeBanner: false,
      themeMode: app.themeMode,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const AuthScreen(),
    );
  }
}
