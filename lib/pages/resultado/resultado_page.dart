import 'package:aprendizado_legal/pages/onboarding/boas_vindas_page.dart';
import 'package:flutter/material.dart';
import 'package:aprendizado_legal/pages/quiz_perguntas/data/pontuacao_data.dart';

// ---------------------- TELA DE RESULTADO (CORRIGIDA) ----------------------
class ResultadoPage extends StatelessWidget {
  final int pontuacao;
  final int totalPerguntas;
  final int acertos;
  final String modoJogo;
  // ADICIONADO: Parâmetro opcional para o gabarito
  final List<Map<String, dynamic>>? gabarito;

  const ResultadoPage({
    super.key,
    required this.pontuacao,
    required this.totalPerguntas,
    required this.acertos,
    required this.modoJogo,
    this.gabarito, // Parâmetro opcional
  });

  @override
  Widget build(BuildContext context) {
    // Se for modo revisão, mostra o gabarito
    if (modoJogo == 'REVISAO') {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Gabarito da Revisão'),
          automaticallyImplyLeading: false,
        ),
        body: ListView.builder(
          itemCount: gabarito?.length ?? 0,
          itemBuilder: (context, index) {
            final item = gabarito![index];
            final bool acertou = item['suaResposta'] == item['respostaCorreta'];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: Icon(
                  acertou ? Icons.check_circle : Icons.cancel,
                  color: acertou ? Colors.green : Colors.red,
                ),
                title: Text('Questão ${index + 1}: ${item['pergunta']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sua resposta: ${item['suaResposta']}'),
                    if (!acertou)
                      Text(
                        'Resposta correta: ${item['respostaCorreta']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const BoasVindasPage()),
                (route) => false,
              );
            },
            child: const Text('Jogar Novamente'),
          ),
        ),
      );
    }

    // Lógica para os outros modos de jogo
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
              'Você faturou $valorFormatado 💰💰💰',
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

    if (modoJogo == 'DESAFIO') {
      if (acertos == listaDePontuacao.length) {
        return "1 REAL";
      }

      final resultado = listaDePontuacao.firstWhere(
            (item) => item["acertos"] == acertos,
        orElse: () => {},
      );

      if (resultado.isNotEmpty) {

        if (acertos == 1) {
          return "0,001 CENTAVOS DE REAIS";
        }

        int valor = resultado["seErrar"];
        double resp = valor / 1000000;

        return "${resp.toStringAsFixed(2).replaceAll('.', ',')} CENTAVOS DE REAIS";
      }
      else {
        return 'ERRO';
      }
    }

    if (modoJogo == 'NORMAL') {
      if (acertos == listaDePontuacao.length) {
        return "1 MILHÃO DE REAIS";
      }

      final resultado = listaDePontuacao.firstWhere(
            (item) => item["acertos"] == acertos,
        orElse: () => {},
      );

      if (resultado.isNotEmpty) {
        if (acertos == 1) {
          return "${resultado["seErrar"]} REAIS";
        }
        return "${(resultado["seErrar"] / 1000).toInt()} MIL REAIS";
      }
      else {
        return 'ERRO';
      }
    }
    return 'ERRO';
  }
}
