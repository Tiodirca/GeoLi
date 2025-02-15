import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Widgets/gestos_widget.dart';

import '../../Uteis/textos.dart';

class WidgetAreaGestos extends StatefulWidget {
  WidgetAreaGestos({
    super.key,
    required this.estadoGestoMap,
    required this.gestos,
    required this.nomeColecao,
    required this.exibirTelaCarregamento,
  });

  bool exibirTelaCarregamento;
  List<Gestos> gestos;
  String nomeColecao;
  Map<Estado, Gestos> estadoGestoMap;

  @override
  State<WidgetAreaGestos> createState() => _WidgetAreaGestosState();
}

class _WidgetAreaGestosState extends State<WidgetAreaGestos> {
  String nomeRota = "";
  int ponto = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recuperarPontuacao();
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
      print(e.toString());
    }
  }

  // metodo para fazer atualizacao no banco de dado
  // toda vez que o usuario acertar o estado correto
  atualizarDadosBanco() async {
    validarRegiao(widget.nomeColecao);
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
      print(e.toString());
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
              widget.gestos.removeWhere(
                (element) {
                  return element.nomeGesto == gesto.nomeGesto;
                },
              );
            });
            atualizarDadosBanco();
            atualizarPontuacao();
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
      child: SizedBox(
          height: 160,
          child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Column(
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
              ))),
    );
  }
}
