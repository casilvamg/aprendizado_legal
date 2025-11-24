import 'package:flutter/material.dart';

import 'iniciar_jogo_page.dart';

class BoasVindasPage extends StatelessWidget {
  const BoasVindasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BEM-VINDO AO SHOW DA DIVERSÃO!')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ESCOLHA SEU JOGADOR',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40), // Espaço aumentado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribui melhor os jogadores
              children: [
                // --- Jogador Matheus ---
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const IniciarJogoPage(nomeJogador: 'MATHEUS'),
                          ),
                        );
                      },
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('assets/imagens/matheus.jpeg'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'MATHEUS',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),

                // --- Jogador Theo ---
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // CORRIGIDO: Passa o nome do jogador para a próxima tela
                            builder: (context) => const IniciarJogoPage(nomeJogador: 'THEO'),
                          ),
                        );
                      },
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('assets/imagens/theo.jpeg'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'THEO',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
