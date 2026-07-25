import 'package:flutter/material.dart';

void main() {
  runApp(const ShinobiLinkApp());
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
      home: const Scaffold(
        body: Center(
          child: Text(
            'ShinobiLink',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
