import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoli/Modelos/emblemas.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/constantes_estados_gestos.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Widgets/tela_carregamento_widget.dart';
import 'package:geoli/Widgets/widget_exibir_emblemas.dart';
import 'package:geoli/Widgets/widget_tela_resetar_dados.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

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
  bool exibirTelaResetarJogo = false;

  bool exibirMensagemSemConexao = false;
  late String uidUsuario;

  @override
  void initState() {
    super.initState();
    recuperarUIDUsuario();
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

  recuperarUIDUsuario() async {
    uidUsuario = await MetodosAuxiliares.recuperarUid();
    recuperarRegioesLiberadas();
    recuperarPontuacao();
  }

  recuperarRegioesLiberadas() async {
    var db = FirebaseFirestore.instance;

    bool retornoConexao = await InternetConnection().hasInternetAccess;
    //instanciano variavel
    if (retornoConexao) {
      try {
        db
            .collection(
                Constantes.fireBaseColecaoUsuarios) // passando a colecao
            .doc(uidUsuario)
            .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
            .doc(Constantes
                .fireBaseDocumentoLiberarEstados) // passando documento
            .get()
            .then((querySnapshot) async {
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
        }, onError: (e) {
          debugPrint("ErroONTIR${e.toString()}");
          validarErro(e.toString());
        });
      } catch (e) {
        debugPrint("ErroTIR${e.toString()}");
        validarErro(e.toString());
      }
    } else {
      exibirErroConexao();
    }
  }

  exibirErroConexao() {
    if (mounted) {
      setState(() {
        exibirTelaCarregamento = true;
        exibirMensagemSemConexao = true;
        MetodosAuxiliares.passarTelaAtualErroConexao(
            Constantes.rotaTelaInicialRegioes);
      });
    }
  }

  validarErro(String erro) {
    if (erro.contains("An internal error has occurred")) {
      exibirErroConexao();
    } else if (erro.contains("a document path must be a non-empty strin")) {
      MetodosAuxiliares.exibirMensagens(
          Textos.erroFirebaseSemReferencia,
          Constantes.msgErro,
          Constantes.duracaoExibicaoToastLoginCadastro,
          Constantes.larguraToastLoginCadastro,
          context);
    }
  }

  recuperarPontuacao() async {
    var db = FirebaseFirestore.instance;
    //instanciano variavel

    bool retornoConexao = await InternetConnection().hasInternetAccess;
    if (retornoConexao) {
      try {
        db
            .collection(
                Constantes.fireBaseColecaoUsuarios) // passando a colecao
            .doc(uidUsuario)
            .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
            .doc(Constantes
                .fireBaseDocumentoPontosJogadaRegioes) // passando documento
            .get()
            .then((querySnapshot) async {
          // verificando cada item que esta gravado no banco de dados
          querySnapshot.data()!.forEach((key, value) {
            setState(() {
              pontos = value;
              //Passando pontuacao para
              // a tela de emblemas sem esse metodo o
              // emblema nao e exibido corretamente
              // e para a TELA REGIAO CENTRO OESTE para
              // validar se entrara no tutorial ou nao
              MetodosAuxiliares.passarPontuacaoAtual(pontos);
            });
          });
        }, onError: (e) {
          debugPrint("ErroTRON${e.toString()}");
          validarErro(e.toString());
        });
      } catch (e) {
        debugPrint("ErroTR${e.toString()}");
        validarErro(e.toString());
      }
    } else {
      exibirErroConexao();
    }
  }

  Widget cartaoRegiao(String nomeImagem, String nomeRegiao) => Container(
        margin: EdgeInsets.only(bottom: 10, left: 10.0, right: 10.0),
        width: 120,
        height: 140,
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
              side: BorderSide(
                  color: ConstantesEstadosGestos.corPadraoRegioes, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                height: 90,
                width: 90,
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
    Timer(Duration(seconds: 2), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    });
    return LayoutBuilder(
      builder: (context, constraints) {
        if (exibirTelaCarregamento) {
          return TelaCarregamentoWidget(
            exibirMensagemConexao: exibirMensagemSemConexao,
            corPadrao: ConstantesEstadosGestos.corPadraoRegioes,
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: ConstantesEstadosGestos.corPadraoRegioes,
              title: Text(
                Textos.tituloTelaRegioes,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                  color: Colors.white,
                  //setando tamanho do icone
                  iconSize: 30,
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, Constantes.rotaTelaInicial);
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              actions: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 50,
                  height: 50,
                  child: FloatingActionButton(
                    heroTag: Textos.btnExcluir,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(width: 1, color: Colors.black)),
                    onPressed: () {
                      setState(() {
                        exibirTelaResetarJogo = !exibirTelaResetarJogo;
                      });
                    },
                    child: Icon(
                      exibirTelaResetarJogo ? Icons.close : Icons.settings,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                )
              ],
            ),
            body: Container(
              color: Colors.white,
              width: larguraTela,
              height: alturaTela,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
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
                              child: cartaoRegiao(
                                  regiaoNorte.caminhoImagem, regiaoNorte.nome)),
                          Visibility(
                              visible: regiaoNordeste.acerto,
                              child: cartaoRegiao(regiaoNordeste.caminhoImagem,
                                  regiaoNordeste.nome)),
                          Visibility(
                              visible: todasRegioes.acerto,
                              child: cartaoRegiao(todasRegioes.caminhoImagem,
                                  todasRegioes.nome)),
                        ],
                      ),
                    ],
                  ),
                  Visibility(
                      visible: exibirTelaResetarJogo,
                      child: WidgetTelaResetarDados(
                        corCard: ConstantesEstadosGestos.corPadraoRegioes,
                        tipoAcao: Constantes.resetarAcaoExcluirRegioes,
                      ))
                ],
              ),
            ),
            bottomSheet: WidgetExibirEmblemas(
              pontuacaoAtual: pontos,
              nomeBtn: Textos.btnRegioesMapa,
              corBordas: ConstantesEstadosGestos.corPadraoRegioes,
              listaEmblemas: emblemasExibir,
            ),
          );
        }
      },
    );
  }
}
