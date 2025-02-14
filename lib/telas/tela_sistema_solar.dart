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
import 'package:geoli/Widgets/tela_fim_jogo.dart';
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
  int tempo = 0;
  Random random = Random();
  bool playPauseJogo = false;
  bool exibirTelaFimJogo = false;
  int pontuacao = 0;
  int tamanhoVidas = 3;
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
  late final AnimationController _controller13 =
      AnimationController(vsync: this);
  late final AnimationController _controller14 =
      AnimationController(vsync: this);
  late final AnimationController _controller15 =
      AnimationController(vsync: this);

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
    planetas.shuffle();
    sortearGesto();
  }

  //metodo para sortear gesto
  sortearGesto() {
    gestoSorteado = gestoPlanetasSistemaSolar
        .elementAt(random.nextInt(gestoPlanetasSistemaSolar.length));
    //chamando metodo para passar o nome do gesto sorteado
    MetodosAuxiliares.passarGestoSorteado(gestoSorteado.nomeGesto);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pararAnimacaoBaloes();
    super.dispose();
  }

  pararAnimacaoBaloes() {
    _controller.stop(canceled: false);
    _controller2.stop(canceled: false);
    _controller3.stop(canceled: false);
    _controller4.stop(canceled: false);
    _controller5.stop(canceled: false);
    _controller6.stop(canceled: false);
    _controller7.stop(canceled: false);
    _controller8.stop(canceled: false);
    _controller9.stop(canceled: false);
    _controller10.stop(canceled: false);
    _controller11.stop(canceled: false);
    _controller12.stop(canceled: false);
    _controller13.stop(canceled: false);
    _controller14.stop(canceled: false);
    _controller15.stop(canceled: false);
  }

  retomarAnimacaoBaloes() {
    _controller.forward();
    _controller2.forward();
    _controller3.forward();
    _controller4.forward();
    _controller5.forward();
    _controller6.forward();
    _controller7.forward();
    _controller8.forward();
    _controller9.forward();
    _controller10.forward();
    _controller11.forward();
    _controller12.forward();
    _controller13.forward();
    _controller14.forward();
    _controller15.forward();
  }

  // metodo para iniciar a animacao dos baloes
  iniciarBalao(AnimationController primeiroBalaoControle, int duracaoAnimacao,
      AnimationController segundoBalaoControle, int delay) {
    // iniciando a animacao do primeiro controle
    primeiroBalaoControle.repeat(
        count: 60, period: Duration(seconds: duracaoAnimacao));
    // definindo que havera um delay para comecar a animacao do segundo controle
    Future.delayed(Duration(seconds: delay), () {
      segundoBalaoControle.repeat(
          count: 60, period: Duration(seconds: duracaoAnimacao));
    });
  }

  void comecarTempo() {
    const segundo = const Duration(seconds: 1);
    Timer iniciarTempo = Timer.periodic(
      segundo,
      (Timer timer) {
        if (tempo == 0) {
          setState(() {
            timer.cancel();
            exibirTelaFimJogo = true;
            pararAnimacaoBaloes();
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

  // metodo para verificar se o usuario acertou o planeta que foi sorteado no gesto
  recuperarAcertoPlaneta() async {
    //recuperando o valor passado pelo metodo
    String retorno = await MetodosAuxiliares.recuperarAcerto();
    if (retorno == Constantes.msgAcertoGesto) {
      // mudando estado da lista para mudar a ordem dos planetas na lista
      setState(() {
        planetas.shuffle();
        sortearGesto(); //chamando metodo para sortear um novo gesto

        // definindo que a pontuacao ira aumentar conforme o usuario acerta
        // chamando metodo para exibir mensagem
        pontuacao++;
        // chamando metodo para exibir mensagem
        MetodosAuxiliares.exibirMensagens(
            Textos.msgAcertou, Constantes.msgAcertoGesto, context);
      });
    } else if (retorno == Constantes.msgErroAcertoGesto) {
      setState(() {
        // definindo que a quantidade de vidas ira diminir a cada erro
        tamanhoVidas--;
        // chamando metodo para exibir mensagem
        MetodosAuxiliares.exibirMensagens(
            Textos.msgErrou, Constantes.msgErroAcertoGesto, context);
        // caso a quantide de vidas tenha chegado a 0
        if (tamanhoVidas == 0) {
          pararAnimacaoBaloes();
          exibirTelaFimJogo = true;
        }
      });
    }
    //sobreescrevendo metodo
    MetodosAuxiliares.confirmarAcerto("");
  }

  // metodo para iniciar a animacao dos baloes
  iniciarAnimacoesBaloes() {
    iniciarBalao(_controller, 5, _controller2, 1);
    iniciarBalao(_controller3, 5, _controller4, 1);
    iniciarBalao(_controller5, 5, _controller6, 1);
    // definindo que a animacao ira comecar apos o tempo passado no delay
    Future.delayed(Duration(seconds: 2), () {
      iniciarBalao(_controller7, 5, _controller8, 1);
      iniciarBalao(_controller9, 5, _controller10, 1);
      iniciarBalao(_controller11, 5, _controller12, 1);
    });
    // definindo que a animacao ira comecar apos o tempo passado no delay
    Future.delayed(Duration(milliseconds: 4300), () {
      iniciarBalao(_controller13, 5, _controller14, 0);
      iniciarBalao(_controller15, 5, _controller15, 0);
    });
  }

  Widget baloes(double tamanhoTela, Size biggest, double distacia,
          AnimationController controle, int indexPlaneta) =>
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
          child: BalaoWidget(
            planeta: planetas.elementAt(indexPlaneta),
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
                tamanhoVidas = 2;
                tempo = Constantes.tempoMedio;
              } else if (nomeDificuldade == Textos.btnDificuldadeDificil) {
                tamanhoVidas = 1;
                tempo = Constantes.tempoDificl;
              }
              comecarTempo();
              iniciarAnimacoesBaloes();
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
                                          playPauseJogo = !playPauseJogo;
                                          if (playPauseJogo) {
                                            pararAnimacaoBaloes();
                                          } else {
                                            iniciarAnimacoesBaloes();
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
                    return Container(
                      color: Colors.white,
                      width: larguraTela,
                      height: alturaTela,
                      child: Stack(
                        children: [
                          baloes(alturaTela, biggest, 0, _controller, 0),
                          baloes(
                              alturaTela,
                              biggest,
                              Platform.isAndroid || Platform.isIOS ? 50 : 100,
                              _controller2,
                              1),
                          baloes(
                              alturaTela,
                              biggest,
                              Platform.isAndroid || Platform.isIOS ? 100 : 200,
                              _controller3,
                              2),
                          baloes(
                              alturaTela,
                              biggest,
                              Platform.isAndroid || Platform.isIOS ? 150 : 300,
                              _controller4,
                              3),
                          baloes(
                              alturaTela,
                              biggest,
                              Platform.isAndroid || Platform.isIOS ? 200 : 400,
                              _controller5,
                              4),
                          baloes(
                              alturaTela,
                              biggest,
                              Platform.isAndroid || Platform.isIOS ? 250 : 500,
                              _controller6,
                              5),
                          baloes(alturaTela, biggest, 0, _controller7, 6),
                          baloes(
                              alturaTela,
                              biggest,
                              Platform.isAndroid || Platform.isIOS ? 50 : 100,
                              _controller8,
                              7),
                          baloes(
                              alturaTela,
                              biggest,
                              Platform.isAndroid || Platform.isIOS ? 100 : 200,
                              _controller9,
                              0),
                          baloes(
                              alturaTela,
                              biggest,
                              Platform.isAndroid || Platform.isIOS ? 150 : 300,
                              _controller10,
                              1),
                          baloes(
                              alturaTela,
                              biggest,
                              Platform.isAndroid || Platform.isIOS ? 200 : 400,
                              _controller11,
                              2),
                          baloes(
                              alturaTela,
                              biggest,
                              Platform.isAndroid || Platform.isIOS ? 250 : 500,
                              _controller12,
                              3),
                          baloes(
                              alturaTela,
                              biggest,
                              Platform.isAndroid || Platform.isIOS ? 50 : 100,
                              _controller13,
                              4),
                          baloes(
                              alturaTela,
                              biggest,
                              Platform.isAndroid || Platform.isIOS ? 150 : 300,
                              _controller14,
                              5),
                          baloes(
                              alturaTela,
                              biggest,
                              Platform.isAndroid || Platform.isIOS ? 250 : 500,
                              _controller15,
                              6),
                          baloes(
                            alturaTela,
                            biggest,
                            Platform.isAndroid || Platform.isIOS ? 300 : 600,
                            _controller,
                            4,
                          ),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              if (Platform.isAndroid || Platform.isIOS) {
                                return Container();
                              } else {
                                return Stack(
                                  children: [
                                    baloes(alturaTela, biggest, 700,
                                        _controller2, 5),
                                    baloes(alturaTela, biggest, 800,
                                        _controller3, 6),
                                    baloes(alturaTela, biggest, 900,
                                        _controller4, 7),
                                    baloes(alturaTela, biggest, 1000,
                                        _controller5, 0),
                                    baloes(alturaTela, biggest, 1100,
                                        _controller6, 1),
                                    baloes(alturaTela, biggest, 700,
                                        _controller8, 2),
                                    baloes(alturaTela, biggest, 800,
                                        _controller9, 3),
                                    baloes(alturaTela, biggest, 900,
                                        _controller10, 4),
                                    baloes(alturaTela, biggest, 1000,
                                        _controller11, 5),
                                    baloes(alturaTela, biggest, 1100,
                                        _controller12, 6),
                                    baloes(alturaTela, biggest, 700,
                                        _controller13, 7),
                                    baloes(alturaTela, biggest, 900,
                                        _controller14, 0),
                                    baloes(alturaTela, biggest, 1100,
                                        _controller15, 1),
                                    baloes(
                                      alturaTela,
                                      biggest,
                                      1200,
                                      _controller,
                                      4,
                                    ),
                                    baloes(alturaTela, biggest, 1300,
                                        _controller2, 5),
                                    baloes(alturaTela, biggest, 1400,
                                        _controller3, 6),
                                    baloes(alturaTela, biggest, 1200,
                                        _controller7, 7),
                                    baloes(alturaTela, biggest, 1300,
                                        _controller8, 2),
                                    baloes(alturaTela, biggest, 1400,
                                        _controller9, 3),
                                    baloes(alturaTela, biggest, 1300,
                                        _controller13, 7),
                                  ],
                                );
                              }
                            },
                          ),
                          baloes(
                              alturaTela,
                              biggest,
                              Platform.isAndroid || Platform.isIOS ? 300 : 600,
                              _controller7,
                              7),
                          Positioned(
                              child: Center(
                            child: Visibility(
                                visible: exibirTelaFimJogo,
                                child: TelaFimJogo()),
                          )),
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
                    return Container(
                      height: 60,
                    );
                  }
                },
              ));
        }
      },
    );
  }
}
