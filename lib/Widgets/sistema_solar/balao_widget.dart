import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/modelos/planeta.dart';

class BalaoWidget extends StatefulWidget {
  const BalaoWidget(
      {super.key, required this.planeta, required this.desativarBotao});

  final Planeta planeta;
  final bool desativarBotao;

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
                        Image(
                          color: corbalao,
                          height: 80,
                          width: 80,
                          image: AssetImage(
                              '${CaminhosImagens.balaoCabelaImagem}.png'),
                        ),
                        Positioned(
                          child: SizedBox(
                              width: 80,
                              height: 80,
                              child: FloatingActionButton(
                                shape: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(50)),
                                foregroundColor: Colors.transparent,
                                elevation: 0,
                                hoverElevation: 0,
                                focusElevation: 0,
                                disabledElevation: 0,
                                enableFeedback: false,
                                hoverColor: Colors.transparent,
                                splashColor: corbalao,
                                focusColor: Colors.transparent,
                                backgroundColor: Colors.transparent,
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Image(
                                    height: 50,
                                    width: 50,
                                    image: AssetImage(
                                        '${widget.planeta.caminhoImagem}.png'),
                                  ),
                                ),
                                onPressed: () {
                                  if (!widget.desativarBotao) {
                                    validarAcerto();
                                  }
                                },
                              )),
                        ),
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
