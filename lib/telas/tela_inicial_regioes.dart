import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Modelos/emblemas.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Widgets/emblema_widget.dart';
import 'package:geoli/Widgets/tela_carregamento.dart';

class TelaInicialRegioes extends StatefulWidget {
  const TelaInicialRegioes({super.key});

  @override
  State<TelaInicialRegioes> createState() => _TelaInicialRegioesState();
}

class _TelaInicialRegioesState extends State<TelaInicialRegioes> {
  Estado regiaoCentroOeste = Estado(
      nome: Constantes.nomeRegiaoCentroOeste,
      caminhoImagem: CaminhosImagens.gestoCentroOesteImagem,
      acerto: true);
  Estado regiaoSul = Estado(
      nome: Constantes.nomeRegiaoSul,
      caminhoImagem: CaminhosImagens.gestoSulImagem,
      acerto: false);
  Estado regiaoSudeste = Estado(
      nome: Constantes.nomeRegiaoSudeste,
      caminhoImagem: CaminhosImagens.gestoSudesteImagem,
      acerto: false);
  Estado regiaoNorte = Estado(
      nome: Constantes.nomeRegiaoNorte,
      caminhoImagem: CaminhosImagens.gestoNorteImagem,
      acerto: false);
  Estado regiaoNordeste = Estado(
      nome: Constantes.nomeRegiaoNordeste,
      caminhoImagem: CaminhosImagens.gestoNordesteImagem,
      acerto: false);

  Estado todasRegioes = Estado(
      nome: Textos.btnTodosEstados,
      caminhoImagem: CaminhosImagens.gestoRegioesImagem,
      acerto: false);
  int pontos = 0;
  String caminhaoEmblemaAtual = CaminhosImagens.emblemaEstadosEntusiastaum;
  String nomeEmblema = Textos.emblemaEstadosEntusiastaum;
  bool exibirTelaCarregamento = true;
  bool exibirTelaEmblemas = false;
  bool exibirListaEmblemas = false;
  List<Emblemas> emblemasExibir = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recuperarRegioesLiberadas();
    recuperarPontuacao();

