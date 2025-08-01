import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/variaveis_constantes/constantes.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/passar_pegar_dados.dart.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Uteis/variaveis_constantes/constantes_estados_gestos.dart';
import 'package:geoli/Uteis/variaveis_constantes/constantes_sistema_solar.dart';
import 'package:geoli/Widgets/tela_carregamento_widget.dart';
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
  bool exibirTelaCarregamento = false;
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
  late String uidUsuario;

  @override
  void initState() {
    super.initState();
    dadosTodasRegioes.addEntries(dadosRegiaoCentroOeste.entries);
    dadosTodasRegioes.addEntries(dadosRegiaoSul.entries);
    dadosTodasRegioes.addEntries(dadosRegiaoSudeste.entries);
    dadosTodasRegioes.addEntries(dadosRegiaoNordeste.entries);
    dadosTodasRegioes.addEntries(dadosRegiaoNorte.entries);
    recuperarUIDUsuario();
  }

  recuperarUIDUsuario() async {
    uidUsuario = await PassarPegarDados.recuperarInformacoesUsuario()
        .values
        .elementAt(0);
  }

  // metodo para zerar todas as informacoes
  // no banco de dados do usuario
  Future<bool> gravarBancoDadosInformacoesResetados(String nomeColecao,
      String nomeDocumento, Map<String, dynamic> dados) async {
    bool retorno = false;
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      await db
          .collection(Constantes.fireBaseColecaoUsuarios) // passando a colecao
          .doc(uidUsuario)
          .collection(nomeColecao) // passando a colecao
          .doc(nomeDocumento) //passando o documento
          .set(dados)
          .then((value) {
        retorno = true;
      }, onError: (e) {
        retorno = false;
        chamarValidarErro(e.toString());
        debugPrint("GRON${e.toString()}");
      });
    } catch (e) {
      retorno = false;
      chamarValidarErro(e.toString());
      debugPrint("GR${e.toString()}");
    }
    return retorno;
  }

  // metodo para gravar no banco de dados que o planeta foi bloqueado
  Future<bool> bloquearPlanetasDesbloqueados() async {
    bool retorno = false;
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
      await db
          .collection(Constantes.fireBaseColecaoUsuarios) // passando a colecao
          .doc(uidUsuario)
          .collection(
              Constantes.fireBaseColecaoSistemaSolar) // passando a colecao
          .doc(Constantes
              .fireBaseDocumentoPlanetasDesbloqueados) //passando o documento
          .set(dados)
          .then((value) {
        retorno = true;
      }, onError: (e) {
        retorno = false;
        chamarValidarErro(e.toString());
        debugPrint("BPON${e.toString()}");
      });
    } catch (e) {
      retorno = false;
      chamarValidarErro(e.toString());
      debugPrint("BP${e.toString()}");
    }
    return retorno;
  }

  chamarValidarErro(String erro) {
    MetodosAuxiliares.validarErro(erro, context);
  }

  Future<bool> reiniciarDadosRegioes() async {
    bool retorno = false;
    bool retornoPontuacao = await gravarBancoDadosInformacoesResetados(
        Constantes.fireBaseColecaoRegioes,
        Constantes.fireBaseDocumentoPontosJogadaRegioes,
        dadosPontuacao);
    bool retornoBloqueioNiveis = await gravarBancoDadosInformacoesResetados(
        Constantes.fireBaseColecaoRegioes,
        Constantes.fireBaseDocumentoLiberarEstados,
        dadosBloquearNiveisRegioes);
    bool retornoCentroOeste = await gravarBancoDadosInformacoesResetados(
        Constantes.fireBaseColecaoRegioes,
        Constantes.fireBaseDocumentoRegiaoCentroOeste,
        dadosRegiaoCentroOeste);
    bool retornoSul = await gravarBancoDadosInformacoesResetados(
        Constantes.fireBaseColecaoRegioes,
        Constantes.fireBaseDocumentoRegiaoSul,
        dadosRegiaoSul);
    bool retornoSudeste = await gravarBancoDadosInformacoesResetados(
        Constantes.fireBaseColecaoRegioes,
        Constantes.fireBaseDocumentoRegiaoSudeste,
        dadosRegiaoSudeste);
    bool retornoNorte = await gravarBancoDadosInformacoesResetados(
        Constantes.fireBaseColecaoRegioes,
        Constantes.fireBaseDocumentoRegiaoNorte,
        dadosRegiaoNorte);
    bool retornoNordeste = await gravarBancoDadosInformacoesResetados(
        Constantes.fireBaseColecaoRegioes,
        Constantes.fireBaseDocumentoRegiaoNordeste,
        dadosRegiaoNordeste);
    bool retornoTodasRegioes = await gravarBancoDadosInformacoesResetados(
        Constantes.fireBaseColecaoRegioes,
        Constantes.fireBaseDocumentoRegiaoTodosEstados,
        dadosTodasRegioes);

    if (retornoPontuacao &&
        retornoBloqueioNiveis &&
        retornoCentroOeste &&
        retornoSul &&
        retornoSudeste &&
        retornoNorte &&
        retornoNordeste &&
        retornoTodasRegioes) {
      retorno = true;
    } else {
      retorno = false;
    }
    return retorno;
  }

  Future<bool> reiniciarDadosSistemaSolar() async {
    bool retorno = false;
    bool retornoBloqueioPlanetas = await bloquearPlanetasDesbloqueados();
    bool retornoGravarInformacacoes =
        await gravarBancoDadosInformacoesResetados(
            Constantes.fireBaseColecaoSistemaSolar,
            Constantes.fireBaseDocumentoPontosJogadaSistemaSolar,
            dadosPontuacao);
    if (retornoBloqueioPlanetas && retornoGravarInformacacoes) {
      retorno = true;
    } else {
      retorno = false;
    }
    return retorno;
  }

  recarregarTelaRegioes() {
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicialRegioes);
  }

  recarregarTelaInicial() {
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
  }

  recarregarTelaSistemaSolar() {
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaSistemaSolar);
  }

  validarTipoAcaoAlertaExclusao() async {
    setState(() {
      exibirTelaCarregamento = true;
    });
    if (widget.tipoAcao == Constantes.resetarAcaoExcluirTudo) {
      bool retornoSistemaSolar = await reiniciarDadosSistemaSolar();
      bool retornoRegioes = await reiniciarDadosRegioes();
      if (retornoSistemaSolar && retornoRegioes) {
        recarregarTelaInicial();
      }
    } else if (widget.tipoAcao == Constantes.resetarAcaoExcluirSistemaSolar) {
      bool retorno = await reiniciarDadosSistemaSolar();
      if (retorno) {
        recarregarTelaSistemaSolar();
      }
    } else {
      bool retorno = await reiniciarDadosRegioes();
      if (retorno) {
        recarregarTelaRegioes();
      }
    }
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
              child: Column(
                children: [
                  Image(
                    height: 90,
                    width: 90,
                    image: AssetImage("${CaminhosImagens.gestoCancelar}.png"),
                  ),
                  Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Column(
                children: [
                  Image(
                    height: 90,
                    width: 90,
                    image: AssetImage("${CaminhosImagens.gestoSim}.png"),
                  ),
                  Text(
                    'Sim',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                  validarTipoAcaoAlertaExclusao();
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
        width: kIsWeb
            ? larguraTela
            : Platform.isAndroid || Platform.isIOS
                ? larguraTela
                : larguraTela * 0.4,
        height: 250,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (exibirTelaCarregamento) {
              return TelaCarregamentoWidget(corPadrao: widget.corCard);
            } else {
              return SingleChildScrollView(
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
                              margin: EdgeInsets.only(top: 10),
                              width: 130,
                              height: 130,
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      height: 90,
                                      width: 90,
                                      image: AssetImage(
                                          "${CaminhosImagens.gestoExcluir}.png"),
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
                    )),
              );
            }
          },
        ));
  }
}
