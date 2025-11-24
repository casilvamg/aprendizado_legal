import 'package:aprendizado_legal/pages/onboarding/boas_vindas_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Quiz Kids",
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const BoasVindasPage(),
    );
  }
}
