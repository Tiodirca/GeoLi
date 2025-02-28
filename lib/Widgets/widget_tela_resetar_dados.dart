import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/constantes_estados_gestos.dart';
import 'package:geoli/Uteis/constantes_sistema_solar.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/modelos/planeta.dart';

class WidgetTelaResetarDados extends StatefulWidget {
  const WidgetTelaResetarDados(
      {super.key, required this.tipoAcao, required this.corCard});

  final String tipoAcao;
  final Color corCard;

  @override
  State<WidgetTelaResetarDados> createState() => _WidgetTelaResetarDadosState();
}

class _WidgetTelaResetarDadosState extends State<WidgetTelaResetarDados> {
  Map<String, bool> dadosBloquearNiveisRegioes = {
    Textos.nomeRegiaoSul: false,
    Textos.nomeRegiaoSudeste: false,
    Textos.nomeRegiaoNorte: false,
    Textos.nomeRegiaoNordeste: false,
    Constantes.nomeTodosEstados: false,
  };

  Map<String, bool> dadosRegiaoCentroOeste = {
    ConstantesEstadosGestos.estadoMS.nome: false,
    ConstantesEstadosGestos.estadoGO.nome: false,
    ConstantesEstadosGestos.estadoMT.nome: false,
  };
  Map<String, bool> dadosRegiaoSul = {
    ConstantesEstadosGestos.estadoRS.nome: false,
    ConstantesEstadosGestos.estadoSC.nome: false,
    ConstantesEstadosGestos.estadoPR.nome: false,
  };
  Map<String, bool> dadosRegiaoSudeste = {
    ConstantesEstadosGestos.estadoMG.nome: false,
    ConstantesEstadosGestos.estadoES.nome: false,
    ConstantesEstadosGestos.estadoSP.nome: false,
    ConstantesEstadosGestos.estadoRJ.nome: false,
  };
  Map<String, bool> dadosRegiaoNorte = {
    ConstantesEstadosGestos.estadoAC.nome: false,
    ConstantesEstadosGestos.estadoAP.nome: false,
    ConstantesEstadosGestos.estadoAM.nome: false,
    ConstantesEstadosGestos.estadoPA.nome: false,
    ConstantesEstadosGestos.estadoRO.nome: false,
    ConstantesEstadosGestos.estadoRR.nome: false,
    ConstantesEstadosGestos.estadoTO.nome: false,
  };
  Map<String, bool> dadosRegiaoNordeste = {
    ConstantesEstadosGestos.estadoAL.nome: false,
    ConstantesEstadosGestos.estadoBA.nome: false,
    ConstantesEstadosGestos.estadoCE.nome: false,
    ConstantesEstadosGestos.estadoMA.nome: false,
    ConstantesEstadosGestos.estadoPB.nome: false,
    ConstantesEstadosGestos.estadoPE.nome: false,
    ConstantesEstadosGestos.estadoPI.nome: false,
    ConstantesEstadosGestos.estadoRN.nome: false,
    ConstantesEstadosGestos.estadoSE.nome: false
  };

  Map<String, bool> dadosTodasRegioes = {};
  Map<String, int> dadosPontuacao = {Constantes.pontosJogada: 0};

  @override
  void initState() {
    super.initState();
    dadosTodasRegioes.addEntries(dadosRegiaoCentroOeste.entries);
    dadosTodasRegioes.addEntries(dadosRegiaoSul.entries);
    dadosTodasRegioes.addEntries(dadosRegiaoSudeste.entries);
    dadosTodasRegioes.addEntries(dadosRegiaoNordeste.entries);
    dadosTodasRegioes.addEntries(dadosRegiaoNorte.entries);
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
      debugPrint(e.toString());
    }
  }

  // metodo para gravar no banco de dados que o planeta foi bloqueado
  bloquearPlanetas() {
    List<Planeta> planetas = ConstantesSistemaSolar.adicinarPlanetas();
    Map<String, bool> dados = {};
    // percorrendo a lista para poder jogar os dados dentro de um map
    for (var element in planetas) {
      //definindo que o map vai receber o nome do planeta e o valor boleano
      dados[element.nomePlaneta] = false;
    }
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(
              Constantes.fireBaseColecaoSistemaSolar) // passando a colecao
          .doc(Constantes
              .fireBaseDocumentoPlanetasDesbloqueados) //passando o documento
          .set(dados);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  reiniciarDadosRegioes() {
    gravarDadosResetados(Constantes.fireBaseColecaoRegioes,
        Constantes.fireBaseDocumentoPontosJogadaRegioes, dadosPontuacao);
    gravarDadosResetados(Constantes.fireBaseColecaoRegioes,
        Constantes.fireBaseDocumentoLiberarEstados, dadosBloquearNiveisRegioes);
    gravarDadosResetados(Constantes.fireBaseColecaoRegioes,
        Constantes.fireBaseDocumentoRegiaoCentroOeste, dadosRegiaoCentroOeste);
    gravarDadosResetados(Constantes.fireBaseColecaoRegioes,
        Constantes.fireBaseDocumentoRegiaoSul, dadosRegiaoSul);
    gravarDadosResetados(Constantes.fireBaseColecaoRegioes,
        Constantes.fireBaseDocumentoRegiaoSudeste, dadosRegiaoSudeste);
    gravarDadosResetados(Constantes.fireBaseColecaoRegioes,
        Constantes.fireBaseDocumentoRegiaoNorte, dadosRegiaoNorte);
    gravarDadosResetados(Constantes.fireBaseColecaoRegioes,
        Constantes.fireBaseDocumentoRegiaoNordeste, dadosRegiaoNordeste);
    gravarDadosResetados(Constantes.fireBaseColecaoRegioes,
        Constantes.fireBaseDocumentoRegiaoTodosEstados, dadosTodasRegioes);
  }

  Future<void> alertaExclusao(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            Textos.tituloReiniciarDados,
            style: const TextStyle(color: Colors.black),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  Textos.descricaoAlertExcluir,
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Não',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Sim',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                setState(() {
                  if (widget.tipoAcao == Constantes.resetarAcaoExcluirTudo) {
                    gravarDadosResetados(
                        Constantes.fireBaseColecaoSistemaSolar,
                        Constantes.fireBaseDocumentoPontosJogadaSistemaSolar,
                        dadosPontuacao);
                    reiniciarDadosRegioes();
                    bloquearPlanetas();
                    Future.delayed(Duration(seconds: 1), () {
                      Navigator.pushReplacementNamed(
                          context, Constantes.rotaTelaInicial);
                    });
                  } else if (widget.tipoAcao ==
                      Constantes.resetarAcaoExcluirSistemaSolar) {
                    bloquearPlanetas();
                    gravarDadosResetados(
                        Constantes.fireBaseColecaoSistemaSolar,
                        Constantes.fireBaseDocumentoPontosJogadaSistemaSolar,
                        dadosPontuacao);
                    Navigator.pushReplacementNamed(
                        context, Constantes.rotaTelaSistemaSolar);
                  } else {
                    reiniciarDadosRegioes();
                    Future.delayed(Duration(seconds: 1), () {
                      Navigator.pushReplacementNamed(
                          context, Constantes.rotaTelaInicialRegioes);
                    });
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    return Container(
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
                          alertaExclusao(context);
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
            )));
  }
}
