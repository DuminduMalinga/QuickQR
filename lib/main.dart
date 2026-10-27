import 'package:flutter/material.dart';

import 'models/app_settings.dart';
import 'screens/splash_page.dart';
import 'services/storage.dart';
import 'theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initStorage();
  runApp(const QuickQrApp());
}

class QuickQrApp extends StatelessWidget {
  const QuickQrApp({super.key});

  static final _lightScheme = ColorScheme.fromSeed(
    seedColor: kIndigo,
    primary: kIndigo,
  );

  // High-contrast dark palette: light text on near-black, soft indigo accents.
  static final _darkScheme =
      ColorScheme.fromSeed(
        seedColor: kIndigo,
        brightness: Brightness.dark,
      ).copyWith(
        primary: const Color(0xFFA5B4FC),
        onPrimary: const Color(0xFF1E1B4B),
        primaryContainer: const Color(0xFF3730A3),
        onPrimaryContainer: const Color(0xFFE0E7FF),
        secondaryContainer: const Color(0xFF3730A3),
        onSecondaryContainer: const Color(0xFFE0E7FF),
        surface: const Color(0xFF0F172A),
        onSurface: const Color(0xFFF8FAFC),
        onSurfaceVariant: const Color(0xFFCBD5E1),
        outline: const Color(0xFF94A3B8),
        outlineVariant: const Color(0xFF475569),
      );

  ThemeData _theme(ColorScheme scheme) => ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    fontFamily: 'Roboto',
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, _) => MaterialApp(
        title: 'QuickQR',
        debugShowCheckedModeBanner: false,
        theme: _theme(_lightScheme),
        darkTheme: _theme(_darkScheme),
        themeMode: mode,
        home: const SplashPage(),
      ),
    );
  }
}
