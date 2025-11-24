import 'package:flutter/material.dart';
import 'package:aprendizado_legal/pages/quiz_perguntas/pergunta_page.dart';
import 'package:flutter_tts/flutter_tts.dart';

class IniciarJogoPage extends StatefulWidget {
  final String nomeJogador;
  const IniciarJogoPage({super.key, required this.nomeJogador});

  @override
  State<IniciarJogoPage> createState() => _IniciarJogoPageState();
}

class _IniciarJogoPageState extends State<IniciarJogoPage> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("pt-BR");
    await flutterTts.setSpeechRate(0.5);
    // Fala a mensagem depois que a tela for construída
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _speak('Boa sorte, ${widget.nomeJogador}!');
    });
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preparado?')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Boa sorte, ${widget.nomeJogador}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // CORRIGIDO: Passa o nome do jogador para a tela de perguntas
                    builder: (context) => PerguntaPage(nomeJogador: widget.nomeJogador),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: const Text('INICIAR JOGO', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
