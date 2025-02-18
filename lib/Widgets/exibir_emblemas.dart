import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geoli/Modelos/emblemas.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Widgets/emblema_widget.dart';

class ExibirEmblemas extends StatefulWidget {
  const ExibirEmblemas(
      {super.key,
      required this.listaEmblemas,
      required this.corBordas,
      required this.pontuacaoAtual});

  final List<Emblemas> listaEmblemas;
  final Color corBordas;
  final int pontuacaoAtual;

  @override
  State<ExibirEmblemas> createState() => _ExibirEmblemasState();
}

class _ExibirEmblemasState extends State<ExibirEmblemas> {
  bool exibirTelaEmblemas = false;
  bool exibirListaEmblemas = false;
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

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    return AnimatedContainer(
        color: Colors.white,
        width: larguraTela,
        height: exibirTelaEmblemas ? alturaTela * 0.7 : 60,
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
                      width: Platform.isAndroid || Platform.isIOS ? larguraTela * 0.6 : larguraTela * 0.2,
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
                    SizedBox(
                      width: 100,
                      height: 40,
                      child: FloatingActionButton(
                        heroTag: Textos.btnEmblemas,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          side: BorderSide(color: widget.corBordas),
                        ),
                        enableFeedback: !exibirListaEmblemas,
                        backgroundColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            exibirTelaEmblemas = true;
                            Future.delayed(Duration(seconds: 1)).then(
                              (value) {
                                setState(() {
                                  exibirListaEmblemas = true;
                                });
                              },
                            );
                          });
                        },
                        child: Text(
                          Textos.btnEmblemas,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: exibirListaEmblemas,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border(
                          top: BorderSide(width: 1, color: widget.corBordas),
                          left: BorderSide(width: 1, color: widget.corBordas),
                          right: BorderSide(width: 1, color: widget.corBordas),
                          bottom:
                              BorderSide(width: 1, color: widget.corBordas)),
                    ),
                    width: larguraTela * 0.9,
                    height: 420,
                    child: ListView.builder(
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
                              pontos:
                                  widget.listaEmblemas.elementAt(index).pontos),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 40,
                    height: 40,
                    child: FloatingActionButton(
                      heroTag: exibirListaEmblemas.toString(),
                      backgroundColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          exibirTelaEmblemas = false;
                          exibirListaEmblemas = false;
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
            )
          ],
        ));
  }
}
