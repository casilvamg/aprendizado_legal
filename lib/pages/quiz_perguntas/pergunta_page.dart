import 'dart:math';

import 'package:aprendizado_legal/pages/ajuda/ajuda_page.dart';
import 'package:aprendizado_legal/pages/quiz_perguntas/data/perguntas_data.dart';
import 'package:aprendizado_legal/pages/quiz_perguntas/data/pontuacao_data.dart';
import 'package:aprendizado_legal/pages/resultado/resultado_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

import '../onboarding/boas_vindas_page.dart';
import 'data/perguntas_revisao_data.dart';

class PerguntaPage extends StatefulWidget {
  final String nomeJogador;
  final String modoJogo;
  final String? nomeDisciplina;
  const PerguntaPage({super.key, required this.nomeJogador, required this.modoJogo, this.nomeDisciplina});

  @override
  State<PerguntaPage> createState() => _PerguntaPageState();
}

class _PerguntaPageState extends State<PerguntaPage> {
  final FlutterTts flutterTts = FlutterTts();

  List<Map<String, dynamic>> perguntas = [];
  Map<int, List<Map<String, dynamic>>> perguntasPorNivel = {};
  final List<Map<String, dynamic>> _gabarito = [];

  int perguntaAtual = 0;
  int pontuacao = 0;
  int acertos = 0;
  String? respostaSelecionada;
  bool respondeu = false;
  
  List<bool> pulosDisponiveis = [true, true, true];
  bool cartaAjudaDisponivel = true;
  List<String> alternativasOcultas = [];

