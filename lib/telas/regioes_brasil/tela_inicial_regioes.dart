import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Modelos/emblemas.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Widgets/emblema_widget.dart';
import 'package:geoli/Widgets/exibir_emblemas.dart';
import 'package:geoli/Widgets/tela_carregamento.dart';

class TelaInicialRegioes extends StatefulWidget {
  const TelaInicialRegioes({super.key});

  @override
  State<TelaInicialRegioes> createState() => _TelaInicialRegioesState();
}

class _TelaInicialRegioesState extends State<TelaInicialRegioes> {
  Estado regiaoCentroOeste = Estado(
      nome: Textos.nomeRegiaoCentroOeste,
      caminhoImagem: CaminhosImagens.gestoCentroOesteImagem,
      acerto: true);
  Estado regiaoSul = Estado(
      nome: Textos.nomeRegiaoSul,
      caminhoImagem: CaminhosImagens.gestoSulImagem,
      acerto: false);
  Estado regiaoSudeste = Estado(
      nome: Textos.nomeRegiaoSudeste,
      caminhoImagem: CaminhosImagens.gestoSudesteImagem,
      acerto: false);
  Estado regiaoNorte = Estado(
      nome: Textos.nomeRegiaoNorte,
      caminhoImagem: CaminhosImagens.gestoNorteImagem,
      acerto: false);
  Estado regiaoNordeste = Estado(
      nome: Textos.nomeRegiaoNordeste,
      caminhoImagem: CaminhosImagens.gestoNordesteImagem,
      acerto: false);

  Estado todasRegioes = Estado(
      nome: Textos.btnTodosEstados,
      caminhoImagem: CaminhosImagens.gestoRegioesImagem,
      acerto: false);
  int pontos = 0;
  bool exibirTelaCarregamento = true;
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
            MetodosAuxiliares.passarPontuacaoAtual(pontos);
          });
        });
      },
    );
  }

  Widget cartaoRegiao(String nomeImagem, String nomeRegiao) => Container(
        margin: EdgeInsets.only(bottom: 10, left: 10.0, right: 10.0),
        width: 150,
        height: 170,
        child: FloatingActionButton(
          elevation: 0,
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
                        Container(
                            margin: EdgeInsets.only(bottom: 10),
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
              bottomSheet: ExibirEmblemas(
                pontuacaoAtual: pontos,
                corBordas: PaletaCores.corAzulEscuro,
                listaEmblemas: emblemasExibir,
              ));
        }
      },
    );
  }
}
