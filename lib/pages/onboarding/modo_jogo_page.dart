import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../quiz_perguntas/pergunta_page.dart';
import 'escolher_disciplina_page.dart';

class ModoJogoPage extends StatefulWidget {
  final String nomeJogador;

  const ModoJogoPage({super.key, required this.nomeJogador});

  @override
  State<ModoJogoPage> createState() => _ModoJogoPageState();
}

class _ModoJogoPageState extends State<ModoJogoPage> {
  bool _desafioDisponivel = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _verificarDisponibilidadeDesafio();
  }

  Future<void> _verificarDisponibilidadeDesafio() async {
    final prefs = await SharedPreferences.getInstance();
    // Chave única para cada jogador
    final key = 'ultimaDataDesafio_${widget.nomeJogador}';
    final ultimaDataJogada = prefs.getString(key);
    final hoje = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Se nunca jogou ou a última vez foi antes de hoje, o desafio está disponível
    if (ultimaDataJogada == null || ultimaDataJogada != hoje) {
      setState(() {
        _desafioDisponivel = true;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _iniciarDesafio() async {
    // Marca a data de hoje como a data do último desafio jogado para este jogador
    final prefs = await SharedPreferences.getInstance();
    final key = 'ultimaDataDesafio_${widget.nomeJogador}';
    final hoje = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await prefs.setString(key, hoje);

    // Navega para a página do quiz
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PerguntaPage(
            nomeJogador: widget.nomeJogador,
            modoJogo: 'DESAFIO',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modo de Jogo')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
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
                      _buildPlayerAvatar(context, 'NORMAL'),
                      _buildPlayerAvatar(context, 'DESAFIO'),
                      if (widget.nomeJogador == 'MATHEUS')
                        _buildPlayerAvatar(context, 'REVISAO'),
                    ],
                  ),
                  if (!_desafioDisponivel)
                    const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        'Modo Desafio já jogado hoje. Volte amanhã!',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildPlayerAvatar(BuildContext context, String modoJogo) {
    final bool isDesafio = modoJogo == 'DESAFIO';
    final bool isRevisao = modoJogo == 'REVISAO';
    // O modo desafio só está habilitado se _desafioDisponivel for true
    final bool isEnabled = isDesafio ? _desafioDisponivel : true;

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: Column(
        children: [
          GestureDetector(
            onTap: isEnabled
                ? () {
                    if (isDesafio) {
                      _iniciarDesafio();
                    }
                    else if (isRevisao) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EscolherDisciplinaPage(
                            nomeJogador: "MATHEUS",
                            modoJogo: modoJogo,
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PerguntaPage(
                            nomeJogador: 'NORMAL',
                            modoJogo: modoJogo,
                          ),
                        ),
                      );
                    }
                  }
                : null,
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
      ),
    );
  }
}
