import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Modelos/emblemas.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Widgets/sistema_solar/area_animacao_baloes.dart';
import 'package:geoli/Widgets/area_exibir_emblemas.dart';
import 'package:geoli/Widgets/emblema_widget.dart';
import 'package:geoli/Widgets/gestos_widget.dart';
import 'package:geoli/Widgets/tela_carregamento.dart';
import 'package:geoli/modelos/planeta.dart';

class TelaSistemaSolar extends StatefulWidget {
  const TelaSistemaSolar({super.key});

  @override
  State<TelaSistemaSolar> createState() => _TelaSistemaSolarState();
}

class _TelaSistemaSolarState extends State<TelaSistemaSolar>
    with TickerProviderStateMixin {
  bool exibirTelaCarregamento = true;
  bool exibirJogo = false;
  List<Gestos> gestoPlanetasSistemaSolar = [];
  List<Planeta> planetas = [];
  late Gestos gestoSorteado;
  int tempo = 0;
  bool playPauseJogo = false;
  int pontuacao = 0;
  int pontuacaoTotal = 0;
  int tamanhoVidas = 3;
  late Timer iniciarTempo;
  late String iniciarAnimacao;
  String caminhaoEmblemaAtual = CaminhosImagens.emblemaSistemaSolarNovato;
  String nomeEmblema = Textos.emblemaSistemaSolarNovato;
  List<Emblemas> emblemasExibir = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    planetas.addAll([
      Planeta(
          nomePlaneta: Textos.nomePlanetaMercurio,
          caminhoImagem: CaminhosImagens.planetaMercurioImagem),
      Planeta(
          nomePlaneta: Textos.nomePlanetaVenus,
          caminhoImagem: CaminhosImagens.planetaVenusImagem),
      Planeta(
          nomePlaneta: Textos.nomePlanetaTerra,
          caminhoImagem: CaminhosImagens.planetaTerraImagem),
      Planeta(
          nomePlaneta: Textos.nomePlanetaMarte,
          caminhoImagem: CaminhosImagens.planetaMarteImagem),
      Planeta(
          nomePlaneta: Textos.nomePlanetaJupiter,
          caminhoImagem: CaminhosImagens.planetaJupiterImagem),
      Planeta(
          nomePlaneta: Textos.nomePlanetaSaturno,
          caminhoImagem: CaminhosImagens.planetaSaturnoImagem),
      Planeta(
          nomePlaneta: Textos.nomePlanetaUrano,
          caminhoImagem: CaminhosImagens.planetaUranoImagem),
      Planeta(
          nomePlaneta: Textos.nomePlanetaNetuno,
          caminhoImagem: CaminhosImagens.planetaNetunoImagem),
    ]);
    gestoPlanetasSistemaSolar.addAll([
      Gestos(
          nomeGesto: Textos.nomePlanetaMercurio,
          nomeImagem: CaminhosImagens.gestoPlanetaMercurioImagem),
      Gestos(
          nomeGesto: Textos.nomePlanetaVenus,
          nomeImagem: CaminhosImagens.gestoPlanetaVenusImagem),
      Gestos(
          nomeGesto: Textos.nomePlanetaTerra,
          nomeImagem: CaminhosImagens.gestoPlanetaTerraImagem),
      Gestos(
          nomeGesto: Textos.nomePlanetaMarte,
          nomeImagem: CaminhosImagens.gestoPlanetaMarteImagem),
      Gestos(
          nomeGesto: Textos.nomePlanetaJupiter,
          nomeImagem: CaminhosImagens.gestoPlanetaJupiterImagem),
      Gestos(
          nomeGesto: Textos.nomePlanetaSaturno,
          nomeImagem: CaminhosImagens.gestoPlanetaSaturnoImagem),
      Gestos(
          nomeGesto: Textos.nomePlanetaUrano,
          nomeImagem: CaminhosImagens.gestoPlanetaUranoImagem),
      Gestos(
          nomeGesto: Textos.nomePlanetaNetuno,
          nomeImagem: CaminhosImagens.gestoPlanetaNetunoImagem),
    ]);

    emblemasExibir.addAll({
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaSistemaSolarNovato,
          nomeEmblema: Textos.emblemaSistemaSolarNovato,
          pontos: 0),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaSistemaSolarAmador,
          nomeEmblema: Textos.emblemaSistemaSolarAmador,
          pontos: 5),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaSistemaSolarMaster,
          nomeEmblema: Textos.emblemaSistemaSolarMaster,
          pontos: 10),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaSistemaSolarMegaMaster,
          nomeEmblema: Textos.emblemaSistemaSolarMegaMaster,
          pontos: 20),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaSistemaSolarSemiProfissional,
          nomeEmblema: Textos.emblemaSistemaSolarSemiProfissional,
          pontos: 35),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaSistemaSolarProfissional,
          nomeEmblema: Textos.emblemaSistemaSolarProfissional,
          pontos: 50),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaSistemaSolarKakarot,
          nomeEmblema: Textos.emblemaSistemaSolarKakarot,
          pontos: 100),
    });
    planetas.shuffle();
    sortearGesto();
    recuperarPontuacao();
  }

  //metodo para sortear gesto
  sortearGesto() {
    Random random = Random();
    gestoSorteado = gestoPlanetasSistemaSolar
        .elementAt(random.nextInt(gestoPlanetasSistemaSolar.length));
    //chamando metodo para passar o nome do gesto sorteado
    MetodosAuxiliares.passarGestoSorteado(gestoSorteado.nomeGesto);
  }

  void comecarTempo() {
    const segundo = const Duration(seconds: 1);
    iniciarTempo = Timer.periodic(
      segundo,
      (timer) {
        if (tempo == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          if (mounted) {
            setState(() {
              tempo--;
            });
          }
        }
      },
    );
  }

  //metodo para parar o temporizador
  pararTempo() {
    iniciarTempo.cancel();
  }

  // metodo para recuperar a pontuacao
  recuperarPontuacao() async {
    var db = FirebaseFirestore.instance;
    //instanciano variavel
    db
        .collection(
            Constantes.fireBaseColecaoSistemaSolar) // passando a colecao
        .doc(Constantes
            .fireBaseDocumentoPontosJogadaSistemaSolar) // passando documento
        .get()
        .then(
      (querySnapshot) async {
        querySnapshot.data()!.forEach(
          (key, value) {
            setState(() {
              pontuacaoTotal = value;
              exibirEmblemaPontuacao();
              exibirTelaCarregamento = false;
            });
          },
        );
      },
    );
  }

  //atualizar pontuacao no banco de dados
  atualizarPontuacao() async {
    pontuacaoTotal = pontuacaoTotal + pontuacao;
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(
              Constantes.fireBaseColecaoSistemaSolar) // passando a colecao
          .doc(Constantes
              .fireBaseDocumentoPontosJogadaSistemaSolar) //passando o documento
          .set({Constantes.pontosJogada: pontuacaoTotal});
    } catch (e) {
      print(e.toString());
    }
  }

  // metodo para verificar se o usuario acertou o planeta que foi sorteado no gesto
  recuperarAcertoPlaneta() async {
    //recuperando o valor passado pelo metodo
    String retorno = await MetodosAuxiliares.recuperarAcerto();
    if (retorno == Constantes.msgAcertoGesto) {
      // mudando estado da lista para mudar a ordem dos planetas na lista
      setState(() {
        planetas.shuffle();
        sortearGesto(); //chamando metodo para sortear um novo gesto
        pontuacao++;
        // chamando metodo para exibir mensagem
        MetodosAuxiliares.exibirMensagens(
            Textos.msgAcertou, Constantes.msgAcertoGesto, context);
      });
    } else if (retorno == Constantes.msgErroAcertoGesto) {
      setState(() {
        tamanhoVidas--;
        // chamando metodo para exibir mensagem
        MetodosAuxiliares.exibirMensagens(
            Textos.msgErrou, Constantes.msgErroAcertoGesto, context);
        // caso a quantide de vidas tenha chegado a 0
        if (tamanhoVidas == 0) {
          pararTempo();
          atualizarPontuacao();
        }
      });
    }
    //sobreescrevendo metodo
    MetodosAuxiliares.confirmarAcerto("");
  }

  exibirEmblemaPontuacao() {
    setState(() {
      if (pontuacaoTotal > 5 && pontuacaoTotal <= 10) {
        caminhaoEmblemaAtual = CaminhosImagens.emblemaSistemaSolarAmador;
        nomeEmblema = Textos.emblemaSistemaSolarAmador;
      } else if (pontuacaoTotal > 10 && pontuacaoTotal <= 20) {
        caminhaoEmblemaAtual = CaminhosImagens.emblemaSistemaSolarMaster;
        nomeEmblema = Textos.emblemaSistemaSolarMaster;
      } else if (pontuacaoTotal > 20 && pontuacaoTotal <= 35) {
        caminhaoEmblemaAtual = CaminhosImagens.emblemaSistemaSolarMegaMaster;
        nomeEmblema = Textos.emblemaSistemaSolarMegaMaster;
      } else if (pontuacaoTotal > 35 && pontuacaoTotal <= 50) {
        nomeEmblema = Textos.emblemaSistemaSolarSemiProfissional;
        caminhaoEmblemaAtual =
            CaminhosImagens.emblemaSistemaSolarSemiProfissional;
      } else if (pontuacaoTotal > 50 && pontuacaoTotal <= 70) {
        nomeEmblema = Textos.emblemaSistemaSolarProfissional;
        caminhaoEmblemaAtual = CaminhosImagens.emblemaSistemaSolarProfissional;
      } else if (pontuacaoTotal > 100) {
        nomeEmblema = Textos.emblemaSistemaSolarKakarot;
        caminhaoEmblemaAtual = CaminhosImagens.emblemaSistemaSolarKakarot;
      }
    });
  }

  Widget btnDificuldade(String nomeDificuldade) => Container(
      margin: EdgeInsets.all(10),
      width: 100,
      height: 50,
      child: FloatingActionButton(
          elevation: 0,
          heroTag: nomeDificuldade,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            side: BorderSide(color: PaletaCores.corAzul),
          ),
          onPressed: () {
            setState(() {
              if (nomeDificuldade == Textos.btnDificuldadeFacil) {
                tempo = Constantes.tempoFacil;
              } else if (nomeDificuldade == Textos.btnDificuldadeMedio) {
                tamanhoVidas = 2;
                tempo = Constantes.tempoMedio;
              } else if (nomeDificuldade == Textos.btnDificuldadeDificil) {
                tamanhoVidas = 1;
                tempo = Constantes.tempoDificl;
              }
              comecarTempo();
              exibirJogo = true;
              iniciarAnimacao = Constantes.statusAnimacaoIniciar;
            });
          },
          child: Text(nomeDificuldade)));

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    //double alturaBarraStatus = MediaQuery.of(context).padding.top;
    //double alturaAppBar = AppBar().preferredSize.height;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (exibirTelaCarregamento) {
          return TelaCarregamento();
        } else {
          return Scaffold(
              appBar: AppBar(
                  backgroundColor: PaletaCores.corAzulEscuro,
                  title: LayoutBuilder(
                    builder: (context, constraints) {
                      if (exibirJogo) {
                        return SizedBox(
                          width: larguraTela,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        Textos.telaSistemaSolarPontuacao,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        pontuacao.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        Textos.telaSistemaSolarVidas,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      SizedBox(
                                        width: 80,
                                        height: 30,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: tamanhoVidas,
                                          itemBuilder: (context, index) {
                                            return Icon(
                                              Icons.favorite,
                                              color: PaletaCores.corVermelha,
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    Textos
                                        .telaSistemaSolarDescricaoTemporizador,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    tempo.toString(),
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (tamanhoVidas != 0 && tempo != 0) {
                                            print("Entrou");
                                            playPauseJogo = !playPauseJogo;
                                            if (playPauseJogo) {
                                              iniciarAnimacao = Constantes
                                                  .statusAnimacaoPausada;
                                              pararTempo();
                                            } else {
                                              iniciarAnimacao = Constantes
                                                  .statusAnimacaoIniciar;
                                              comecarTempo();
                                            }
                                          }
                                        });
                                      },
                                      icon: Icon(
                                          color: Colors.white,
                                          playPauseJogo
                                              ? Icons.play_arrow
                                              : Icons.pause))
                                ],
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Text(
                          Textos.telaSistemaSolarTitulo,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      }
                    },
                  ),
                  leading: IconButton(
                      color: Colors.white,
                      //setando tamanho do icone
                      iconSize: 30,
                      enableFeedback: false,
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, Constantes.rotaTelaInicial);
                      },
                      icon: const Icon(Icons.arrow_back_ios))),
              body: LayoutBuilder(
                builder: (context, constraints) {
                  if (exibirJogo) {
                    final Size biggest = constraints.biggest;
                    // chamando metodo para ficar
                    // verificando a todo o momento se o usuario acertou o planeta
                    recuperarAcertoPlaneta();
                    return AreaAnimacaoBaloes(
                      biggest: biggest,
                      planetas: planetas,
                      statusAnimacao: iniciarAnimacao,
                      quantidadeVidas: tamanhoVidas,
                      tempo: tempo,
                    );
                  } else {
                    return Container(
                      color: Colors.white,
                      width: larguraTela,
                      height: alturaTela,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              Textos.descricaoTelaInicialSistemaSolar,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ),
                          SizedBox(
                            height: 400,
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.center,
                              children: [
                                btnDificuldade(Textos.btnDificuldadeFacil),
                                btnDificuldade(Textos.btnDificuldadeMedio),
                                btnDificuldade(Textos.btnDificuldadeDificil),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
              bottomSheet: LayoutBuilder(
                builder: (context, constraints) {
                  if (exibirJogo) {
                    return Container(
                      color: Colors.white,
                      width: Platform.isAndroid || Platform.isIOS
                          ? larguraTela * 0.5
                          : larguraTela * 0.2,
                      height: Platform.isAndroid || Platform.isIOS ? 130 : 150,
                      child: Card(
                        color: Colors.white,
                        margin: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: PaletaCores.corAzulMagenta, width: 1),
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(40),
                                topLeft: Radius.circular(40))),
                        child: Column(
                          children: [
                            Text(
                              Textos.telaSistemaSolarDescricaoPlanetaSorteado,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: Platform.isAndroid || Platform.isIOS
                                  ? 100
                                  : 120,
                              child: GestosWidget(
                                  nomeGestoImagem: gestoSorteado.nomeImagem,
                                  nomeGesto: gestoSorteado.nomeGesto,
                                  exibirAcerto: false),
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return ExibirEmblemas(
                        corBordas: PaletaCores.corAzulEscuro,
                        listaEmblemas: emblemasExibir,
                        emblemaWidget: EmblemaWidget(
                            caminhoImagem: caminhaoEmblemaAtual,
                            nomeEmblema: nomeEmblema,
                            pontos: pontuacaoTotal));
                  }
                },
              ));
        }
      },
    );
  }
}
