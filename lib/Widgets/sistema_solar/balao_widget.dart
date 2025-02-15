import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/modelos/planeta.dart';

class BalaoWidget extends StatefulWidget {
  const BalaoWidget({super.key, required this.planeta});

  final Planeta planeta;

  @override
  State<BalaoWidget> createState() => _BalaoWidgetState();
}

class _BalaoWidgetState extends State<BalaoWidget> {
  List<Color> listaCorBalao = [];
  Random random = Random();
  late Color corbalao;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listaCorBalao.addAll([
      Colors.redAccent,
      Colors.pinkAccent,
      Colors.blue,
      Colors.greenAccent,
      Colors.yellowAccent,
      Colors.cyan,
      Colors.purpleAccent,
      Colors.orange,
      Colors.deepOrangeAccent,
      Colors.deepPurpleAccent,
      Colors.lightGreen,
      Colors.grey,
    ]);
    corbalao = listaCorBalao.elementAt(sortearNumero(listaCorBalao.length));
  }

  sortearNumero(int tamanhoLista) {
    int randomNumber = random.nextInt(tamanhoLista);
    return randomNumber;
  }

  validarAcerto() async {
    String gesto = "";
    gesto = await MetodosAuxiliares.recuperarGestoSorteado();
    if (gesto.contains(widget.planeta.nomePlaneta)) {
      MetodosAuxiliares.confirmarAcerto(Constantes.msgAcertoGesto);
    } else {
      MetodosAuxiliares.confirmarAcerto(Constantes.msgErroAcertoGesto);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: 80,
            height: 170,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: FloatingActionButton(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            onPressed: () async {
                              validarAcerto();
                            },
                            hoverElevation: 0,
                            focusElevation: 0,
                            child: Image(
                              color: corbalao,
                              height: 80,
                              width: 80,
                              image: AssetImage(
                                  '${CaminhosImagens.balaoCabelaImagem}.png'),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 20,
                            left: 15,
                            child: Center(
                                child: SizedBox(
                              width: 50,
                              height: 50,
                              child: FloatingActionButton(
                                elevation: 0,
                                backgroundColor: corbalao,
                                onPressed: () async {
                                  validarAcerto();
                                },
                                hoverElevation: 0,
                                child: Image(
                                  height: 50,
                                  width: 50,
                                  image: AssetImage(
                                      '${widget.planeta.caminhoImagem}.png'),
                                ),
                              ),
                            ))),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Image(
                        height: 80,
                        width: 60,
                        image: AssetImage(
                            '${CaminhosImagens.balaoCaldaImagem}.png'),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ],
    );
  }
}
