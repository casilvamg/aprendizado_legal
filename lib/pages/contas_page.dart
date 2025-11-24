import 'package:flutter/material.dart';

class ContasPage extends StatelessWidget {
  const ContasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contas")),
      body: Center(
        child: Text(
          "Mostre uma continha simples:\n3 + 2 = ?",
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
