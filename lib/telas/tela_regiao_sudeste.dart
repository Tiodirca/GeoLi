import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/constantes_caminhos_imagens.dart';
import 'package:geoli/Widgets/area_soltar.dart';
import 'package:geoli/Widgets/gestos_widget.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoli/Widgets/tela_carregamento.dart';
import 'package:geoli/Widgets/tela_proximo_nivel.dart';

import '../Uteis/textos.dart';

class TelaRegiaoSudeste extends StatefulWidget {
  const TelaRegiaoSudeste({super.key});

  @override
  State<TelaRegiaoSudeste> createState() => _TelaRegiaoSudesteState();
}

class _TelaRegiaoSudesteState extends State<TelaRegiaoSudeste> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  Estado estadoSP = Estado(
      nome: Constantes.nomeRegiaoSudesteSP,
      caminhoImagem: CaminhosImagens.regiaoSudesteSPImagem,
      acerto: false);
  Estado estadoRJ = Estado(
      nome: Constantes.nomeRegiaoSudesteRJ,
      caminhoImagem: CaminhosImagens.regiaoSudesteRJImagem,
      acerto: false);
  Estado estadoES = Estado(
      nome: Constantes.nomeRegiaoSudesteES,
      caminhoImagem: CaminhosImagens.regiaoSudesteESImagem,
      acerto: false);
  Estado estadoMG = Estado(
      nome: Constantes.nomeRegiaoSudesteMG,
      caminhoImagem: CaminhosImagens.regiaoSudesteMGImagem,
      acerto: false);

  Gestos gestoSP = Gestos(
      nomeGesto: Constantes.nomeRegiaoSudesteSP,
      nomeImagem: CaminhosImagens.gestoSudesteSP);
  Gestos gestoRJ = Gestos(
      nomeGesto: Constantes.nomeRegiaoSudesteRJ,
      nomeImagem: CaminhosImagens.gestoSudesteRJ);
  Gestos gestoES = Gestos(
      nomeGesto: Constantes.nomeRegiaoSudesteES,
      nomeImagem: CaminhosImagens.gestoSudesteES);
  Gestos gestoMG = Gestos(
      nomeGesto: Constantes.nomeRegiaoSudesteMG,
      nomeImagem: CaminhosImagens.gestoSudesteMG);

  Map<Estado, Gestos> estadosMapAuxiliar = {};
  List<MapEntry<Estado, Gestos>> estadosSorteio = [];
  List<Gestos> gestos = [];
  bool exibirTelaCarregamento = true;
  bool exibirTelaProximoNivel = false;
  String nomeTela = Constantes.nomeRegiaoSudeste;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carregarEstados();
    // adicionando itens na lista e fazendo o sorteio dos itens na lista
    gestos.addAll([gestoSP, gestoRJ, gestoMG, gestoES]);
    gestos.shuffle();
    // chamando metodo para fazer busca no banco de dados
    realizarBuscaDadosFireBase(Constantes.fireBaseDocumentoRegiaoSudeste);
  }

  // metodo para adicionar os estados no map auxiliar e depois adicionar numa lista e fazer o sorteio dos itens
  carregarEstados() {
    estadosMapAuxiliar[estadoMG] = gestoMG;
    estadosMapAuxiliar[estadoES] = gestoES;
    estadosMapAuxiliar[estadoSP] = gestoSP;
    estadosMapAuxiliar[estadoRJ] = gestoRJ;
    estadosSorteio = estadosMapAuxiliar.entries.toList();
    estadosSorteio.shuffle();
  }

  //metodo para realizar busca no bando de dados
  atualizarDadosBanco() async {
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
          .doc(Constantes.fireBaseDocumentoRegiaoSudeste) //passando o documento
          .set({
        Constantes.nomeRegiaoSudesteES: estadoES.acerto,
        Constantes.nomeRegiaoSudesteRJ: estadoRJ.acerto,
        Constantes.nomeRegiaoSudesteMG: estadoMG.acerto,
        Constantes.nomeRegiaoSudesteSP: estadoSP.acerto
      });
    } catch (e) {
      print(e.toString());
    }
  }

  realizarBuscaDadosFireBase(String nomeDocumentoRegiao) async {
    var db = FirebaseFirestore.instance;
    //instanciano variavel
    db
        .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
        .doc(nomeDocumentoRegiao) // passando documento
        .get()
        .then(
      (querySnapshot) async {
        // verificando cada item que esta gravado no banco de dados
        querySnapshot.data()!.forEach(
          (key, value) {
            // caso o valor da CHAVE for o mesmo que o nome do ESTADO entrar na condicao
            setState(() {
              if (estadoRJ.nome == key) {
                gestos = MetodosAuxiliares.removerGestoLista(
                    estadoRJ, value, gestos);
              } else if (estadoSP.nome == key) {
                gestos = MetodosAuxiliares.removerGestoLista(
                    estadoSP, value, gestos);
              } else if (estadoES.nome == key) {
                gestos = MetodosAuxiliares.removerGestoLista(
                    estadoES, value, gestos);
              } else if (estadoMG.nome == key) {
                gestos = MetodosAuxiliares.removerGestoLista(
                    estadoMG, value, gestos);
              }
            });
          },
        );
        setState(
          () {
            if (gestos.isEmpty) {
              exibirTelaProximoNivel = true;
            }
            exibirTelaCarregamento = false;
          },
        );
      },
    );
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
              gestos.removeWhere(
                (element) {
                  return element.nomeGesto == gesto.nomeGesto;
                },
              );
            });
            if (gestos.isEmpty) {
              setState(() {
                exibirTelaProximoNivel = true;
              });
            }
            atualizarDadosBanco();
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
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
            title: Visibility(
                visible: !exibirTelaCarregamento,
                child: Text(Textos.tituloTelaRegiaoSudeste)),
            backgroundColor: Colors.white,
            leading: Visibility(
              visible: !exibirTelaCarregamento,
              child: IconButton(
                  color: Colors.black,
                  //setando tamanho do icone
                  iconSize: 30,
                  enableFeedback: false,
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, Constantes.rotaTelaInicialRegioes);
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
            )),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (exibirTelaCarregamento) {
              return TelaCarregamento();
            } else {
              return Container(
                  color: Colors.white,
                  width: larguraTela,
                  height: alturaTela,
                  child: Column(
                    children: [
                      SizedBox(
                        width: larguraTela,
                        child: Text(
                          Textos.descricaoAreaEstado,
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: Platform.isAndroid || Platform.isIOS
                            ? larguraTela
                            : larguraTela * 0.6,
                        height: alturaTela * 0.6,
                        child: GridView.builder(
                          itemCount: estadosSorteio.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      Platform.isAndroid || Platform.isIOS
                                          ? 2
                                          : 5),
                          itemBuilder: (context, index) {
                            return Center(
                                child: AreaSoltar(
                              estado: estadosSorteio.elementAt(index).key,
                              gesto: estadosSorteio.elementAt(index).value,
                            ));
                          },
                        ),
                      )
                    ],
                  ));
            }
          },
        ),
        bottomNavigationBar: Visibility(
          visible: !exibirTelaCarregamento,
          child: SizedBox(
              height: 160,
              child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
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
                          itemCount: gestos.length,
                          itemBuilder: (context, index) {
                            return itemSoltar(
                              gestos.elementAt(index),
                            );
                          },
                        ),
                      ),
                    ],
                  ))),
        ));
  }
}
