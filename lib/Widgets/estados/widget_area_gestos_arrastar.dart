import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/constantes_estados_gestos.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Widgets/gestos_widget.dart';
import 'package:geoli/Widgets/widget_msg_tutoriais.dart';

import '../../Uteis/textos.dart';

class WidgetAreaGestosArrastar extends StatefulWidget {
  const WidgetAreaGestosArrastar({
    super.key,
    required this.estadoGestoMap,
    required this.gestos,
    required this.nomeColecao,
    required this.exibirTelaCarregamento,
  });

  final bool exibirTelaCarregamento;
  final List<Gestos> gestos;
  final String nomeColecao;
  final Map<Estado, Gestos> estadoGestoMap;

  @override
  State<WidgetAreaGestosArrastar> createState() =>
      _WidgetAreaGestosArrastarState();
}

class _WidgetAreaGestosArrastarState extends State<WidgetAreaGestosArrastar>
    with SingleTickerProviderStateMixin {
  String nomeRota = "";
  int ponto = 0;
  bool exibirMsgTutorial = false;

  late final AnimationController _controllerFade =
      AnimationController(vsync: this);
  late final Animation<double> _fadeAnimation =
      Tween<double>(begin: 1, end: 0.0).animate(_controllerFade);
  late String status;

  @override
  void initState() {
    super.initState();
    recuperarPontuacao();
  }

  @override
  void dispose() {
    _controllerFade.stop(canceled: true);
    super.dispose();
  }

  verificarStatusTutorial() async {
    status = await MetodosAuxiliares.recuperarStatusTutorial();
    if (status == Constantes.statusTutorialAtivo) {
      _controllerFade.repeat(count: 1000, period: Duration(milliseconds: 800));
      setState(() {
        exibirMsgTutorial = true;
      });
    }
  }

  // metodo para recuperar a pontuacao
  recuperarPontuacao() async {
    var db = FirebaseFirestore.instance;
    //instanciano variavel
    db
        .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
        .doc(Constantes
            .fireBaseDocumentoPontosJogadaRegioes) // passando documento
        .get()
        .then(
      (querySnapshot) async {
        querySnapshot.data()!.forEach(
          (key, value) {
            setState(() {
              ponto = value;
              verificarStatusTutorial();
              validarRegiao(widget.nomeColecao);
            });
          },
        );
      },
    );
  }

  atualizarPontuacao() async {
    ponto = ponto + 1;
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
          .doc(Constantes
              .fireBaseDocumentoPontosJogadaRegioes) //passando o documento
          .set({Constantes.pontosJogada: ponto});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // metodo para fazer atualizacao no banco de dado
  // toda vez que o usuario acertar o estado correto
  atualizarDadosBanco() async {
    Map<String, dynamic> dados = {};
    widget.estadoGestoMap.forEach(
      (key, value) {
        dados[key.nome] = key.acerto;
      },
    );

    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
          .doc(widget.nomeColecao) //passando o documento
          .set(dados);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  validarRegiao(String nome) {
    if (widget.nomeColecao == Constantes.fireBaseDocumentoRegiaoCentroOeste) {
      nomeRota = Constantes.rotaTelaRegiaoCentroOeste;
    } else if (widget.nomeColecao == Constantes.fireBaseDocumentoRegiaoSul) {
      nomeRota = Constantes.rotaTelaRegiaoSul;
    } else if (widget.nomeColecao ==
        Constantes.fireBaseDocumentoRegiaoSudeste) {
      nomeRota = Constantes.rotaTelaRegiaoSudeste;
    } else if (widget.nomeColecao == Constantes.fireBaseDocumentoRegiaoNorte) {
      nomeRota = Constantes.rotaTelaRegiaoNorte;
    } else if (widget.nomeColecao ==
        Constantes.fireBaseDocumentoRegiaoNordeste) {
      nomeRota = Constantes.rotaTelaRegiaoNordeste;
    } else if (widget.nomeColecao ==
        Constantes.fireBaseDocumentoRegiaoTodosEstados) {
      nomeRota = Constantes.rotaTelaRegiaoTodosEstados;
    }
  }

  Widget itemSoltar(Gestos gesto) => Draggable(
        onDragCompleted: () async {
          // variavel vai receber o retorno do metodo para poder
          // verificar se o usuario acertou o gesto no estado correto
          String retorno = await MetodosAuxiliares.recuperarAcerto();
          if (retorno == Constantes.msgAcertoGesto) {
            // caso tenha acertado ele ira remover da
            // lista de gestos o gesto que foi acertado
            setState(() {
              if (status != Constantes.statusTutorialAtivo) {
                atualizarDadosBanco();
              }
              atualizarPontuacao();
              MetodosAuxiliares.passarStatusTutorial("");
              MetodosAuxiliares.passarPontuacaoAtual(ponto);
              widget.gestos.removeWhere(
                (element) {
                  return element.nomeGesto == gesto.nomeGesto;
                },
              );
            });

            if (widget.gestos.isEmpty) {
              Navigator.pushReplacementNamed(context, nomeRota);
            }
          }
        },
        maxSimultaneousDrags: 1,
        data: gesto.nomeGesto,
        feedback: GestosWidget(
          nomeGestoImagem: gesto.nomeImagem,
          nomeGesto: gesto.nomeGesto,
          exibirAcerto: false,
        ),
        rootOverlay: true,
        onDragStarted: () {
          if (status == Constantes.statusTutorialAtivo) {
            setState(() {
              exibirMsgTutorial = false;
            });
          }
        },
        onDraggableCanceled: (velocity, offset) {
          if (status == Constantes.statusTutorialAtivo) {
            setState(() {
              exibirMsgTutorial = true;
            });
          }
        },
        childWhenDragging: Container(),
        child: GestosWidget(
          nomeGestoImagem: gesto.nomeImagem,
          nomeGesto: gesto.nomeGesto,
          exibirAcerto: false,
        ),
      );

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    return Visibility(
      visible: !widget.exibirTelaCarregamento,
      child: Container(
          color: Colors.white,
          height: 160,
          child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: ConstantesEstadosGestos.corPadraoRegioes),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Textos.descricaoAreaGestos,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: larguraTela,
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.gestos.length,
                          itemBuilder: (context, index) {
                            return itemSoltar(
                              widget.gestos.elementAt(index),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                      visible: exibirMsgTutorial,
                      child: Container(
                          margin: EdgeInsets.only(left: 90),
                          height: 160,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Container(
                                    transform: Matrix4.rotationZ(12 // here
                                        ),
                                    child: Image(
                                      width: 50,
                                      height: 50,
                                      image: AssetImage(
                                          '${CaminhosImagens.iconeClick}.png'),
                                    ),
                                  )),
                              WidgetMsgTutoriais(
                                  corBorda: ConstantesEstadosGestos.corPadraoRegioes,
                                  mensagem: Textos.tutorialRegioesClickArraste)
                            ],
                          )))
                ],
              ))),
    );
  }
}
