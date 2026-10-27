import 'package:flutter/material.dart';

import 'models/app_settings.dart';
import 'screens/splash_page.dart';
import 'theme/app_colors.dart';

void main() => runApp(const QuickQrApp());

class QuickQrApp extends StatelessWidget {
  const QuickQrApp({super.key});

  ThemeData _theme(Brightness brightness) => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kIndigo,
      primary: kIndigo,
      brightness: brightness,
    ),
    fontFamily: 'Roboto',
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, _) => MaterialApp(
        title: 'QuickQR',
        debugShowCheckedModeBanner: false,
        theme: _theme(Brightness.light),
        darkTheme: _theme(Brightness.dark),
        themeMode: mode,
        home: const SplashPage(),
      ),
    );
  }
}
