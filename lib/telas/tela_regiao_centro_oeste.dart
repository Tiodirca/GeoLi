import 'package:flutter/material.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Widgets/area_soltar.dart';
import 'package:geoli/Widgets/gestos_widget.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoli/Widgets/tela_carregamento.dart';
import 'package:geoli/Widgets/tela_proximo_jogar_novamente.dart';

import '../Uteis/textos.dart';

class TelaRegiaoCentroOeste extends StatefulWidget {
  const TelaRegiaoCentroOeste({super.key});

  @override
  State<TelaRegiaoCentroOeste> createState() => _TelaRegiaoCentroOesteState();
}

class _TelaRegiaoCentroOesteState extends State<TelaRegiaoCentroOeste> {
  Estado estadoGO = Estado(
      nome: Constantes.nomeRegiaoCentroGO,
      caminhoImagem: Constantes.regiaoCentroGOImagem,
      acerto: false);
  Estado estadoMG = Estado(
      nome: Constantes.nomeRegiaoCentroMG,
      caminhoImagem: Constantes.regiaoCentroMGImagem,
      acerto: false);
  Estado estadoMS = Estado(
      nome: Constantes.nomeRegiaoCentroMS,
      caminhoImagem: Constantes.regiaoCentroMSImagem,
      acerto: false);

  Gestos gestoGO = Gestos(
      nomeGesto: Constantes.nomeRegiaoCentroGO,
      nomeImagem: Constantes.gestoCentroGO);
  Gestos gestoMG = Gestos(
      nomeGesto: Constantes.nomeRegiaoCentroMG,
      nomeImagem: Constantes.gestoCentroMG);
  Gestos gestoMS = Gestos(
      nomeGesto: Constantes.nomeRegiaoCentroMS,
      nomeImagem: Constantes.gestoCentroMS);

  List<Estado> estadosCentro = [];
  List<Gestos> gestosCentro = [];
  bool exibirTelaCarregamento = true;
  bool exibirTelaProximoNivel = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    estadosCentro.addAll([estadoGO, estadoMS, estadoMG]);
    gestosCentro.addAll([gestoGO, gestoMG, gestoMS]);
    realizarBuscaDadosFireBase();
  }

  // metodo para cadastrar item
  atualizarDadosBanco() async {
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
          .doc(Constantes
              .fireBaseDocumentoRegiaoCentroOeste) //passando o documento
          .set({
        Constantes.nomeRegiaoCentroGO: estadoGO.acerto,
        Constantes.nomeRegiaoCentroMG: estadoMG.acerto,
        Constantes.nomeRegiaoCentroMS: estadoMS.acerto,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  realizarBuscaDadosFireBase() async {
    var db = FirebaseFirestore.instance;
    //instanciano variavel
    db
        .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
        .doc(Constantes.fireBaseDocumentoRegiaoCentroOeste)
        .get()
        .then(
      (querySnapshot) async {
        querySnapshot.data()!.forEach(
          (key, value) {
            if (estadoMG.nome == key) {
              setState(() {
                estadoMG.acerto = value;
                if (value) {
                  gestosCentro.removeWhere(
                    (element) {
                      return element.nomeGesto == estadoMG.nome;
                    },
                  );
                }
              });
            } else if (estadoMS.nome == key) {
              setState(() {
                estadoMS.acerto = value;
                if (value) {
                  gestosCentro.removeWhere(
                    (element) {
                      return element.nomeGesto == estadoMS.nome;
                    },
                  );
                }
              });
            } else if (estadoGO.nome == key) {
              setState(() {
                estadoGO.acerto = value;
                if (value) {
                  gestosCentro.removeWhere(
                    (element) {
                      return element.nomeGesto == estadoGO.nome;
                    },
                  );
                }
              });
            }
          },
        );
        setState(
          () {
            exibirTelaCarregamento = false;
          },
        );
      },
    );
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

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
            if(gestosCentro.isEmpty){
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
            title: Text(Textos.tituloTelaRegiaoCentro),
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
                  child: Stack(
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(),
                          AreaSoltar(
                            estado: estadoGO,
                            gesto: gestoGO,
                          ),
                          AreaSoltar(
                            estado: estadoMG,
                            gesto: gestoMG,
                          ),
                          AreaSoltar(
                            estado: estadoMS,
                            gesto: gestoMS,
                          ),
                        ],
                      ),
                      Positioned(
                        child: Center(
                            child: Visibility(
                          visible: exibirTelaProximoNivel,
                          child: TelaProximoNivel(
                              nomeNivel: Constantes.nomeRegiaoCentroOeste),
                        )),
                      )
                    ],
                  ));
            }
          },
        ),
        bottomNavigationBar: Visibility(
          visible: !exibirTelaCarregamento,
          child: SizedBox(
              width: larguraTela,
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
