import 'package:flutter/material.dart';

class ProgressoPage extends StatelessWidget {
  const ProgressoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Progresso")),
      body: Center(
        child: const Text(
          "⭐ Pontos: 0\n\nMissões completadas: 0",
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
