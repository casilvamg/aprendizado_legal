import 'package:flutter/material.dart';
import 'leitura_page.dart';
import 'contas_page.dart';
import 'progresso/progresso_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Theo, aprender é divertido!")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("📖 Leitura"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LeituraPage()),
              ),
            ),
            ElevatedButton(
              child: const Text("🔢 Contas"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContasPage()),
              ),
            ),
            ElevatedButton(
              child: const Text("⭐ Meu Progresso"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProgressoPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
