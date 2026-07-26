import 'package:flutter/material.dart';

void main() {
  runApp(const DiLangApp());
}

class DiLangApp extends StatelessWidget {
  const DiLangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DiLang',
      theme: ThemeData.dark(useMaterial3: true),
      home: const Scaffold(
        body: Center(
          child: Text('DiLang Engine Foundation Initialized'),
        ),
      ),
    );
  }
}