  int valorAcertar = 0;
  int valorErrar = 0;
  int nivel = 1;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    inicializarQuiz();
  }

  Future<void> inicializarQuiz() async {
    await _initTts();
    await carregarPerguntas();
    
    setState(() {
      _isLoading = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (perguntas.isNotEmpty) {
        transformarTextoEmVoz(perguntas[perguntaAtual]['pergunta']);
      }
    });
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("pt-BR");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  Future<void> transformarTextoEmVoz(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> carregarPerguntas() async {
    if (widget.modoJogo == 'REVISAO') {
      carregarPerguntasRevisao();
    }
    else {
      await carregarDemaisPerguntas();
    }
  }

  Future<void> carregarDemaisPerguntas() async {
    final prefs = await SharedPreferences.getInstance();

    final List<Map<String, dynamic>> perguntasFiltradas = listaDePerguntas
        .where((p) => p['nomeDoJogador'] == widget.nomeJogador)
        .toList();

    for (var pergunta in perguntasFiltradas) {
      pergunta['qtd_uso'] = prefs.getInt(pergunta['pergunta']) ?? 0;
    }

    final List<Map<String, dynamic>> listaCompleta = [];
    final Map<int, List<Map<String, dynamic>>> groupedByLevel = {};

    for (var pergunta in perguntasFiltradas) {
      final nivel = pergunta['nivel'] ?? 1;
      if (groupedByLevel[nivel] == null) {
        groupedByLevel[nivel] = [];
      }
      groupedByLevel[nivel]!.add(pergunta);
    }

    final sortedLevels = groupedByLevel.keys.toList()..sort();
    for (var nivel in sortedLevels) {
      final List<Map<String, dynamic>> perguntasDoNivel = groupedByLevel[nivel]!;
      perguntasDoNivel.sort((a, b) => (a['qtd_uso'] as int).compareTo(b['qtd_uso'] as int));
      listaCompleta.addAll(perguntasDoNivel);
    }

    setState(() {
      perguntas = listaCompleta;
    });
  }

  Future<void> salvarProgressoDaPergunta() async {
    final prefs = await SharedPreferences.getInstance();
    final String perguntaKey = perguntas[perguntaAtual]['pergunta'];
    final int currentCount = prefs.getInt(perguntaKey) ?? 0;
    await prefs.setInt(perguntaKey, currentCount + 1);
  }

  void escolherResposta(String alternativa) {
    final bool ehCorreta = alternativa == perguntas[perguntaAtual]["correta"];
    
    if (widget.modoJogo == 'REVISAO') {
      _gabarito.add({
        'pergunta': perguntas[perguntaAtual]['pergunta'],
        'suaResposta': alternativa,
        'respostaCorreta': perguntas[perguntaAtual]['correta'],
      });
    }

    if (ehCorreta) {
      salvarProgressoDaPergunta();
      if ([5, 10, 15].contains(acertos + 1)) {
        transformarTextoEmVoz("${widget.nomeJogador}, porque você não me disse que você era muito bom.");
      }
    }

    setState(() {
      respostaSelecionada = alternativa;
      respondeu = true;
    });
  }

  void proximaPergunta([bool ehPular = false]) {
    if (widget.modoJogo != 'REVISAO') {
      int nivelAnterior = nivel;

      if (!ehPular && respostaSelecionada == perguntas[perguntaAtual]["correta"]) {
        acertos++;
      }

      Map<String, dynamic> elemento = listaDePontuacao.firstWhere(
            (item) => item['acertos'] == acertos, orElse: () => {},
      );
      pontuacao = elemento['pontuacao'] ?? pontuacao;
      valorAcertar = elemento['seAcertar'] ?? valorAcertar;
      valorErrar = elemento['seErrar'] ?? valorErrar;
      nivel = elemento['nivel'] ?? nivel;

      setState(() {
        if (nivel != nivelAnterior) {
          perguntas = perguntasPorNivel[nivel] ?? [];
          perguntaAtual = 0;
        } else {
          perguntaAtual++;
        }

        respondeu = false;
        respostaSelecionada = null;
        alternativasOcultas = [];
      });
    }
    else {
      setState(() {
        respondeu = false;
        respostaSelecionada = null;
        perguntaAtual++;
      });
    }

    if(perguntaAtual < perguntas.length) {
       transformarTextoEmVoz(perguntas[perguntaAtual]['pergunta']);
    }
  }

  void navegarParaAjuda() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AjudaPage(
          pulosDisponiveis: pulosDisponiveis,
          cartaDisponivel: cartaAjudaDisponivel,
        ),
      ),
    );

    if (resultado != null) {
      if (resultado.startsWith('PULO')) {
        final puloIndex = int.parse(resultado.split('_')[1]) - 1;
        setState(() {
          pulosDisponiveis[puloIndex] = false;
        });
        proximaPergunta(true);
      } else if (resultado.startsWith('CARTA')) {
        setState(() {
          cartaAjudaDisponivel = false;
          final int count = int.parse(resultado.split('_')[1]);
          final pergunta = perguntas[perguntaAtual];
          final List<String> alternativasIncorretas = List<String>.from(pergunta['alternativas'])
            ..remove(pergunta['correta']);

          alternativasIncorretas.shuffle();
          alternativasOcultas = alternativasIncorretas.take(count).toList();
        });
      }
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Widget buildScoreColumn(String label, String value, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  String formatarValor(int valor) {
    if (widget.modoJogo == 'DESAFIO') {
      double resultado = valor / 1000000;

      if (resultado == 0.0) {
        return "0,001 CENT";
      }

      if (resultado == 1.0) {
        return "1 REAL";
      }

      return resultado.toString() + ' CENT';
    }

    if (widget.modoJogo == 'NORMAL') {
      if (valor == 0) return "1 MIL";
      if (valor < 1000) return valor.toString();
      if (valor < 1000000) return "${valor ~/ 1000} MIL";
      if (valor == 1000000) return "1 MILHÃO";
    }
    return 'ERRO';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Quiz de ${widget.nomeJogador} ${widget.modoJogo}")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    print(perguntas.isEmpty);
    print(widget.modoJogo == 'REVISAO');

    // CORRIGIDO: Lógica de fim de jogo reorganizada
    // 1. Caso específico para Revisão sem perguntas
    if (perguntas.isEmpty && widget.modoJogo == 'REVISAO') {
      return Scaffold(
        appBar: AppBar(title: Text("Revisão - ${widget.nomeJogador}")),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "As perguntas para esta disciplina ainda não foram disponibilizadas. Volte depois!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    // 2. Condição geral de fim de jogo para todos os modos
    if (perguntas.isEmpty || perguntaAtual >= perguntas.length) {
      return Scaffold(
        appBar: AppBar(title: Text("Fim de Jogo - ${widget.nomeJogador}")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Parabéns! Você respondeu todas as perguntas!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              buildActionButton(),
            ],
          ),
        ),
      );
    }

    final pergunta = perguntas[perguntaAtual];

    return Scaffold(
      appBar: AppBar(title: Text("Quiz de ${widget.nomeJogador} (${widget.modoJogo})")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text("${pergunta['pergunta']}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            if (pergunta["imagem"] != null && pergunta["imagem"].isNotEmpty)
              SvgPicture.asset(pergunta["imagem"], height: 60),
            const SizedBox(height: 30),
            ...pergunta["alternativas"].asMap().entries.map<Widget>((entry) {
              int idx = entry.key;
              String alt = entry.value;

              if (alternativasOcultas.contains(alt)) {
                return const SizedBox.shrink();
              }

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: respondeu ? null : () => escolherResposta(alt),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.orange,
                        child: Text('${idx + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Text(alt, style: const TextStyle(fontSize: 22), softWrap: true),
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up, color: Colors.white),
                        onPressed: () => transformarTextoEmVoz(alt),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
            if (respondeu && widget.modoJogo != 'REVISAO')
              Text(
                respostaSelecionada == pergunta["correta"] ? "🎉 Muito bem!" : "❌ Que Pena! A resposta é " + pergunta["correta"],
                style: const TextStyle(fontSize: 22),
              ),
            const SizedBox(height: 40),
            if (respondeu) ...[buildActionButton()],
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'btn_audio',
            onPressed: () => transformarTextoEmVoz(pergunta['pergunta']),
            child: const Icon(Icons.volume_up),
          ),
          if (widget.modoJogo != 'REVISAO') ...[
            const SizedBox(width: 16),
            FloatingActionButton.extended(
              heroTag: 'btn_ajuda',
              onPressed: (respondeu || widget.modoJogo == 'DESAFIO') ? null : navegarParaAjuda,
              icon: const Icon(Icons.help_outline),
              label: const Text('Ajuda'),
              backgroundColor: (respondeu || widget.modoJogo == 'DESAFIO') ? Colors.grey.shade300 : Theme.of(context).colorScheme.secondary,
              foregroundColor: (respondeu || widget.modoJogo == 'DESAFIO') ? Colors.grey.shade700 : Colors.white,
            ),
          ],
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        child: Row(
          children: widget.modoJogo == 'REVISAO'
              ? [
                  Expanded(
                    child: Center(
                      child: Text(
                        'Questão ${perguntaAtual + 1} de ${perguntas.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ]
              : [
                  if (pontuacao > 0) Expanded(child: buildScoreColumn('ERRAR', formatarValor(valorErrar), Colors.red.shade300)),
                  if (pontuacao > 0) Expanded(child: buildScoreColumn('PARAR', formatarValor(pontuacao), Colors.white)),
                  if (pontuacao == 0) const Spacer(),
                  Expanded(child: buildScoreColumn('ACERTAR', formatarValor(valorAcertar), Colors.green.shade300)),
                ],
        ),
      ),
    );
  }

  Widget buildActionButton() {
    final bool isCorrect = respostaSelecionada != null && respostaSelecionada == perguntas[perguntaAtual]["correta"];
    final bool isFinalLevel = (perguntas.isNotEmpty && (perguntas[perguntaAtual]["nivel"] ?? 1) >= 4);

    if (isCorrect && !isFinalLevel && widget.modoJogo != 'REVISAO') {
      return ElevatedButton(
        onPressed: proximaPergunta,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Colors.white,
        ),
        child: const Text("Próxima Pergunta"),
      );
    }
    else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              int finalAcertos = acertos;
              if (isCorrect) {
                finalAcertos++;
              }

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultadoPage(
                    pontuacao: pontuacao,
                    totalPerguntas: widget.modoJogo == 'REVISAO' ? perguntas.length : listaDePontuacao.length,
                    acertos: finalAcertos,
                    modoJogo: widget.modoJogo,
                    gabarito: widget.modoJogo == 'REVISAO' ? _gabarito : null,
                  ),
                ),
              );
            },
            child: const Text("Ver Resultado"),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
               Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const BoasVindasPage()),
                (route) => false, 
              );
            },
            child: const Text("Jogar Novamente"),
          ),
        ],
      );
    }
  }

  void carregarPerguntasRevisao() {
    final List<Map<String, dynamic>> perguntasFiltradasPorDisciplina = listaDePerguntasRevisao
        .where((p) => p['nomeDisciplina'] == widget.nomeDisciplina)
        .toList();

    perguntas = perguntasFiltradasPorDisciplina;
  }
}