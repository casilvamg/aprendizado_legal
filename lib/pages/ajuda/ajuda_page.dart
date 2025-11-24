import 'dart:math';
import 'package:flutter/material.dart';

// ---------------------- TELA DE AJUDA (STATEFUL) ----------------------
class AjudaPage extends StatefulWidget {
  final List<bool> pulosDisponiveis;
  final bool cartaDisponivel;

  const AjudaPage({
    super.key,
    required this.pulosDisponiveis,
    required this.cartaDisponivel,
  });

  @override
  State<AjudaPage> createState() => _AjudaPageState();
}

class _AjudaPageState extends State<AjudaPage> {
  int? _alternativasEliminadas;
  bool _cartasReveladas = false;
  List<String> _cardFaces = [];

  @override
  void initState() {
    super.initState();
    // Embaralha as faces das cartas no início
    _cardFaces = ['K', 'A', '2', '3']..shuffle();
  }

  Widget _buildPuloButton(BuildContext context, int numero, bool disponivel) {
    return ElevatedButton.icon(
      onPressed: disponivel ? () => Navigator.pop(context, 'PULO_$numero') : null,
      icon: const Icon(Icons.skip_next),
      label: Text('Pulo $numero'),
      style: ElevatedButton.styleFrom(
        backgroundColor: disponivel ? Colors.cyanAccent : Colors.grey,
        foregroundColor: disponivel ? Colors.black : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // CORRIGIDO: A função agora usa o valor da carta clicada
  void _revelarCartas(String faceDaCarta) {
    if (!widget.cartaDisponivel || _cartasReveladas) return;

    int eliminadas;
    switch (faceDaCarta) {
      case 'K':
        eliminadas = 0;
        break;
      case 'A':
        eliminadas = 1;
        break;
      case '2':
        eliminadas = 2;
        break;
      case '3':
        eliminadas = 3;
        break;
      default:
        eliminadas = 0;
    }

    setState(() {
      _alternativasEliminadas = eliminadas;
      _cartasReveladas = true;
    });
  }

  // Widget para construir a carta
  Widget _buildCard({required bool isFaceDown, required String valueText, required VoidCallback? onTap}) {
    return Opacity(
      // CORRIGIDO: Fica mais claro se o onTap for nulo (desabilitado)
      opacity: onTap != null ? 1.0 : 0.5,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 60,
          height: 90,
          decoration: BoxDecoration(
            color: isFaceDown ? Colors.blueGrey : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Center(
            child: isFaceDown
                ? const Icon(Icons.question_mark, color: Colors.white, size: 40)
                : Text(
                    valueText,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool podeUsarCarta = widget.cartaDisponivel && !_cartasReveladas;

    return Scaffold(
      appBar: AppBar(title: const Text('Ajuda')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Pulos', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildPuloButton(context, 1, widget.pulosDisponiveis[0]),
            const SizedBox(height: 12),
            _buildPuloButton(context, 2, widget.pulosDisponiveis[1]),
            const SizedBox(height: 12),
            _buildPuloButton(context, 3, widget.pulosDisponiveis[2]),

            const Divider(height: 40, thickness: 1),

            const Text('Ajuda das Cartas', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _cardFaces.map((face) {
                return _buildCard(
                  isFaceDown: !_cartasReveladas, // Mostra a face se _cartasReveladas for true
                  valueText: face,
                  onTap: podeUsarCarta ? () => _revelarCartas(face) : null, // Passa a face da carta
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            if (_cartasReveladas)
              Column(
                children: [
                  Text(
                    'Você eliminou $_alternativasEliminadas alternativas!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, 'CARTA_$_alternativasEliminadas'),
                    child: const Text('Voltar ao Jogo'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
