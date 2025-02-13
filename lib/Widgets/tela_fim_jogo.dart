import 'package:flutter/material.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';

import '../Uteis/paleta_cores.dart';
import '../Uteis/textos.dart';

class TelaFimJogo extends StatefulWidget {
  const TelaFimJogo({
    super.key,
  });

  @override
  State<TelaFimJogo> createState() => _TelaFimJogoState();
}

class _TelaFimJogoState extends State<TelaFimJogo> {
  Map<String, dynamic> dados = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget cardOpcoes(
          String nomeImagem, String nomeOpcao, BuildContext context) =>
      SizedBox(
        width: 130,
        height: 170,
        child: FloatingActionButton(
          heroTag: nomeOpcao,
          backgroundColor: Colors.white,
          onPressed: () {
            if (nomeOpcao == Textos.btnJogarNovamente) {}
          },
          elevation: 0,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: PaletaCores.corLaranja, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(40))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                height: 110,
                width: 110,
                image: AssetImage("$nomeImagem.png"),
              ),
              Text(
                nomeOpcao,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black),
              )
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 400,
        height: 250,
        child: Card(
          color: Colors.white,
          shape: const RoundedRectangleBorder(
              side: BorderSide(color: PaletaCores.corAzulMagenta),
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                Textos.btnProximoNivel,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  cardOpcoes(CaminhosImagens.btnJogarNovamenteGesto,
                      Textos.btnJogarNovamente, context),
                ],
              )
            ],
          ),
        ));
  }
}
