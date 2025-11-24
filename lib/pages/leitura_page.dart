import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LeituraPage extends StatefulWidget {
  const LeituraPage({super.key});

  @override
  State<LeituraPage> createState() => _LeituraPageState();
}

class _LeituraPageState extends State<LeituraPage> {
  final List<Map<String, dynamic>> perguntas = [
    {
      "pergunta": "Encontre a palavra que representa a imagem",
      "imagem": "assets/imagens/sol.svg",
      "correta": "SOL",
      "alternativas": ["SOL", "LUA", "TERRA", "ESTRELA"]
    },
    {
      "pergunta": "Encontre a palavra que representa a imagem",
      "imagem": "assets/imagens/duck.svg",
      "correta": "PATO",
      "alternativas": ["GATO", "SAPO", "CAVALO", "PATO"]
    },
    {
      "pergunta": "Encontre a palavra que representa a imagem",
      "imagem": "assets/imagens/house-water.svg",
      "correta": "CASA",
      "alternativas": ["MAR", "CASA", "CARRO", "PEIXE"]
    }
    // Adicione outras perguntas aqui quando tiver as imagens
  ];

  int perguntaAtual = 0;
  String? respostaSelecionada;
  bool respondeu = false;

  void escolherResposta(String alternativa) {
    setState(() {
      respostaSelecionada = alternativa;
      respondeu = true;
    });
  }

  void proximaPergunta() {
    setState(() {
      // Modificado para reiniciar se não houver mais perguntas
      if (perguntaAtual + 1 < perguntas.length) {
        perguntaAtual++;
      } else {
        perguntaAtual = 0; // Volta para a primeira
      }
      respondeu = false;
      respostaSelecionada = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Adicionado para evitar erro se a lista estiver vazia
    if (perguntas.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Leitura com Imagens")),
        body: const Center(
          child: Text("Nenhuma pergunta encontrada."),
        ),
      );
    }

    final pergunta = perguntas[perguntaAtual];

    return Scaffold(
      appBar: AppBar(title: const Text("Leitura com Imagens")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // 🔹 MOSTRAR A PERGUNTA PRIMEIRO
            Text(
              pergunta["pergunta"],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // EXIBE A IMAGEM AQUI
            SvgPicture.asset(
              pergunta["imagem"],
              height: 200,
            ),

            const SizedBox(height: 30),

            // Alternativas como botões
            ...pergunta["alternativas"].map<Widget>((alt) {
              bool acertou = alt == pergunta["correta"];
              bool selecionada = alt == respostaSelecionada;

              Color corBotao() {
                if (!respondeu) return Colors.teal;
                if (selecionada && acertou) return Colors.green;
                if (selecionada && !acertou) return Colors.red;
                return Colors.grey;
              }

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: respondeu ? null : () => escolherResposta(alt),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: corBotao(),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: Text(
                    alt,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 20),

            if (respondeu)
              Text(
                respostaSelecionada == pergunta["correta"]
                    ? "🎉 Muito bem!"
                    : "❌ Tente novamente!",
                style: const TextStyle(fontSize: 22),
              ),

            const Spacer(),

            if (respondeu)
              ElevatedButton(
                onPressed: proximaPergunta,
                child: const Text("Próxima imagem"),
              ),
          ],
        ),
      ),
    );
  }
}
