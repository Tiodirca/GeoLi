import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoli/Modelos/emblemas.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/passar_pegar_dados.dart.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Widgets/tela_carregamento_widget.dart';
import 'package:geoli/Widgets/widget_exibir_emblemas.dart';
import 'package:geoli/Widgets/widget_tela_resetar_dados.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial>
    with TickerProviderStateMixin {
  int pontuacaoEstados = 0;
  int pontuacaoSistemaSolar = 0;
  int pontuacaoGeral = 0;
  List<Emblemas> emblemasGeral = [];
  bool exibirTelaCarregamento = true;
  bool exibirTelaResetarJogo = false;
  int contadorConexao = 0;
  String nomeUsuario = "";
  String uidUsuario = "";
  String emailAlterado = "";
  String caminhoImagemEstado = CaminhosImagens.btnGestoEstadosBrasileiroImagem;
  String caminhoImagemSistemaSolar = CaminhosImagens.btnGestoSistemaSolarImagem;
  Color corPadrao = PaletaCores.corVerde;
  bool exibirMensagemSemConexao = false;

  @override
  void initState() {
    super.initState();
    emblemasGeral.addAll([
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteSoldado,
          nomeEmblema: Textos.emblemaPatenteSoldado,
          pontos: 0),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteCabo,
          nomeEmblema: Textos.emblemaPatenteCabo,
          pontos: 15),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteSargento,
          nomeEmblema: Textos.emblemaPatenteSargento,
          pontos: 30),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteSubTenente,
          nomeEmblema: Textos.emblemaPatenteSubTenente,
          pontos: 45),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteAspirante,
          nomeEmblema: Textos.emblemaPatenteAspirante,
          pontos: 60),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteTenente,
          nomeEmblema: Textos.emblemaPatenteTenente,
          pontos: 75),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteCapitao,
          nomeEmblema: Textos.emblemaPatenteCapitao,
          pontos: 90),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteMajor,
          nomeEmblema: Textos.emblemaPatenteMajor,
          pontos: 105),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteTenenteCoronel,
          nomeEmblema: Textos.emblemaPatenteTenenteCoronel,
          pontos: 120),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteCoronel,
          nomeEmblema: Textos.emblemaPatenteCoronel,
          pontos: 135),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteGeneralBrigada,
          nomeEmblema: Textos.emblemaPatenteGeneralBrigada,
          pontos: 150),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteGeneralDivisao,
          nomeEmblema: Textos.emblemaPatenteGeneralDivisao,
          pontos: 170),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteGeneralExercito,
          nomeEmblema: Textos.emblemaPatenteGeneralExercito,
          pontos: 185),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteMarechal,
          nomeEmblema: Textos.emblemaPatenteMarechal,
          pontos: 200),
    ]);
    uidUsuario =
        PassarPegarDados.recuperarInformacoesUsuario().values.elementAt(0);
    recuperarDadosUsuario(uidUsuario);

  }

  recuperarDadosUsuario(String uidUsuario) async {
    var db = FirebaseFirestore.instance;
    db
        .collection(Constantes.fireBaseColecaoUsuarios) // passando a colecao
        .doc(
          uidUsuario,
        )
        .get()
        .then((querySnapshot) async {
      // verificando cada item que esta gravado no banco de dados
      querySnapshot.data()!.forEach((key, value) {
        setState(() {
          if (key.toString() == Constantes.fireBaseCampoNomeUsuario) {
            nomeUsuario = value;
          } else {
            emailAlterado = value;
          }
          recuperarPontuacao(Constantes.fireBaseColecaoRegioes,
              Constantes.fireBaseDocumentoPontosJogadaRegioes, uidUsuario);
        });
      });
      //chamando metodo para validar Alteracao do email
      //MetodosAuxiliares.validarAlteracaoEmail(emailAlterado, nomeUsuario);
    }, onError: (e) {
      chamarMensagemErro(e.toString());
    });
  }

  chamarMensagemErro(String erro) {
    MetodosAuxiliares.validarErro(erro, context);
  }

  // metodo para recuperar a pontuacao
  recuperarPontuacao(
      String nomeColecao, String nomeDocumento, String uidUsuario) async {
    var db = FirebaseFirestore.instance;
    //instanciano variavel
    try {
      db
          .collection(Constantes.fireBaseColecaoUsuarios) // passando a colecao
          .doc(uidUsuario)
          .collection(nomeColecao) // passando a colecao
          .doc(nomeDocumento) // passando documento
          .get()
          .then((querySnapshot) async {
        querySnapshot.data()!.forEach(
          (key, value) {
            setState(() {
              if (nomeColecao == Constantes.fireBaseColecaoRegioes) {
                pontuacaoEstados = value;
                recuperarPontuacao(
                    Constantes.fireBaseColecaoSistemaSolar,
                    Constantes.fireBaseDocumentoPontosJogadaSistemaSolar,
                    uidUsuario);
              } else {
                pontuacaoSistemaSolar = value;
                pontuacaoGeral = pontuacaoEstados + pontuacaoSistemaSolar;
                //Passando pontuacao para
                // a tela de emblemas sem esse metodo o
                // emblema nao e exibido corretamente
                PassarPegarDados.passarPontuacaoAtual(pontuacaoGeral);
                exibirTelaCarregamento = false;
              }
            });
          },
        );
      }, onError: (e) {
        debugPrint("ErroTONP${e.toString()}");
        //validarErro(e.toString());
      });
    } catch (e) {
      debugPrint("ErroTP${e.toString()}");
      //validarErro(e.toString());
    }
  }

  validarTamanhoGestos(double largura) {
    if (largura <= 600) {
      return 70.0;
    } else if (largura > 600 && largura <= 1000) {
      return 90.0;
    } else if (largura > 1000) {
      return 100.0;
    }
  }

  validarTamanhoLarguraBotao(double largura) {
    if (largura <= 600) {
      return 120.0;
    } else if (largura > 600 && largura <= 1000) {
      return 120.0;
    } else if (largura > 1000) {
      return 140.0;
    }
  }

  validarTamanhoAlturaBotao(double largula) {
    if (largula <= 600) {
      return 130.0;
    } else if (largula > 600 && largula <= 1000) {
      return 150.0;
    } else if (largula > 1000) {
      return 170.0;
    }
  }

  Widget cartao(String nomeImagem, String nome, double largura) => Container(
        margin: EdgeInsets.only(bottom: 10),
        width: MetodosAuxiliares.validarTamanhoLarguraBotao(largura),
        height:MetodosAuxiliares.validarTamanhoAlturaBotao(largura),
        child: FloatingActionButton(
          elevation: 0,
          heroTag: nome,
          backgroundColor: Colors.white,
          onPressed: () {
            if (nome == Textos.btnSistemaSolar) {
              //Zerando metodos para evitar passar
              // informacao incorreta para a tela
              PassarPegarDados.passarPontuacaoAtual(0);
              PassarPegarDados.confirmarAcerto("");
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaSistemaSolar);
            } else if (nome == Textos.btnEstadoBrasileiros) {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaInicialRegioes);
            }
          },
          shape: RoundedRectangleBorder(
              side: BorderSide(color: corPadrao, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(40))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                height:  kIsWeb ? MetodosAuxiliares.validarTamanhoGestos(largura) : 90,
                width:  kIsWeb ? MetodosAuxiliares.validarTamanhoGestos(largura) : 90 ,
                image: AssetImage("$nomeImagem.png"),
              ),
              Text(
                nome,
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

  redirecionarTelaLoginCadastro() {
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaLoginCadastro);
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaBarraStatus = MediaQuery.of(context).padding.top;
    double alturaAppBar = AppBar().preferredSize.height;

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
          return Scaffold(
              appBar: AppBar(
                leading: Container(),
                backgroundColor: PaletaCores.corVerde,
                title: Text(
                  Textos.nomeApp,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                actions: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        width: 50,
                        height: 50,
                        child: FloatingActionButton(
                          heroTag: "Config",
                          elevation: 0,
                          backgroundColor: Colors.white,
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black)),
                          onPressed: () async {
                            // await FirebaseAuth.instance.signOut();
                            // redirecionarTelaLoginCadastro();
                            setState(() {
                              exibirTelaResetarJogo = !exibirTelaResetarJogo;
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
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        width: 50,
                        height: 50,
                        child: FloatingActionButton(
                          heroTag: Textos.campoUsuario,
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black)),
                          onPressed: () async {
                            Navigator.pushReplacementNamed(
                                context, Constantes.rotaTelaUsuarioDetalhado);
                          },
                          child: Icon(
                            Icons.person,
                            color: corPadrao,
                            size: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              body: Container(
                color: Colors.white,
                width: larguraTela,
                height: alturaTela - alturaAppBar - alturaBarraStatus,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 30),
                            width: larguraTela,
                            child: Text(
                              Textos.descricaoTelaInicial,
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            )),
                        SizedBox(
                          height: alturaTela * 0.6,
                          width: larguraTela,
                          child: SingleChildScrollView(
                            child: Wrap(
                              alignment: WrapAlignment.spaceEvenly,
                              children: [
                                cartao(caminhoImagemEstado,
                                    Textos.btnEstadoBrasileiros, larguraTela),
                                cartao(caminhoImagemSistemaSolar,
                                    Textos.btnSistemaSolar, larguraTela),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                        visible: exibirTelaResetarJogo,
                        child: WidgetTelaResetarDados(
                          corCard: corPadrao,
                          tipoAcao: Constantes.resetarAcaoExcluirTudo,
                        )),
                    Container(
                      width: larguraTela,
                      height: alturaTela,
                      margin: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Textos.descricaoTelaInicialNomeUsuario,
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            nomeUsuario,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottomSheet: WidgetExibirEmblemas(
                  pontuacaoAtual: pontuacaoGeral,
                  listaEmblemas: emblemasGeral,
                  nomeBtn: "",
                  corBordas: corPadrao));
        }
      },
    );
  }
}
