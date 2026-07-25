import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/view/splash_screen.dart';

void main() {
  runApp(const ShinobiLinkApp());
}

class ShinobiLinkApp extends StatelessWidget {
  const ShinobiLinkApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShinobiLink',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
