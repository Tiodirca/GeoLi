import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geoli/Modelos/emblemas.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Widgets/emblema_widget.dart';
import 'package:geoli/Widgets/mapa_regioes_widget.dart';

class WidgetExibirEmblemas extends StatefulWidget {
  const WidgetExibirEmblemas(
      {super.key,
      required this.listaEmblemas,
      required this.corBordas,
      required this.pontuacaoAtual,
      required this.nomeBtn});

  final List<Emblemas> listaEmblemas;
  final Color corBordas;
  final int pontuacaoAtual;
  final String nomeBtn;

  @override
  State<WidgetExibirEmblemas> createState() => _WidgetExibirEmblemasState();
}

class _WidgetExibirEmblemasState extends State<WidgetExibirEmblemas> {
  bool exibirTela = false;
  bool exibirAreaInternaTela = false;
  bool exibirMapaRegioes = false;
  bool exibirSistemaSolar = false;
  late int indexEmblemaAtual = 0;

  exibirEmblemaAtual(int pontuacaoAtual) {
    late Emblemas emblemas;
    for (int i = 0; i < widget.listaEmblemas.length; i++) {
      if (widget.listaEmblemas.elementAt(i).pontos <= pontuacaoAtual) {
        emblemas = widget.listaEmblemas.elementAt(i);
      }
    }
    return emblemas;
  }

  Widget btnAcao(bool visibilidade, String nomeBtn, bool desativarBtn) =>
      Visibility(
          visible: visibilidade,
          child: SizedBox(
            width: 80,
            height: 40,
            child: FloatingActionButton(
              heroTag: nomeBtn,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                side: BorderSide(color: widget.corBordas),
              ),
              backgroundColor: Colors.white,
              onPressed: () {
                setState(() {
                  exibirTela = true;
                  Future.delayed(Duration(seconds: 1)).then(
                    (value) {
                      setState(() {
                        exibirAreaInternaTela = true;
                        if (nomeBtn == Textos.btnRegioesMapa) {
                          exibirMapaRegioes = true;
                        } else if (nomeBtn == Textos.btnSistemaSolar) {
                          exibirSistemaSolar = true;
                        } else {
                          exibirSistemaSolar = false;
                          exibirMapaRegioes = false;
                        }
                      });
                    },
                  );
                });
              },
              child: Text(
                nomeBtn,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ));

  validarAltura(double alturaTela) {
    if (exibirMapaRegioes == true) {
      return exibirTela ? alturaTela * 0.9 : 60.toDouble();
    } else {
      return exibirTela ? alturaTela * 0.7 : 60.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    return AnimatedContainer(
        color: Colors.white,
        width: larguraTela,
        height: exibirTela ? alturaTela * 0.7 : 60,
        duration: const Duration(seconds: 1),
        child: Column(
          children: [
            SizedBox(
              width: larguraTela,
              height: 60,
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: Platform.isAndroid || Platform.isIOS
                          ? larguraTela * 0.5
                          : larguraTela * 0.2,
                      height: 60,
                      child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          MetodosAuxiliares.recuperarPontuacaoAtual().then(
                            (value) {
                              setState(() {
                                indexEmblemaAtual = value;
                              });
                            },
                          );
                          return EmblemaWidget(
                              caminhoImagem:
                                  exibirEmblemaAtual(indexEmblemaAtual)
                                      .caminhoImagem,
                              nomeEmblema: exibirEmblemaAtual(indexEmblemaAtual)
                                  .nomeEmblema,
                              pontos: widget.pontuacaoAtual);
                        },
                      ),
                    ),
                    btnAcao(true, Textos.btnEmblemas, !exibirTela),
                    btnAcao(
                        widget.nomeBtn == Textos.btnRegioesMapa ||
                                widget.nomeBtn == Textos.btnSistemaSolar
                            ? true
                            : false,
                        widget.nomeBtn,
                        !exibirTela)
                  ],
                ),
              ),
            ),
            Visibility(
              visible: exibirAreaInternaTela,
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border(
                            top: BorderSide(width: 1, color: widget.corBordas),
                            left: BorderSide(width: 1, color: widget.corBordas),
                            right:
                                BorderSide(width: 1, color: widget.corBordas),
                            bottom:
                                BorderSide(width: 1, color: widget.corBordas)),
                      ),
                      width: larguraTela * 0.9,
                      height: 420,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          if (exibirMapaRegioes) {
                            return MapaRegioesWidget();
                          } else {
                            return ListView.builder(
                              itemCount: widget.listaEmblemas.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  shadowColor: widget.corBordas,
                                  color: Colors.white,
                                  child: EmblemaWidget(
                                      caminhoImagem: widget.listaEmblemas
                                          .elementAt(index)
                                          .caminhoImagem,
                                      nomeEmblema: widget.listaEmblemas
                                          .elementAt(index)
                                          .nomeEmblema,
                                      pontos: widget.listaEmblemas
                                          .elementAt(index)
                                          .pontos),
                                );
                              },
                            );
                          }
                        },
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 40,
                    height: 40,
                    child: FloatingActionButton(
                      heroTag: exibirAreaInternaTela.toString(),
                      backgroundColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          exibirTela = false;
                          exibirAreaInternaTela = false;
                          validarAltura(alturaTela);
                        });
                      },
                      child: Icon(
                        Icons.close,
                        size: 30,
                        color: PaletaCores.corVermelha,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