    emblemasExibir.addAll({
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaEstadosEntusiastaum,
          nomeEmblema: Textos.emblemaEstadosEntusiastaum,
          pontos: 0),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaEstadosEntusiastadois,
          nomeEmblema: Textos.emblemaEstadosEntusiastadois,
          pontos: 5),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaEstadosAventureiroum,
          nomeEmblema: Textos.emblemaEstadosAventureiroum,
          pontos: 10),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaEstadosAventureirodois,
          nomeEmblema: Textos.emblemaEstadosAventureirodois,
          pontos: 20),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaEstadosColecionador,
          nomeEmblema: Textos.emblemaEstadosColecionador,
          pontos: 35),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaEstadosIndiana,
          nomeEmblema: Textos.emblemaEstadosIndiana,
          pontos: 50),
    });
  }

  recuperarRegioesLiberadas() async {
    var db = FirebaseFirestore.instance;
    //instanciano variavel
    db
        .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
        .doc(Constantes.fireBaseDocumentoLiberarEstados) // passando documento
        .get()
        .then(
      (querySnapshot) async {
        // verificando cada item que esta gravado no banco de dados
        querySnapshot.data()!.forEach((key, value) {
          setState(() {
            // verificando se o nome da KEY e igual ao nome passado
            if (regiaoSul.nome == key) {
              regiaoSul.acerto = value;
            } else if (regiaoSudeste.nome == key) {
              regiaoSudeste.acerto = value;
            } else if (regiaoNorte.nome == key) {
              regiaoNorte.acerto = value;
            } else if (regiaoNordeste.nome == key) {
              regiaoNordeste.acerto = value;
            } else if (Constantes.nomeTodosEstados == key) {
              todasRegioes.acerto = value;
            }
          });
        });
        setState(() {
          exibirTelaCarregamento = false;
        });
      },
    );
  }

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
        // verificando cada item que esta gravado no banco de dados
        querySnapshot.data()!.forEach((key, value) {
          setState(() {
            pontos = value;
            exibirEmblemaPontuacao();
          });
        });
      },
    );
  }

  exibirEmblemaPontuacao() {
    setState(() {
      print(pontos);
      if (pontos > 5 && pontos <= 10) {
        caminhaoEmblemaAtual = CaminhosImagens.emblemaEstadosEntusiastadois;
        nomeEmblema = Textos.emblemaEstadosEntusiastadois;
      } else if (pontos > 10 && pontos <= 20) {
        caminhaoEmblemaAtual = CaminhosImagens.emblemaEstadosAventureiroum;
        nomeEmblema = Textos.emblemaEstadosAventureiroum;
      } else if (pontos > 20 && pontos <= 35) {
        caminhaoEmblemaAtual = CaminhosImagens.emblemaEstadosAventureirodois;
        nomeEmblema = Textos.emblemaEstadosAventureirodois;
      } else if (pontos > 35 && pontos <= 50) {
        nomeEmblema = Textos.emblemaEstadosColecionador;
        caminhaoEmblemaAtual = CaminhosImagens.emblemaEstadosColecionador;
      } else if (pontos > 50) {
        nomeEmblema = Textos.emblemaEstadosIndiana;
        caminhaoEmblemaAtual = CaminhosImagens.emblemaEstadosIndiana;
      }
    });
  }

  Widget cartaoRegiao(String nomeImagem, String nomeRegiao) => Container(
        margin: EdgeInsets.only(bottom: 10, left: 10.0, right: 10.0),
        width: 150,
        height: 170,
        child: FloatingActionButton(
          heroTag: nomeRegiao,
          backgroundColor: Colors.white,
          onPressed: () {
            if (nomeRegiao == regiaoCentroOeste.nome) {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaRegiaoCentroOeste);
            } else if (nomeRegiao == regiaoSul.nome) {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaRegiaoSul);
            } else if (nomeRegiao == regiaoSudeste.nome) {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaRegiaoSudeste);
            } else if (nomeRegiao == regiaoNorte.nome) {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaRegiaoNorte);
            } else if (nomeRegiao == regiaoNordeste.nome) {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaRegiaoNordeste);
            } else if (nomeRegiao == todasRegioes.nome) {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaRegiaoTodosEstados);
            }
          },
          shape: RoundedRectangleBorder(
              side: BorderSide(color: PaletaCores.corOuro, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(40))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                height: 110,
                width: 110,
                image: AssetImage("$nomeImagem.png"),
              ),
              Text(
                nomeRegiao,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (exibirTelaCarregamento) {
          return TelaCarregamento();
        } else {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text(Textos.tituloTelaRegioes),
                leading: IconButton(
                    color: Colors.black,
                    //setando tamanho do icone
                    iconSize: 30,
                    enableFeedback: false,
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, Constantes.rotaTelaInicial);
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
              ),
              body: Container(
                  color: Colors.white,
                  width: larguraTela,
                  height: alturaTela,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        SizedBox(
                            width: larguraTela,
                            child: Text(
                              Textos.descricaoTelaRegioes,
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            )),
                        Wrap(
                          children: [
                            cartaoRegiao(regiaoCentroOeste.caminhoImagem,
                                regiaoCentroOeste.nome),
                            Visibility(
                                visible: regiaoSul.acerto,
                                child: cartaoRegiao(
                                    regiaoSul.caminhoImagem, regiaoSul.nome)),
                            Visibility(
                                visible: regiaoSudeste.acerto,
                                child: cartaoRegiao(regiaoSudeste.caminhoImagem,
                                    regiaoSudeste.nome)),
                            Visibility(
                                visible: regiaoNorte.acerto,
                                child: cartaoRegiao(regiaoNorte.caminhoImagem,
                                    regiaoNorte.nome)),
                            Visibility(
                                visible: regiaoNordeste.acerto,
                                child: cartaoRegiao(
                                    regiaoNordeste.caminhoImagem,
                                    regiaoNordeste.nome)),
                            Visibility(
                                visible: todasRegioes.acerto,
                                child: cartaoRegiao(todasRegioes.caminhoImagem,
                                    todasRegioes.nome)),
                          ],
                        ),
                      ],
                    ),
                  )),
              bottomSheet: AnimatedContainer(
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            children: [
                              EmblemaWidget(
                                  pontos: pontos,
                                  caminhoImagem: caminhaoEmblemaAtual,
                                  nomeEmblema: nomeEmblema),
                              SizedBox(
                                width: 100,
                                height: 40,
                                child: FloatingActionButton(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    side: BorderSide(
                                        color: PaletaCores.corAzulMagenta),
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
                                  child: Text(Textos.btnEmblemas),
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
                                borderRadius: BorderRadius.circular(10),
                                border: Border(
                                    top: BorderSide(width: 1),
                                    left: BorderSide(width: 1),
                                    right: BorderSide(width: 1),
                                    bottom: BorderSide(width: 1)),
                              ),
                              width: larguraTela * 0.9,
                              height: 420,
                              child: ListView.builder(
                                itemCount: emblemasExibir.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    color: Colors.white,
                                    child: EmblemaWidget(
                                        caminhoImagem: emblemasExibir
                                            .elementAt(index)
                                            .caminhoImagem,
                                        nomeEmblema: emblemasExibir
                                            .elementAt(index)
                                            .nomeEmblema,
                                        pontos: emblemasExibir
                                            .elementAt(index)
                                            .pontos),
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
                  )));
        }
      },
    );
  }
}
