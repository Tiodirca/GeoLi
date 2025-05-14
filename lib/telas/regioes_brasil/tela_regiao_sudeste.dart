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

class TelaRegiaoSudeste extends StatefulWidget {
  const TelaRegiaoSudeste({super.key});

  @override
  State<TelaRegiaoSudeste> createState() => _TelaRegiaoSudesteState();
}

class _TelaRegiaoSudesteState extends State<TelaRegiaoSudeste> {
  Map<Estado, Gestos> estadoGestoMap = {};
  List<MapEntry<Estado, Gestos>> estadosSorteio = [];
  List<Gestos> gestos = [];
  bool exibirTelaCarregamento = true;
  bool exibirTelaProximoNivel = false;
  late String uidUsuario;
  String nomeColecao = Constantes.fireBaseDocumentoRegiaoSudeste;

  bool exibirMensagemSemConexao = false;

  @override
  void initState() {
    super.initState();
    // adicionando itens na lista e fazendo o sorteio dos itens na lista
    gestos.addAll([
      ConstantesEstadosGestos.gestoSP,
      ConstantesEstadosGestos.gestoRJ,
      ConstantesEstadosGestos.gestoMG,
      ConstantesEstadosGestos.gestoES
    ]);
    gestos.shuffle();
    // chamando metodo para fazer busca no banco de dados
    recuperarUIDUsuario();
  }

  recuperarUIDUsuario() async {
    uidUsuario = await MetodosAuxiliares.recuperarUid();
    realizarBuscaDadosFireBase(nomeColecao);
  }

  // metodo para adicionar os estados no map auxiliar
  // e depois adicionar numa lista e fazer o sorteio dos itens
  carregarEstados() {
    estadoGestoMap[ConstantesEstadosGestos.estadoMG] =
        ConstantesEstadosGestos.gestoMG;
    estadoGestoMap[ConstantesEstadosGestos.estadoES] =
        ConstantesEstadosGestos.gestoES;
    estadoGestoMap[ConstantesEstadosGestos.estadoSP] =
        ConstantesEstadosGestos.gestoSP;
    estadoGestoMap[ConstantesEstadosGestos.estadoRJ] =
        ConstantesEstadosGestos.gestoRJ;
    estadosSorteio = estadoGestoMap.entries.toList();
    estadosSorteio.shuffle();
  }

  realizarBuscaDadosFireBase(String nomeDocumentoRegiao) async {
    bool retornoConexao = await InternetConnection().hasInternetAccess;
    var db = FirebaseFirestore.instance;
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
              // caso o valor da CHAVE for o mesmo que o nome do ESTADO entrar na condicao
              setState(() {
                if (ConstantesEstadosGestos.estadoRJ.nome == key) {
                  gestos = MetodosAuxiliares.removerGestoLista(
                      ConstantesEstadosGestos.estadoRJ, value, gestos);
                } else if (ConstantesEstadosGestos.estadoSP.nome == key) {
                  gestos = MetodosAuxiliares.removerGestoLista(
                      ConstantesEstadosGestos.estadoSP, value, gestos);
                } else if (ConstantesEstadosGestos.estadoES.nome == key) {
                  gestos = MetodosAuxiliares.removerGestoLista(
                      ConstantesEstadosGestos.estadoES, value, gestos);
                } else if (ConstantesEstadosGestos.estadoMG.nome == key) {
                  gestos = MetodosAuxiliares.removerGestoLista(
                      ConstantesEstadosGestos.estadoMG, value, gestos);
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
          debugPrint("ErroONSS${e.toString()}");
          validarErro(e.toString());
        });
      } catch (e) {
        debugPrint("ErroSS${e.toString()}");
        validarErro(e.toString());
      }
    } else {
      exibirErroConexao();
    }
  }

  validarErro(String erro) {
    if (erro.contains("An internal error has occurred")) {
      exibirErroConexao();
    }
  }

  exibirErroConexao() {
    if (mounted) {
      setState(() {
        exibirTelaCarregamento = true;
        exibirMensagemSemConexao = true;
        MetodosAuxiliares.passarTelaAtualErroConexao(
            Constantes.rotaTelaRegiaoSudeste);
      });
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
                child: Text(Textos.tituloTelaRegiaoSudeste)),
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
