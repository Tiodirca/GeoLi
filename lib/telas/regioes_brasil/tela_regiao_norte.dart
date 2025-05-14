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

class TelaRegiaoNorte extends StatefulWidget {
  const TelaRegiaoNorte({super.key});

  @override
  State<TelaRegiaoNorte> createState() => _TelaRegiaoNorteState();
}

class _TelaRegiaoNorteState extends State<TelaRegiaoNorte> {
  Map<Estado, Gestos> estadoGestoMap = {};
  List<MapEntry<Estado, Gestos>> estadosSorteio = [];
  List<Gestos> gestos = [];
  bool exibirTelaCarregamento = true;
  bool exibirTelaProximoNivel = false;
  late String uidUsuario;
  bool exibirMensagemSemConexao = false;
  String nomeColecao = Constantes.fireBaseDocumentoRegiaoNorte;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carregarEstados();
    gestos.addAll([
      ConstantesEstadosGestos.gestoAC,
      ConstantesEstadosGestos.gestoAP,
      ConstantesEstadosGestos.gestoAM,
      ConstantesEstadosGestos.gestoPA,
      ConstantesEstadosGestos.gestoRO,
      ConstantesEstadosGestos.gestoRR,
      ConstantesEstadosGestos.gestoTO,
    ]);
    gestos.shuffle();
    // chamando metodo para fazer busca no banco de dados
    recuperarUIDUsuario();
  }

  recuperarUIDUsuario() async {
    uidUsuario = await MetodosAuxiliares.recuperarUid();
    realizarBuscaDadosFireBase(nomeColecao);
  }



  carregarEstados() {
    estadoGestoMap[ConstantesEstadosGestos.estadoAC] =
        ConstantesEstadosGestos.gestoAC;
    estadoGestoMap[ConstantesEstadosGestos.estadoAP] =
        ConstantesEstadosGestos.gestoAP;
    estadoGestoMap[ConstantesEstadosGestos.estadoAM] =
        ConstantesEstadosGestos.gestoAM;
    estadoGestoMap[ConstantesEstadosGestos.estadoPA] =
        ConstantesEstadosGestos.gestoPA;
    estadoGestoMap[ConstantesEstadosGestos.estadoRO] =
        ConstantesEstadosGestos.gestoRO;
    estadoGestoMap[ConstantesEstadosGestos.estadoRR] =
        ConstantesEstadosGestos.gestoRR;
    estadoGestoMap[ConstantesEstadosGestos.estadoTO] =
        ConstantesEstadosGestos.gestoTO;
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
                if (ConstantesEstadosGestos.estadoAC.nome == key) {
                  MetodosAuxiliares.removerGestoLista(
                      ConstantesEstadosGestos.estadoAC, value, gestos);
                } else if (ConstantesEstadosGestos.estadoAP.nome == key) {
                  MetodosAuxiliares.removerGestoLista(
                      ConstantesEstadosGestos.estadoAP, value, gestos);
                } else if (ConstantesEstadosGestos.estadoAM.nome == key) {
                  MetodosAuxiliares.removerGestoLista(
                      ConstantesEstadosGestos.estadoAM, value, gestos);
                } else if (ConstantesEstadosGestos.estadoPA.nome == key) {
                  MetodosAuxiliares.removerGestoLista(
                      ConstantesEstadosGestos.estadoPA, value, gestos);
                } else if (ConstantesEstadosGestos.estadoRO.nome == key) {
                  MetodosAuxiliares.removerGestoLista(
                      ConstantesEstadosGestos.estadoRO, value, gestos);
                } else if (ConstantesEstadosGestos.estadoRR.nome == key) {
                  MetodosAuxiliares.removerGestoLista(
                      ConstantesEstadosGestos.estadoRR, value, gestos);
                } else if (ConstantesEstadosGestos.estadoTO.nome == key) {
                  MetodosAuxiliares.removerGestoLista(
                      ConstantesEstadosGestos.estadoTO, value, gestos);
                }
              });
            },
          );
          setState(
            () {
              if (gestos.isEmpty) {
                exibirTelaProximoNivel = true;
              }
              exibirTelaCarregamento = false;
            },
          );
        }, onError: (e) {
          debugPrint("ErroONN${e.toString()}");
          validarErro(e.toString());
        });
      } catch (e) {
        debugPrint("ErroN${e.toString()}");
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
            Constantes.rotaTelaRegiaoNorte);
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
                child: Text(Textos.tituloTelaRegiaoNorte)),
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
