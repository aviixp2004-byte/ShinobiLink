import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/services/app_router.dart';

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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      routerConfig: appRouter,
    );
  }
}
