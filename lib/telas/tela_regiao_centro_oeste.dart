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
import 'dart:math';
import '../Uteis/textos.dart';

class TelaRegiaoCentroOeste extends StatefulWidget {
  const TelaRegiaoCentroOeste({super.key});

  @override
  State<TelaRegiaoCentroOeste> createState() => _TelaRegiaoCentroOesteState();
}

class _TelaRegiaoCentroOesteState extends State<TelaRegiaoCentroOeste> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  Estado estadoGO = Estado(
      nome: Constantes.nomeRegiaoCentroGO,
      caminhoImagem: CaminhosImagens.regiaoCentroGOImagem,
      acerto: false);
  Estado estadoMG = Estado(
      nome: Constantes.nomeRegiaoCentroMG,
      caminhoImagem: CaminhosImagens.regiaoCentroMGImagem,
      acerto: false);
  Estado estadoMS = Estado(
      nome: Constantes.nomeRegiaoCentroMS,
      caminhoImagem: CaminhosImagens.regiaoCentroMSImagem,
      acerto: false);

  Gestos gestoGO = Gestos(
      nomeGesto: Constantes.nomeRegiaoCentroGO,
      nomeImagem: CaminhosImagens.gestoCentroGO);
  Gestos gestoMG = Gestos(
      nomeGesto: Constantes.nomeRegiaoCentroMG,
      nomeImagem: CaminhosImagens.gestoCentroMG);
  Gestos gestoMS = Gestos(
      nomeGesto: Constantes.nomeRegiaoCentroMS,
      nomeImagem: CaminhosImagens.gestoCentroMS);
  List<Estado> estadosCentro = [];
  List<Gestos> gestosCentro = [];
  bool exibirTelaCarregamento = true;
  bool exibirTelaProximoNivel = false;
  Random random = new Random();
  List<int> auxiliarPosicao = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // carregando os estados e gestos nas listas utilizadas para exibicao
    estadosCentro.addAll([estadoGO, estadoMS, estadoMG]);
    gestosCentro.addAll([gestoGO, gestoMG, gestoMS]);
    gestosCentro.shuffle();
    // chamando metodo para fazer busca no banco de dados
    realizarBuscaDadosFireBase(Constantes.fireBaseDocumentoRegiaoCentroOeste);
  }

  //metodo para realizar busca no bando de dados
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
              if (estadoMG.nome == key) {
                MetodosAuxiliares.removerGestoLista(
                    estadoMG, value, gestosCentro);
              } else if (estadoMS.nome == key) {
                MetodosAuxiliares.removerGestoLista(
                    estadoMS, value, gestosCentro);
              } else if (estadoGO.nome == key) {
                MetodosAuxiliares.removerGestoLista(
                    estadoGO, value, gestosCentro);
              }
            });
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
                child: Text(Textos.tituloTelaRegiaoCentro)),
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
                          SizedBox(
                            width: larguraTela,
                            height: 100,
                            child: Text(
                              Textos.descricaoAreaEstado,
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
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
