import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Widgets/balao_widget.dart';
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
  bool exibirTelaCarregamento = false;
  bool exibirJogo = false;
  bool exibirTelaEmblemas = false;
  bool exibirListaEmblemas = false;
  List<Gestos> gestoPlanetasSistemaSolar = [];
  List<Planeta> planetas = [];
  late Gestos gestoSorteado;
  int gestoAnterior = 0;
  int tempo = 0;
  Random random = Random();
  List<Color> listaCorBalao = [];
  late Planeta planetaSorteado;
  int sortear = 0;
  late final AnimationController _controller = AnimationController(vsync: this);
  late final AnimationController _controller2 =
      AnimationController(vsync: this);
  late final AnimationController _controller3 =
      AnimationController(vsync: this);
  late final AnimationController _controller4 =
      AnimationController(vsync: this);
  late final AnimationController _controller5 =
      AnimationController(vsync: this);
  late final AnimationController _controller6 =
      AnimationController(vsync: this);
  late final AnimationController _controller7 =
      AnimationController(vsync: this);
  late final AnimationController _controller8 =
      AnimationController(vsync: this);
  late final AnimationController _controller9 =
      AnimationController(vsync: this);
  late final AnimationController _controller10 =
      AnimationController(vsync: this);
  late final AnimationController _controller11 =
      AnimationController(vsync: this);
  late final AnimationController _controller12 =
      AnimationController(vsync: this);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listaCorBalao.addAll([
      Colors.redAccent,
      Colors.pinkAccent,
      Colors.blue,
      Colors.greenAccent,
      Colors.yellowAccent,
      Colors.cyan,
      Colors.purpleAccent,
      Colors.orange,
      Colors.deepOrangeAccent,
      Colors.deepPurpleAccent,
      Colors.lightGreen,
      Colors.grey,
    ]);

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
    gestoAnterior = sortearNumero(gestoPlanetasSistemaSolar.length);
    gestoSorteado = gestoPlanetasSistemaSolar.elementAt(gestoAnterior);

    MetodosAuxiliares.passarGestoSorteado(gestoSorteado.nomeGesto);
  }

  // sortearPlanetas() {
  //   int index = 0;
  //   sortear++;
  //   if (sortear < 24) {
  //     index = sortearNumero(planetas.length);
  //     print(sortear);
  //     print(planetas.elementAt(index).nomePlaneta);
  //     return planetas.elementAt(index);
  //   }
  //
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cancelarAnimacaoBalao();
  }

  cancelarAnimacaoBalao() {
    MetodosAuxiliares.passarGestoSorteado("");
    _controller.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    _controller6.dispose();
    _controller7.dispose();
    _controller8.dispose();
    _controller9.dispose();
    _controller10.dispose();
    _controller11.dispose();
    _controller12.dispose();
  }

  // metodo para iniciar a animacao dos baloes
  iniciarBalao(AnimationController primeiroBalaoControle, int duracaoAnimacao,
      AnimationController segundoBalaoControle, int delay) {
    // iniciando
    primeiroBalaoControle.repeat(
        count: 60, period: Duration(seconds: duracaoAnimacao));
    Future.delayed(Duration(seconds: delay), () {
      segundoBalaoControle.repeat(
          count: 60, period: Duration(seconds: duracaoAnimacao));
    });
  }

  sortearNumero(int tamanhoLista) {
    int randomNumber = random.nextInt(tamanhoLista);
    return randomNumber;
  }

  void comecarTempo() {
    const segundo = const Duration(seconds: 1);
    Timer iniciarTempo = Timer.periodic(
      segundo,
      (Timer timer) {
        if (tempo == 0) {
          setState(() {
            timer.cancel();
            cancelarAnimacaoBalao();
          });
        } else {
          setState(() {
            tempo--;
          });
        }
      },
    );
  }

  Widget baloes(
    double tamanhoTela,
    Size biggest,
    double distacia,
    AnimationController controle,
    String nomeBalao,
  ) =>
      PositionedTransition(
          rect: RelativeRectTween(
                  begin: RelativeRect.fromSize(
                      // passando a Distancia um do outro
                      // o tamanho da tela onde a animacao ira ocorrer
                      Rect.fromLTWH(distacia, tamanhoTela, 80, tamanhoTela),
                      biggest),
                  end: RelativeRect.fromSize(
                      Rect.fromLTWH(distacia, 0, 80, tamanhoTela), biggest))
              .animate(CurvedAnimation(
            parent: controle,
            curve: Curves.linear,
          )),
          child: Column(
            children: [BalaoWidget(), Text(nomeBalao)],
          ));

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
              exibirJogo = true;
              if (nomeDificuldade == Textos.btnDificuldadeFacil) {
                tempo = Constantes.tempoFacil;
              } else if (nomeDificuldade == Textos.btnDificuldadeMedio) {
                tempo = Constantes.tempoMedio;
              } else if (nomeDificuldade == Textos.btnDificuldadeDificil) {
                tempo = Constantes.tempoDificl;
              }

              comecarTempo();
              iniciarBalao(_controller, 4, _controller2, 1);
              iniciarBalao(_controller3, 4, _controller4, 1);
              iniciarBalao(_controller5, 4, _controller6, 1);
              Future.delayed(Duration(seconds: 2), () {
                iniciarBalao(_controller7, 4, _controller8, 1);
                iniciarBalao(_controller9, 4, _controller10, 1);
                iniciarBalao(_controller11, 4, _controller12, 1);
              });
            });
          },
          child: Text(nomeDificuldade)));

  teste() async {
    await MetodosAuxiliares.recuperarAcerto();
  }

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
                title: Text(
                  Textos.telaSistemaSolarTitulo,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                leading: IconButton(
                    color: Colors.white,
                    //setando tamanho do icone
                    iconSize: 30,
                    enableFeedback: false,
                    onPressed: () {
                      cancelarAnimacaoBalao();
                      Navigator.pushReplacementNamed(
                          context, Constantes.rotaTelaInicial);
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
              ),
              body: LayoutBuilder(
                builder: (context, constraints) {
                  if (exibirJogo) {
                    final Size biggest = constraints.biggest;
                    return Container(
                      color: Colors.white,
                      width: larguraTela,
                      height: alturaTela,
                      child: Column(
                        children: [
                          SizedBox(
                            width: larguraTela,
                            height: 60,
                            child: Column(
                              children: [
                                Text(
                                  Textos.descricaoTemporizador,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  tempo.toString(),
                                  style: TextStyle(
                                      fontSize: 18, color: PaletaCores.corAzul),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: larguraTela,
                            height: alturaTela * 0.8,
                            child: Stack(
                              children: [
                                baloes(
                                    alturaTela, biggest, 0, _controller, "1"),
                                baloes(
                                    alturaTela, biggest, 50, _controller2, "2"),
                                baloes(alturaTela, biggest, 100, _controller3,
                                    "3"),
                                baloes(alturaTela, biggest, 150, _controller4,
                                    "4"),
                                baloes(alturaTela, biggest, 200, _controller5,
                                    "5"),
                                baloes(alturaTela, biggest, 250, _controller6,
                                    "6"),
                                baloes(
                                    alturaTela, biggest, 0, _controller7, "7"),
                                baloes(
                                    alturaTela, biggest, 50, _controller8, "8"),
                                baloes(alturaTela, biggest, 100, _controller9,
                                    "9"),
                                baloes(alturaTela, biggest, 150, _controller10,
                                    "10"),
                                baloes(alturaTela, biggest, 200, _controller11,
                                    "11"),
                                baloes(alturaTela, biggest, 250, _controller12,
                                    "12"),
                                baloes(
                                  alturaTela,
                                  biggest,
                                  300,
                                  _controller,
                                  "1s",
                                ),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    if (Platform.isAndroid || Platform.isIOS) {
                                      return Container();
                                    } else {
                                      return Stack(
                                        children: [
                                          baloes(alturaTela, biggest, 350,
                                              _controller2, "2"),
                                          baloes(alturaTela, biggest, 400,
                                              _controller3, "3s"),
                                          baloes(alturaTela, biggest, 450,
                                              _controller4, "4s"),
                                          baloes(alturaTela, biggest, 500,
                                              _controller5, "5s"),
                                          baloes(alturaTela, biggest, 550,
                                              _controller6, "6s"),
                                          baloes(alturaTela, biggest, 350,
                                              _controller8, "8s"),
                                          baloes(alturaTela, biggest, 400,
                                              _controller9, "9s"),
                                          baloes(alturaTela, biggest, 450,
                                              _controller10, "10s"),
                                          baloes(alturaTela, biggest, 500,
                                              _controller11, "11"),
                                          baloes(alturaTela, biggest, 550,
                                              _controller12, "12"),
                                        ],
                                      );
                                    }
                                  },
                                ),
                                baloes(alturaTela, biggest, 300, _controller7,
                                    "7s"),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                      width: larguraTela,
                      height: Platform.isAndroid || Platform.isIOS ? 130 : 150,
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: PaletaCores.corAzulMagenta, width: 1),
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(40),
                                topLeft: Radius.circular(40))),
                        child: Column(
                          children: [
                            Text(
                              Textos.descricaoPlanetaSorteado,
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
                    return AnimatedContainer(
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Row(
                                  children: [
                                    // EmblemaWidget(
                                    //     pontos: pontos,
                                    //     caminhoImagem: caminhaoEmblemaAtual,
                                    //     nomeEmblema: nomeEmblema),
                                    SizedBox(
                                      width: 100,
                                      height: 40,
                                      child: FloatingActionButton(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          side: BorderSide(
                                              color:
                                                  PaletaCores.corAzulMagenta),
                                        ),
                                        enableFeedback: !exibirListaEmblemas,
                                        backgroundColor: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            exibirTelaEmblemas = true;
                                            Future.delayed(Duration(seconds: 1))
                                                .then(
                                              (value) {
                                                setState(() {
                                                  exibirListaEmblemas = true;
                                                });
                                              },
                                            );
                                          });
                                        },
                                        child: Text(
                                          Textos.btnEmblemas,
                                          style: TextStyle(color: Colors.black),
                                        ),
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
                                    // child: ListView.builder(
                                    //   itemCount: emblemasExibir.length,
                                    //   itemBuilder: (context, index) {
                                    //     return Card(
                                    //       color: Colors.white,
                                    //       child: EmblemaWidget(
                                    //           caminhoImagem: emblemasExibir
                                    //               .elementAt(index)
                                    //               .caminhoImagem,
                                    //           nomeEmblema: emblemasExibir
                                    //               .elementAt(index)
                                    //               .nomeEmblema,
                                    //           pontos: emblemasExibir
                                    //               .elementAt(index)
                                    //               .pontos),
                                    //     );
                                    //   },
                                    // ),
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
                        ));
                  }
                },
              ));
        }
      },
    );
  }
}
