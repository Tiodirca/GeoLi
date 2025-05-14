import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/textos.dart';

class TelaFimJogoWidget extends StatelessWidget {
  const TelaFimJogoWidget({super.key});

  Widget cardOpcoes(BuildContext context) => SizedBox(
        width: 130,
        height: 170,
        child: FloatingActionButton(
          heroTag: Textos.btnJogarNovamente,
          backgroundColor: Colors.white,
          onPressed: () {
            Timer(const Duration(seconds: 2), () {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaSistemaSolar);
            });
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
                image: AssetImage("${CaminhosImagens.btnNovamenteGesto}.png"),
              ),
              Text(
                Textos.btnJogarNovamente,
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
                Textos.telaSistemaSolarFimJogoTitulo,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  cardOpcoes(context),
                ],
              )
            ],
          ),
        ));
  }
}
