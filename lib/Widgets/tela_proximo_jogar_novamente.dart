import 'package:flutter/material.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';

import '../Uteis/paleta_cores.dart';
import '../Uteis/textos.dart';

class TelaProximoNivel extends StatelessWidget {
  const TelaProximoNivel({Key? key, required this.nomeNivel}) : super(key: key);

 final String nomeNivel;

  Widget cardOpcoes(
          String nomeImagem, String nomeOpcao, BuildContext context) =>
      SizedBox(
        width: 130,
        height: 170,
        child: FloatingActionButton(
          heroTag: nomeOpcao,
          backgroundColor: Colors.white,
          onPressed: () {
            if (nomeOpcao == Textos.btnJogarNovamente) {
              if (nomeNivel == Constantes.nomeRegiaoCentroOeste) {
                MetodosAuxiliares.resetarDadosRegiaoCentroOeste();
                Navigator.pushReplacementNamed(
                    context, Constantes.rotaTelaRegiaoCentroOeste);
              }
            }
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
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                Textos.tituloTelaProximoNivel,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  cardOpcoes(Constantes.btnJogarNovamenteGesto,
                      Textos.btnJogarNovamente, context),
                  cardOpcoes(Constantes.btnProximoNivelGesto,
                      Textos.btnProximoNivel, context)
                ],
              )
            ],
          ),
        ));
  }
}
