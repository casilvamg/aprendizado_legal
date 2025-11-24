import 'package:aprendizado_legal/pages/onboarding/boas_vindas_page.dart';
import 'package:flutter/material.dart';
import 'package:aprendizado_legal/pages/quiz_perguntas/data/pontuacao_data.dart';

// ---------------------- TELA DE RESULTADO (CORRIGIDA) ----------------------
class ResultadoPage extends StatelessWidget {
  final int pontuacao;
  final int totalPerguntas;
  final int acertos;

  // CORRIGIDO: O construtor agora exige a pontuação
  const ResultadoPage({
    super.key,
    required this.pontuacao,
    required this.totalPerguntas,
    required this.acertos
  });

  @override
  Widget build(BuildContext context) {
    String mensagem;
    if (acertos == totalPerguntas) {
      mensagem = 'Excelente! Você acertou tudo! 🚀';
    } else if (acertos < totalPerguntas - 1 && acertos > totalPerguntas - 8) {
      mensagem = 'Muito bem! Você foi ótimo! 🎉';
    } else {
      mensagem = 'Continue tentando, você consegue! 💪';
    }

    final valorFormatado = formatarValor(acertos);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
        automaticallyImplyLeading: false, // Remove a seta de "voltar"
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 80),
            // ADICIONADO: Mostra a pontuação final
            Text(
              'Você acertou $acertos de $totalPerguntas perguntas 👏👏👏',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Você faturou $valorFormatado REAIS 💰💰💰',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const BoasVindasPage()),
                  (route) => false, // Remove todas as telas anteriores
                );
              },
              child: const Text('Jogar Novamente'),
            ),
          ],
        ),
      ),
    );
  }

  String formatarValor(int acertos) {

    if (acertos == 16) {
      return "1 MILHÃO";
    }

    final resultado = listaDePontuacao.firstWhere(
          (item) => item["acertos"] == acertos,
      orElse: () => {},
    );

    print(resultado);

    if (resultado != null) {
      if (acertos == 1) {
        return "${resultado["seErrar"]}";
      }
      return "${resultado["seErrar"]} MIL";
    }
    else {
      return 'ERRO';
    }
  }
}
