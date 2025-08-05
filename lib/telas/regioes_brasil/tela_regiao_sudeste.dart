import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoli/Uteis/variaveis_constantes/constantes.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoli/Uteis/passar_pegar_dados.dart.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Uteis/variaveis_constantes/constantes_estados_gestos.dart';
import 'package:geoli/Widgets/estados/area_tela_regioes_widget.dart';
import 'package:geoli/Widgets/estados/widget_area_gestos_arrastar.dart';
import 'package:geoli/Widgets/tela_carregamento_widget.dart';

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
    uidUsuario = await PassarPegarDados.recuperarInformacoesUsuario()
        .values
        .elementAt(0);
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
    var db = FirebaseFirestore.instance;
    //instanciano variavel
    try {
      db
          .collection(Constantes.fireBaseColecaoUsuarios) // passando a colecao
          .doc(uidUsuario)
          .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
          .doc(nomeDocumentoRegiao) // passando documento
          .get()
          .then((querySnapshot) async {
        // verificando cada item que esta gravado no banco de dados
        if (mounted) {
          if (querySnapshot.data() != null) {
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
          } else {
            redirecionarTelaLoginCadastro();
          }
        }
      }, onError: (e) {
        debugPrint("ErroONSS${e.toString()}");
        chamarValidarErro(e.toString());
      }).timeout(
        Duration(seconds: Constantes.fireBaseDuracaoTimeOut),
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

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 2), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    });
    return LayoutBuilder(
      builder: (context, constraints) {
        if (exibirTelaCarregamento) {
          return TelaCarregamentoWidget(
            corPadrao: ConstantesEstadosGestos.corPadraoRegioes,
          );
        } else {
          return Scaffold(
              appBar: AppBar(
                title: Text(Textos.tituloTelaRegiaoSudeste),
                backgroundColor: Colors.white,
                leading: IconButton(
                    color: Colors.black,
                    //setando tamanho do icone
                    iconSize: 30,
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        exibirTelaCarregamento = true;
                      });
                      Timer(
                          Duration(seconds: Constantes.duracaoDelayVoltarTela),
                          () {
                        Navigator.pushReplacementNamed(
                            context, Constantes.rotaTelaInicialRegioes);
                      });
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
              ),
              body: AreaTelaRegioesWidget(
                  nomeColecao: nomeColecao,
                  estadosSorteio: estadosSorteio,
                  exibirTelaProximoNivel: exibirTelaProximoNivel),
              bottomNavigationBar: WidgetAreaGestosArrastar(
                nomeColecao: nomeColecao,
                gestos: gestos,
                estadoGestoMap: estadoGestoMap,
                exibirTelaCarregamento: exibirTelaCarregamento,
              ));
        }
      },
    );
  }
}
