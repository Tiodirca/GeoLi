import 'package:flutter/material.dart';
import 'package:geoli/Uteis/textos.dart';

class EmblemaWidget extends StatelessWidget {
  const EmblemaWidget(
      {super.key,
      required this.caminhoImagem,
      required this.nomeEmblema,
      required this.pontos});

  final String caminhoImagem;
  final String nomeEmblema;
  final int pontos;

  validarTamanhoGestos(double largura) {
    if (largura <= 600) {
      return 20.0;
    } else if (largura > 600 && largura <= 1000) {
      return 30.0;
    } else if (largura > 1000) {
      return 40.0;
    }
  }
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              width: 40,
              height: 40,
              child: Image(
                height: 40,
                width: 40,
                image: AssetImage('$caminhoImagem.png'),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nomeEmblema,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      Textos.emblemasPontos,
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      pontos.toString(),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}
