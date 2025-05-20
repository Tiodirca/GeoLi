import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/constantes_estados_gestos.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Widgets/estados/area_tela_regioes_widget.dart';
import 'package:geoli/Widgets/estados/widget_area_gestos_arrastar.dart';
import 'package:geoli/Widgets/tela_carregamento_widget.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class TelaRegiaoCentroOeste extends StatefulWidget {
  const TelaRegiaoCentroOeste({super.key});

  @override
  State<TelaRegiaoCentroOeste> createState() => _TelaRegiaoCentroOesteState();
}

class _TelaRegiaoCentroOesteState extends State<TelaRegiaoCentroOeste> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  List<Estado> estadosCentro = [];
  List<Gestos> gestos = [];
  bool exibirTelaCarregamento = true;
  bool exibirTelaProximoNivel = false;
  Map<Estado, Gestos> estadoGestoMap = {};
  List<MapEntry<Estado, Gestos>> estadosSorteio = [];
  late String uidUsuario;
  bool exibirMensagemSemConexao = false;
  String nomeColecao = Constantes.fireBaseDocumentoRegiaoCentroOeste;

  @override
  void initState() {
    super.initState();
    estadosSorteio.clear();
    recuperarUIDUsuario();
  }

  recuperarUIDUsuario() async {
    uidUsuario = await MetodosAuxiliares.recuperarUid();
    validarPrimeiraJogada();
  }

  validarPrimeiraJogada() async {
    bool retornoConexao = await InternetConnection().hasInternetAccess;
    // recebendo a pontuacao que esta sendo passada na
    // TELA INICIAL REGIOES e do WIDGET AREA GESTOS
    if (retornoConexao) {
      int pontuacao = await MetodosAuxiliares.recuperarPontuacaoAtual();
      // Entrar no tutorial de jogo caso a pontuacao seja 0
      if (pontuacao == 0) {
        setState(() {
          carregarEstados();
          print("xcvxv");
          //percorrendo a a lista
          for (var element in estadosSorteio) {
            //sobre escrevendo o atributo para que caso seja tutorial nao exibir acertos de jogada anterior
            // ao RESETAR DADOS
            element.key.acerto = false;
          }
          exibirTelaCarregamento = false;
          gestos.addAll([ConstantesEstadosGestos.gestoMS]);
          //passando status de tutorial ativo para os WIGETS
          // validar acoes baseado no status passado
          MetodosAuxiliares.passarStatusTutorial(
              Constantes.statusTutorialAtivo);
        });
      } else {
        gestos.addAll([
          ConstantesEstadosGestos.gestoGO,
          ConstantesEstadosGestos.gestoMT,
          ConstantesEstadosGestos.gestoMS
        ]); // adicionando itens na lista
        gestos.shuffle(); // fazendo sorteio dos gestos na lista
        // chamando metodo para fazer busca no banco de dados
        realizarBuscaDadosFireBase(nomeColecao);
      }
    } else {
      exibirErroConexao();
    }
  }



  // metodo para adicionar os estados no map auxiliar e
  // depois adicionar numa lista e fazer o sorteio dos itens
  carregarEstados() {
    estadoGestoMap[ConstantesEstadosGestos.estadoMS] =
        ConstantesEstadosGestos.gestoMS;
    estadoGestoMap[ConstantesEstadosGestos.estadoGO] =
        ConstantesEstadosGestos.gestoGO;
    estadoGestoMap[ConstantesEstadosGestos.estadoMT] =
        ConstantesEstadosGestos.gestoMT;
    estadosSorteio = estadoGestoMap.entries.toList();
    estadosSorteio.shuffle();
  }

  realizarBuscaDadosFireBase(String nomeDocumentoRegiao) async {
    print("fdfs");
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
            .doc(nomeDocumentoRegiao) // passando documento
            .get()
            .then((querySnapshot) async {
          // verificando cada item que esta gravado no banco de dados
          querySnapshot.data()!.forEach(
            (key, value) {
              //caso o valor da CHAVE for o mesmo que o nome do ESTADO entrar na condicao
              setState(() {
                if (ConstantesEstadosGestos.estadoMT.nome == key) {
                  MetodosAuxiliares.removerGestoLista(
                      ConstantesEstadosGestos.estadoMT, value, gestos);
                } else if (ConstantesEstadosGestos.estadoMS.nome == key) {
                  MetodosAuxiliares.removerGestoLista(
                      ConstantesEstadosGestos.estadoMS, value, gestos);
                  ConstantesEstadosGestos.estadoMS.acerto = value;
                } else if (ConstantesEstadosGestos.estadoGO.nome == key) {
                  MetodosAuxiliares.removerGestoLista(
                      ConstantesEstadosGestos.estadoGO, value, gestos);
                }
              });
            },
          );
          setState(
            () {
              carregarEstados();
              if (gestos.isEmpty) {
                exibirTelaProximoNivel = true;
              }
              exibirTelaCarregamento = false;
            },
          );
        }, onError: (e) {
          debugPrint("ErroON${e.toString()}");
          validarErro(e.toString());
        });
      } catch (e) {
        debugPrint("Erro${e.toString()}");
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
            Constantes.rotaTelaRegiaoCentroOeste);
      });
    }
  }

  validarErro(String erro) {
    if (erro.contains("An internal error has occurred")) {
      exibirErroConexao();
    }
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 2), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    });
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
                    Timer(const Duration(seconds: 2), () {
                      Navigator.pushReplacementNamed(
                          context, Constantes.rotaTelaInicialRegioes);
                    });
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
            )),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (exibirTelaCarregamento) {
              return TelaCarregamentoWidget(
                exibirMensagemConexao: exibirMensagemSemConexao,
                corPadrao: ConstantesEstadosGestos.corPadraoRegioes,
              );
            } else {
              return AreaTelaRegioesWidget(
                  nomeColecao: nomeColecao,
                  estadosSorteio: estadosSorteio,
                  exibirTelaProximoNivel: exibirTelaProximoNivel);
            }
          },
        ),
        bottomNavigationBar: WidgetAreaGestosArrastar(
          nomeColecao: nomeColecao,
          gestos: gestos,
          estadoGestoMap: estadoGestoMap,
          exibirTelaCarregamento: exibirTelaCarregamento,
        ));
  }
}
