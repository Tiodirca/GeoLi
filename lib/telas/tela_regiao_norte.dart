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

class TelaRegiaoNorte extends StatefulWidget {
  const TelaRegiaoNorte({super.key});

  @override
  State<TelaRegiaoNorte> createState() => _TelaRegiaoNorteState();
}

class _TelaRegiaoNorteState extends State<TelaRegiaoNorte> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  Estado estadoAC = Estado(
      nome: Constantes.nomeRegiaoNorteAC,
      caminhoImagem: CaminhosImagens.regiaoNorteACImagem,
      acerto: false);
  Estado estadoAP = Estado(
      nome: Constantes.nomeRegiaoNorteAP,
      caminhoImagem: CaminhosImagens.regiaoNorteAPImagem,
      acerto: false);
  Estado estadoAM = Estado(
      nome: Constantes.nomeRegiaoNorteAM,
      caminhoImagem: CaminhosImagens.regiaoNorteAMImagem,
      acerto: false);
  Estado estadoPA = Estado(
      nome: Constantes.nomeRegiaoNortePA,
      caminhoImagem: CaminhosImagens.regiaoNortePAImagem,
      acerto: false);
  Estado estadoRO = Estado(
      nome: Constantes.nomeRegiaoNorteRO,
      caminhoImagem: CaminhosImagens.regiaoNorteROImagem,
      acerto: false);
  Estado estadoRR = Estado(
      nome: Constantes.nomeRegiaoNorteRR,
      caminhoImagem: CaminhosImagens.regiaoNorteRRImagem,
      acerto: false);
  Estado estadoTO = Estado(
      nome: Constantes.nomeRegiaoNorteTO,
      caminhoImagem: CaminhosImagens.regiaoNorteTOImagem,
      acerto: false);

  Gestos gestoAC = Gestos(
      nomeGesto: Constantes.nomeRegiaoNorteAC,
      nomeImagem: CaminhosImagens.gestoNorteACImagem);
  Gestos gestoAP = Gestos(
      nomeGesto: Constantes.nomeRegiaoNorteAP,
      nomeImagem: CaminhosImagens.gestoNorteACImagem);
  Gestos gestoAM = Gestos(
      nomeGesto: Constantes.nomeRegiaoNorteAM,
      nomeImagem: CaminhosImagens.gestoNorteAMImagem);
  Gestos gestoPA = Gestos(
      nomeGesto: Constantes.nomeRegiaoNortePA,
      nomeImagem: CaminhosImagens.gestoNortePAImagem);
  Gestos gestoRO = Gestos(
      nomeGesto: Constantes.nomeRegiaoNorteRO,
      nomeImagem: CaminhosImagens.gestoNorteROImagem);
  Gestos gestoRR = Gestos(
      nomeGesto: Constantes.nomeRegiaoNorteRR,
      nomeImagem: CaminhosImagens.gestoNorteRRImagem);
  Gestos gestoTO = Gestos(
      nomeGesto: Constantes.nomeRegiaoNorteTO,
      nomeImagem: CaminhosImagens.gestoNorteTOImagem);

  List<Estado> estadosCentro = [];
  List<Gestos> gestosCentro = [];
  bool exibirTelaCarregamento = true;
  bool exibirTelaProximoNivel = false;
  String nomeTela = Constantes.nomeRegiaoNorte;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // carregando os estados e gestos nas listas utilizadas para exibicao
    estadosCentro.addAll(
        [estadoAC, estadoAP, estadoAM, estadoPA, estadoRO, estadoRR, estadoTO]);
    gestosCentro.addAll(
        [gestoAC, gestoAP, gestoAM, gestoPA, gestoRO, gestoRR, gestoTO]);
    // chamando metodo para fazer busca no banco de dados
    realizarBuscaDadosFireBase(Constantes.fireBaseDocumentoRegiaoNorte);
  }

  //metodo para realizar busca no bando de dados
  atualizarDadosBanco() async {
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
          .doc(Constantes.fireBaseDocumentoRegiaoNorte) //passando o documento
          .set({
        Constantes.nomeRegiaoNorteAC: estadoAC.acerto,
        Constantes.nomeRegiaoNorteAP: estadoAP.acerto,
        Constantes.nomeRegiaoNorteAM: estadoAM.acerto,
        Constantes.nomeRegiaoNortePA: estadoPA.acerto,
        Constantes.nomeRegiaoNorteRO: estadoRO.acerto,
        Constantes.nomeRegiaoNorteRR: estadoRR.acerto,
        Constantes.nomeRegiaoNorteTO: estadoTO.acerto,
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
            if (estadoAC.nome == key) {
              setState(() {
                // definindo que a variavel vai receber o seguinte valor
                estadoAC.acerto = value;
                if (value) {
                  // caso a variavel for TRUE remover o item da lista
                  gestosCentro.removeWhere(
                    (element) {
                      return element.nomeGesto == estadoAC.nome;
                    },
                  );
                }
              });
            } else if (estadoAP.nome == key) {
              setState(() {
                estadoAP.acerto = value;
                if (value) {
                  gestosCentro.removeWhere(
                    (element) {
                      return element.nomeGesto == estadoAP.nome;
                    },
                  );
                }
              });
            } else if (estadoAM.nome == key) {
              setState(() {
                estadoAM.acerto = value;
                if (value) {
                  gestosCentro.removeWhere(
                    (element) {
                      return element.nomeGesto == estadoAM.nome;
                    },
                  );
                }
              });
            } else if (estadoPA.nome == key) {
              setState(() {
                estadoPA.acerto = value;
                if (value) {
                  gestosCentro.removeWhere(
                    (element) {
                      return element.nomeGesto == estadoPA.nome;
                    },
                  );
                }
              });
            } else if (estadoRO.nome == key) {
              setState(() {
                estadoRO.acerto = value;
                if (value) {
                  gestosCentro.removeWhere(
                    (element) {
                      return element.nomeGesto == estadoRO.nome;
                    },
                  );
                }
              });
            } else if (estadoRR.nome == key) {
              setState(() {
                estadoRR.acerto = value;
                if (value) {
                  gestosCentro.removeWhere(
                    (element) {
                      return element.nomeGesto == estadoRR.nome;
                    },
                  );
                }
              });
            } else if (estadoTO.nome == key) {
              setState(() {
                estadoTO.acerto = value;
                if (value) {
                  gestosCentro.removeWhere(
                    (element) {
                      return element.nomeGesto == estadoTO.nome;
                    },
                  );
                }
              });
            }
          },
        );
        setState(
          () {
            if (gestosCentro.isEmpty) {
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
              gestosCentro.removeWhere(
                (element) {
                  return element.nomeGesto == gesto.nomeGesto;
                },
              );
            });
            if (gestosCentro.isEmpty) {
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
                child: Text(Textos.tituloTelaRegiaoNorte)),
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
                      Container(
                        width: Platform.isAndroid || Platform.isIOS
                            ? larguraTela
                            : larguraTela * 0.6,
                        height: alturaTela*0.6,
                        child: SingleChildScrollView(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  AreaSoltar(
                                    estado: estadoAC,
                                    gesto: gestoAC,
                                  ),
                                  AreaSoltar(
                                    estado: estadoAP,
                                    gesto: gestoAP,
                                  ),
                                  AreaSoltar(
                                    estado: estadoAM,
                                    gesto: gestoAM,
                                  ),
                                  AreaSoltar(
                                    estado: estadoPA,
                                    gesto: gestoPA,
                                  ),
                                  AreaSoltar(
                                    estado: estadoRO,
                                    gesto: gestoRO,
                                  ),
                                  AreaSoltar(
                                    estado: estadoRR,
                                    gesto: gestoRR,
                                  ),
                                  AreaSoltar(
                                    estado: estadoTO,
                                    gesto: gestoTO,
                                  ),
                                ],
                              ),
                              Positioned(
                                child: Center(
                                    child: Visibility(
                                  visible: exibirTelaProximoNivel,
                                  child: TelaProximoNivel(nomeNivel: nomeTela),
                                )),
                              )
                            ],
                          ),
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
                          itemCount: gestosCentro.length,
                          itemBuilder: (context, index) {
                            return itemSoltar(
                              gestosCentro.elementAt(index),
                            );
                          },
                        ),
                      ),
                    ],
                  ))),
        ));
  }
}
