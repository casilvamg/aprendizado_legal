import 'package:flutter/material.dart';
import '../quiz_perguntas/pergunta_page.dart';
import 'iniciar_jogo_page.dart';

class ModoJogoPage extends StatelessWidget {
  final String nomeJogador;

  const ModoJogoPage({super.key, required this.nomeJogador});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modo de Jogo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'COMO VOCÊ QUER JOGAR?',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPlayerAvatar(context, nomeJogador, 'NORMAL'),
                _buildPlayerAvatar(context, nomeJogador, 'DESAFIO'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerAvatar(BuildContext context, String nomeJogador, String modoJogo) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                // CORRIGIDO: Navega para a tela de seleção de modo
                builder: (context) => PerguntaPage(nomeJogador: nomeJogador, modoJogo: modoJogo),
              ),
            );
          },
          child: CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('assets/imagens/${modoJogo.toLowerCase()}.jpg'),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          modoJogo,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
