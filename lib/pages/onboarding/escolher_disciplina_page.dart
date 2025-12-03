import 'package:flutter/material.dart';
import '../quiz_perguntas/pergunta_page.dart';

class EscolherDisciplinaPage extends StatelessWidget {
  final String nomeJogador;
  final String modoJogo;

  const EscolherDisciplinaPage({
    super.key,
    required this.nomeJogador,
    required this.modoJogo,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> disciplinas = {
      'GEOGRAFIA': 'GEOGRAFIA',
      'MATEMATICA': 'MATEMÁTICA',
      'PORTUGUES': 'PORTUGUÊS',
      'HISTORIA': 'HISTÓRIA',
      'CIENCIAS': 'CIÊNCIAS',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Escolha a Disciplina')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'QUAL DISCIPLINA VOCÊ QUER REVISAR?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Wrap(
                spacing: 16.0, // Espaçamento horizontal
                runSpacing: 20.0, // Espaçamento vertical
                alignment: WrapAlignment.center,
                children: disciplinas.entries.map((entry) {
                  return _buildDisciplinaAvatar(context, entry);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisciplinaAvatar(BuildContext context, MapEntry<String, String> entry) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PerguntaPage(
                  nomeJogador: nomeJogador,
                  modoJogo: modoJogo,
                  nomeDisciplina: entry.value,
                ),
              ),
            );
          },
          child: CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/imagens/${entry.key.toLowerCase()}.jpg'),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          entry.value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
