import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoli/Modelos/emblemas.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/validar_tamanho_itens_tela.dart';
import 'package:geoli/Uteis/variaveis_constantes/constantes.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/passar_pegar_dados.dart.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/variaveis_constantes/constantes_sistema_solar.dart';
import 'package:geoli/Widgets/gestos_widget.dart';
import 'package:geoli/Widgets/sistema_solar/area_tutorial_widget.dart';
import 'package:geoli/Widgets/sistema_solar/widget_area_animacao_baloes.dart';
import 'package:geoli/Widgets/tela_carregamento_widget.dart';
import 'package:geoli/Widgets/widget_exibir_emblemas.dart';
import 'package:geoli/Widgets/widget_tela_resetar_dados.dart';
import 'package:geoli/modelos/planeta.dart';

class TelaSistemaSolar extends StatefulWidget {
  const TelaSistemaSolar({super.key});

  @override
  State<TelaSistemaSolar> createState() => _TelaSistemaSolarState();
}

class _TelaSistemaSolarState extends State<TelaSistemaSolar>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool exibirTelaCarregamento = true;
  bool exibirJogo = false;
  bool exibirBtnDificuldade = false;
  bool exibirTutorial = false;
  bool ativarBtn = true;
  bool playPauseJogo = false;
  bool exibirTelaResetarJogo = false;
  List<Gestos> gestoPlanetasSistemaSolar = [];
  List<Planeta> planetas = [];
  List<Emblemas> emblemasExibir = [];
  int tempo = 0;
  int pontuacaoDuranteJogo = 0;
  int pontuacaoTotal = 0;
  int tamanhoVidas = 3;
  late Gestos gestoSorteado;
  late Timer iniciarTempo;
  late String iniciarAnimacao;
  late String uidUsuario;
  Color corPadrao = PaletaCores.corAzul;
  bool exibirMensagemSemConexao = false;

  @override
  void dispose() {
    super.dispose();
    if (mounted) {
      PassarPegarDados.passarOcultarTelaEmblemas(false);
    }
  }

  @override
  void initState() {
    super.initState();
    planetas = ConstantesSistemaSolar.adicinarPlanetas();
    gestoPlanetasSistemaSolar =
        ConstantesSistemaSolar.adicionarGestosPlanetas();
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
    recuperarUIDUsuario();
  }

  recuperarUIDUsuario() async {
    uidUsuario = await PassarPegarDados.recuperarInformacoesUsuario()
        .values
        .elementAt(0);
    recuperarPontuacao();
  }

  //metodo para sortear gesto
  sortearGesto() {
    Random random = Random();
    gestoSorteado = gestoPlanetasSistemaSolar
        .elementAt(random.nextInt(gestoPlanetasSistemaSolar.length));
    //chamando metodo para passar o nome do gesto sorteado
    PassarPegarDados.passarGestoSorteado(gestoSorteado.nomeGesto);
  }

  void comecarTempo() {
    const segundo = Duration(seconds: 1);
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
    try {
      db
          .collection(Constantes.fireBaseColecaoUsuarios) // passando a colecao
          .doc(uidUsuario)
          .collection(
              Constantes.fireBaseColecaoSistemaSolar) // passando a colecao
          .doc(Constantes
              .fireBaseDocumentoPontosJogadaSistemaSolar) // passando documento
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.data() != null) {
          querySnapshot.data()!.forEach(
            (key, value) {
              if (mounted) {
                setState(() {
                  pontuacaoTotal = value;
                  //Passando pontuacao para
                  // a tela de emblemas sem esse metodo
                  // o emblema nao e exibido corretamente
                  PassarPegarDados.passarPontuacaoAtual(pontuacaoTotal);
                  exibirTelaCarregamento = false;
                });
              }
            },
          );
        } else {
          redirecionarTelaLoginCadastro();
        }
      }, onError: (e) {
        debugPrint("RPSON${e.toString()}");
        chamarValidarErro(e.toString());
      }).timeout(
        Duration(seconds: Constantes.fireBaseDuracaoTimeOutTelaProximoNivel),
        onTimeout: () {
          chamarValidarErro(Textos.erroUsuarioSemInternet);
          redirecionarTelaInicial();
        },
      );
    } catch (e) {
      debugPrint("Erro${e.toString()}");
      chamarValidarErro(e.toString());
    }
  }

  redirecionarTelaInicial() {
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
  }

  chamarValidarErro(String erro) {
    MetodosAuxiliares.validarErro(erro, context);
  }

  redirecionarTelaLoginCadastro() {
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaLoginCadastro);
  }

  //atualizar pontuacao no banco de dados
  atualizarPontuacao() async {
    pontuacaoTotal = pontuacaoTotal + pontuacaoDuranteJogo;
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(Constantes.fireBaseColecaoUsuarios) // passando a colecao
          .doc(uidUsuario)
          .collection(
              Constantes.fireBaseColecaoSistemaSolar) // passando a colecao
          .doc(Constantes
              .fireBaseDocumentoPontosJogadaSistemaSolar) //passando o documento
          .set({Constantes.pontosJogada: pontuacaoTotal}).then((value) {},
              onError: (e) {
        chamarValidarErro(e.toString());
        debugPrint("ATPONSS${e.toString()}");
      }).timeout(
        Duration(seconds: Constantes.fireBaseDuracaoTimeOutTelaProximoNivel),
        onTimeout: () {
          chamarValidarErro(Textos.erroUsuarioSemInternet);
          redirecionarTelaInicial();
        },
      );
    } catch (e) {
      debugPrint("Erro${e.toString()}");
      chamarValidarErro(e.toString());
    }
  }

  // metodo para verificar se o usuario acertou o planeta que foi sorteado no gesto
  recuperarJogadaPeriodicamente() async {
    //recuperando o valor passado pelo metodo
    String retorno = await PassarPegarDados.recuperarAcerto();
    if (retorno == Constantes.msgAcerto) {
      // mudando estado da lista para mudar a ordem dos planetas na lista
      setState(() {
        planetas.shuffle();
        sortearGesto(); //chamando metodo para sortear um novo gesto
        pontuacaoDuranteJogo++;
        // chamando metodo para exibir mensagem
        MetodosAuxiliares.exibirMensagensDuranteJogo(
            Textos.msgAcertou, Constantes.msgAcerto, context);
      });
    } else if (retorno == Constantes.msgErro) {
      setState(() {
        tamanhoVidas--;
        // chamando metodo para exibir mensagem
        MetodosAuxiliares.exibirMensagensDuranteJogo(
            Textos.msgErrou, Constantes.msgErro, context);
        // caso a quantide de vidas tenha chegado a 0
        if (tamanhoVidas == 0) {
          pararTempo();
          atualizarPontuacao();
        }
      });
    }
    //sobreescrevendo metodo
    PassarPegarDados.confirmarAcerto("");
  }

  liberarBotoes() {
    Future.delayed(Duration(milliseconds: 4300), () {
      setState(() {
        ativarBtn = true;
      });
    });
  }

  Widget btnAcao(String nomeBtn, String caminhoImagem) => Container(
      margin: EdgeInsets.all(5),
      width: 110,
      height: 120,
      child: FloatingActionButton(
          elevation: 0,
          heroTag: nomeBtn,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            side: BorderSide(color: corPadrao),
          ),
          onPressed: () {
            setState(() {
              if (nomeBtn == Textos.btnComecarJogo) {
                exibirBtnDificuldade = true;
                PassarPegarDados.passarOcultarTelaEmblemas(
                    true);
                if (pontuacaoTotal == 0) {
                  exibirTutorial = true;
                  PassarPegarDados.passarStatusTutorial(
                      Constantes.statusTutorialAtivo);
                }
              } else {
                if (nomeBtn == Textos.btnDificuldadeFacil) {
                  tempo = ConstantesSistemaSolar.sistemaSolarTempoFacil;
                } else if (nomeBtn == Textos.btnDificuldadeMedio) {
                  tamanhoVidas = 2;
                  tempo = ConstantesSistemaSolar.sistemaSolarTempoMedio;
                } else if (nomeBtn == Textos.btnDificuldadeDificil) {
                  tamanhoVidas = 1;
                  tempo = ConstantesSistemaSolar.sistemaSolarTempoDificl;
                }
                ativarBtn = false;
                comecarTempo();
                liberarBotoes();
                exibirJogo = true;
                iniciarAnimacao = ConstantesSistemaSolar.statusAnimacaoIniciar;
                exibirBtnDificuldade = false;
              }
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                width: 90,
                height: 90,
                image: AssetImage('$caminhoImagem.png'),
              ),
              Text(
                nomeBtn,
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            ],
          )));

  Widget areaSorteioPlaneta(double larguraTela) => SizedBox(
        width: larguraTela,
        height: 150,
        child: Card(
          color: Colors.white,
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
              side: BorderSide(color: PaletaCores.corAzulMagenta, width: 1),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(25), topLeft: Radius.circular(25))),
          child: Column(
            children: [
              Text(
                Textos.telaSistemaSolarDescricaoPlanetaSorteado,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                  height: kIsWeb
                      ? 120
                      : Platform.isAndroid || Platform.isIOS
                          ? 100
                          : 120,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (exibirTutorial) {
                        return GestosWidget(
                            nomeGestoImagem:
                                CaminhosImagens.gestoPlanetaTerraImagem,
                            nomeGesto: Textos.nomePlanetaTerra,
                            exibirAcerto: false);
                      } else {
                        return GestosWidget(
                            nomeGestoImagem: gestoSorteado.nomeImagem,
                            nomeGesto: gestoSorteado.nomeGesto,
                            exibirAcerto: false);
                      }
                    },
                  ))
            ],
          ),
        ),
      );

  verificarOcultarTelaResetarJogo() async {
    Timer(Duration(seconds: 2), () async {
      if(!exibirJogo){
        bool retorno = await PassarPegarDados.recuperarOcultarTelaEmblemas();
        if (retorno == false) {
          if (mounted) {
            setState(() {
              exibirTelaResetarJogo = false;
              verificarOcultarTelaResetarJogo();
            });
          }
        } else {
          verificarOcultarTelaResetarJogo();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;

    Timer(Duration(seconds: 2), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    });
    return LayoutBuilder(
      builder: (context, constraints) {
        if (exibirTelaCarregamento) {
          return TelaCarregamentoWidget(
            corPadrao: corPadrao,
          );
        } else {
          verificarOcultarTelaResetarJogo();
          return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                  backgroundColor: PaletaCores.corAzulEscuro,
                  title: LayoutBuilder(
                    builder: (context, constraints) {
                      if (exibirJogo || exibirTutorial) {
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
                                        pontuacaoDuranteJogo.toString(),
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
                                        if (ativarBtn) {
                                          setState(() {
                                            if (tamanhoVidas != 0 &&
                                                tempo != 0) {
                                              playPauseJogo = !playPauseJogo;
                                              if (playPauseJogo) {
                                                iniciarAnimacao =
                                                    ConstantesSistemaSolar
                                                        .statusAnimacaoPausada;
                                                pararTempo();
                                              } else {
                                                iniciarAnimacao =
                                                    ConstantesSistemaSolar
                                                        .statusAnimacaoRetomar;
                                                comecarTempo();
                                              }
                                            }
                                          });
                                        }
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
                  actions: [
                    Visibility(
                        visible: !exibirJogo && !exibirTutorial,
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          width: 50,
                          height: 50,
                          child: FloatingActionButton(
                            heroTag: Textos.btnExcluir,
                            backgroundColor: Colors.white,
                            elevation: 0,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black)),
                            onPressed: () {
                              setState(() {
                                exibirTelaResetarJogo = !exibirTelaResetarJogo;
                                PassarPegarDados.passarOcultarTelaEmblemas(
                                    exibirTelaResetarJogo);
                              });
                            },
                            child: Icon(
                              exibirTelaResetarJogo
                                  ? Icons.close
                                  : Icons.settings,
                              color: corPadrao,
                              size: 30,
                            ),
                          ),
                        ))
                  ],
                  leading: IconButton(
                      color: Colors.white,
                      //setando tamanho do icone
                      iconSize: 30,
                      enableFeedback: false,
                      onPressed: () {
                        if (ativarBtn) {
                          PassarPegarDados.passarPontuacaoAtual(0);
                          if (exibirJogo) {
                            atualizarPontuacao();
                            Navigator.pushReplacementNamed(
                                context, Constantes.rotaTelaSistemaSolar);
                          } else {
                            Navigator.pushReplacementNamed(
                                context, Constantes.rotaTelaInicial);
                          }
                        }
                      },
                      icon: const Icon(Icons.arrow_back_ios))),
              body: LayoutBuilder(
                builder: (context, constraints) {
                  if (exibirJogo) {
                    final Size biggest = constraints.biggest;
                    // chamando metodo para ficar
                    // verificando a cada
                    // momento se o usuario acertou o planeta
                    recuperarJogadaPeriodicamente();
                    return WidgetAreaAnimacaoBaloes(
                      biggest: biggest,
                      planetas: planetas,
                      statusAnimacao: iniciarAnimacao,
                      quantidadeVidas: tamanhoVidas,
                      tempo: tempo,
                    );
                  } else {
                    if (exibirTutorial) {
                      return AreaTutorialWidget(corPadrao: corPadrao);
                    } else {
                      return Container(
                          color: Colors.white,
                          width: larguraTela,
                          height: alturaTela,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Visibility(
                                  visible: !exibirBtnDificuldade,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: larguraTela,
                                        height: 250,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              Textos.descriacaoSistemaSolar,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                            btnAcao(Textos.btnComecarJogo,
                                                CaminhosImagens.gestoComecar),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Visibility(
                                    visible: exibirBtnDificuldade,
                                    child: SizedBox(
                                      width: larguraTela,
                                      height: 250,
                                      child: Column(
                                        children: [
                                          Text(
                                            Textos
                                                .descricaoSistemaSolarDificuldade,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18),
                                          ),
                                          Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            alignment: WrapAlignment.center,
                                            children: [
                                              btnAcao(
                                                  Textos.btnDificuldadeFacil,
                                                  CaminhosImagens.gestoFacil),
                                              btnAcao(
                                                  Textos.btnDificuldadeMedio,
                                                  CaminhosImagens.gestoMedio),
                                              btnAcao(
                                                  Textos.btnDificuldadeDificil,
                                                  CaminhosImagens.gestoDificil),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )),
                                Visibility(
                                    visible: exibirTelaResetarJogo,
                                    child: WidgetTelaResetarDados(
                                      corCard: corPadrao,
                                      tipoAcao: Constantes
                                          .resetarAcaoExcluirSistemaSolar,
                                    ))
                              ],
                            ),
                          ));
                    }
                  }
                },
              ),
              bottomSheet: LayoutBuilder(
                builder: (context, constraints) {
                  //verificando se nao esta no tutorial
                  if (exibirTutorial) {
                    return SizedBox(
                      width: 0,
                      height: 0,
                    );
                  } else {
                    if (exibirJogo) {
                      return areaSorteioPlaneta(ValidarTamanhoItensTela
                          .tamanhoAreaPlanetaSorteadoSistemaSolar(larguraTela));
                    } else {
                      return WidgetExibirEmblemas(
                          pontuacaoAtual: pontuacaoTotal,
                          corBordas: corPadrao,
                          nomeBtn: Textos.btnSistemaSolar,
                          listaEmblemas: emblemasExibir);
                    }
                  }
                },
              ));
        }
      },
    );
  }
}
