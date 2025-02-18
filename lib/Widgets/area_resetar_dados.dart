import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/textos.dart';

class AreaResetarDados extends StatefulWidget {
  const AreaResetarDados(
      {super.key, required this.tipoAcao, required this.corCard});

  final String tipoAcao;
  final Color corCard;

  @override
  State<AreaResetarDados> createState() => _AreaResetarDadosState();
}

class _AreaResetarDadosState extends State<AreaResetarDados> {
  Map<String, bool> dadosBloquearNiveisRegioes = {
    Textos.nomeRegiaoSul: false,
    Textos.nomeRegiaoSudeste: false,
    Textos.nomeRegiaoNorte: false,
    Textos.nomeRegiaoNordeste: false,
    Constantes.nomeTodosEstados: false,
  };

  Map<String, int> dadosPontuacao = {Constantes.pontosJogada: 0};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // metodo para cadastrar item
  gravarDadosResetados(String nomeColecao, String nomeDocumento,
      Map<String, dynamic> dados) async {
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(nomeColecao) // passando a colecao
          .doc(nomeDocumento) //passando o documento
          .set(dados);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    return Positioned(
        child: Container(
            margin: EdgeInsets.all(10),
            color: Colors.transparent,
            width: Platform.isAndroid || Platform.isIOS
                ? larguraTela
                : larguraTela * 0.4,
            height: 200,
            child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: widget.corCard),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        Textos.tituloReiniciarDados,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        Textos.descricaoReiniciarDados,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 17),
                      ),
                      Container(
                          margin: EdgeInsets.all(10),
                          width: 200,
                          height: 60,
                          child: FloatingActionButton(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    width: 1, color: widget.corCard)),
                            onPressed: () {
                              if (widget.tipoAcao ==
                                  Constantes.resetarAcaoExcluirTudo) {
                                gravarDadosResetados(
                                    Constantes.fireBaseColecaoSistemaSolar,
                                    Constantes
                                        .fireBaseDocumentoPontosJogadaSistemaSolar,
                                    dadosPontuacao);
                                gravarDadosResetados(
                                    Constantes.fireBaseColecaoRegioes,
                                    Constantes
                                        .fireBaseDocumentoPontosJogadaRegioes,
                                    dadosPontuacao);
                                gravarDadosResetados(
                                    Constantes.fireBaseColecaoRegioes,
                                    Constantes.fireBaseDocumentoLiberarEstados,
                                    dadosBloquearNiveisRegioes);
                                Navigator.pushReplacementNamed(
                                    context, Constantes.rotaTelaInicial);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.reset_tv_outlined,
                                  color: PaletaCores.corVermelha,
                                ),
                                Text(
                                  Textos.btnExcluir,
                                  style: TextStyle(
                                    color: PaletaCores.corVermelha,
                                  ),
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                ))));
  }
}
