import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/splash/splash_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: ShinobiLinkApp(),
    ),
  );
}

class ShinobiLinkApp extends StatelessWidget {
  const ShinobiLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShinobiLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const SplashScreen(),
    );
  }
}
