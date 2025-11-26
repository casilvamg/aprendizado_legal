import 'package:flutter/material.dart';
import 'package:aprendizado_legal/pages/quiz_perguntas/pergunta_page.dart';
import 'package:flutter_tts/flutter_tts.dart';

class IniciarJogoPage extends StatefulWidget {
  final String nomeJogador;
  final String modoJogo; // ADICIONADO: Para receber o modo de jogo

  const IniciarJogoPage({
    super.key,
    required this.nomeJogador,
    required this.modoJogo,
  });

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
                    // CORRIGIDO: Passa o nome E o modo de jogo para a próxima tela
                    builder: (context) => PerguntaPage(
                      nomeJogador: widget.nomeJogador,
                      modoJogo: widget.modoJogo,
                    ),
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
