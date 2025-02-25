import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/modelos/planeta.dart';

class BalaoWidget extends StatefulWidget {
  const BalaoWidget(
      {super.key, required this.planeta, required this.desativarBotao});

  final Planeta planeta;
  final bool desativarBotao;

  @override
  State<BalaoWidget> createState() => _BalaoWidgetState();
}

class _BalaoWidgetState extends State<BalaoWidget>
    with TickerProviderStateMixin {
  List<Color> listaCorBalao = [];
  Random random = Random();
  late Color corbalao;
  late String status;

  @override
  void initState() {
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
    recuperarStatusTutorial();
  }

  recuperarStatusTutorial() async {
    status = await MetodosAuxiliares.recuperarStatusTutorial();
    print("ST$status");
  }

  sortearNumero(int tamanhoLista) {
    int randomNumber = random.nextInt(tamanhoLista);
    return randomNumber;
  }

  validarAcerto() async {
    String gesto = "";
    gesto = await MetodosAuxiliares.recuperarGestoSorteado();
    if (status == Constantes.statusTutorialAtivo) {
      print("fdsfsd");
      MetodosAuxiliares.exibirMensagens(
          Textos.tutorialConcluido, Constantes.msgAcertoGesto, context);
      MetodosAuxiliares.passarStatusTutorial("");
      atualizarPontuacaoTutorial();
      Timer(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(
            context, Constantes.rotaTelaSistemaSolar);
      });
    } else {
      if (gesto.contains(widget.planeta.nomePlaneta)) {
        MetodosAuxiliares.confirmarAcerto(Constantes.msgAcertoGesto);
      } else {
        MetodosAuxiliares.confirmarAcerto(Constantes.msgErroAcertoGesto);
      }
    }
  }

  atualizarPontuacaoTutorial() async {
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(
              Constantes.fireBaseColecaoSistemaSolar) // passando a colecao
          .doc(Constantes
              .fireBaseDocumentoPontosJogadaSistemaSolar) //passando o documento
          .set({Constantes.pontosJogada: 1});
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                    image:
                        AssetImage('${CaminhosImagens.balaoCaldaImagem}.png'),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
