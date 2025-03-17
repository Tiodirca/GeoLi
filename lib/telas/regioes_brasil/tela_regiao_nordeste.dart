import 'package:flutter/material.dart';
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

class TelaRegiaoNordeste extends StatefulWidget {
  const TelaRegiaoNordeste({super.key});

  @override
  State<TelaRegiaoNordeste> createState() => _TelaRegiaoNordesteState();
}

class _TelaRegiaoNordesteState extends State<TelaRegiaoNordeste> {
  Map<Estado, Gestos> estadoGestoMap = {};
  List<MapEntry<Estado, Gestos>> estadosSorteio = [];
  List<Gestos> gestos = [];
  bool exibirTelaCarregamento = true;
  bool exibirTelaProximoNivel = false;
  late String uidUsuario;
  bool exibirMensagemSemConexao = false;
  String nomeColecao = Constantes.fireBaseDocumentoRegiaoNordeste;

  @override
  void initState() {
    super.initState();
    carregarEstados();
    gestos.addAll([
      ConstantesEstadosGestos.gestoAL,
      ConstantesEstadosGestos.gestoBA,
      ConstantesEstadosGestos.gestoCE,
      ConstantesEstadosGestos.gestoMA,
      ConstantesEstadosGestos.gestoPB,
      ConstantesEstadosGestos.gestoPE,
      ConstantesEstadosGestos.gestoPI,
      ConstantesEstadosGestos.gestoRN,
      ConstantesEstadosGestos.gestoSE
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
    estadoGestoMap[ConstantesEstadosGestos.estadoAL] =
        ConstantesEstadosGestos.gestoAL;
    estadoGestoMap[ConstantesEstadosGestos.estadoBA] =
        ConstantesEstadosGestos.gestoBA;
    estadoGestoMap[ConstantesEstadosGestos.estadoCE] =
        ConstantesEstadosGestos.gestoCE;
    estadoGestoMap[ConstantesEstadosGestos.estadoMA] =
        ConstantesEstadosGestos.gestoMA;
    estadoGestoMap[ConstantesEstadosGestos.estadoPB] =
        ConstantesEstadosGestos.gestoPB;
    estadoGestoMap[ConstantesEstadosGestos.estadoPE] =
        ConstantesEstadosGestos.gestoPE;
    estadoGestoMap[ConstantesEstadosGestos.estadoPI] =
        ConstantesEstadosGestos.gestoPI;
    estadoGestoMap[ConstantesEstadosGestos.estadoRN] =
        ConstantesEstadosGestos.gestoRN;
    estadoGestoMap[ConstantesEstadosGestos.estadoSE] =
        ConstantesEstadosGestos.gestoSE;
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
                if (ConstantesEstadosGestos.estadoAL.nome == key) {
                  MetodosAuxiliares.removerGestoLista(
                      ConstantesEstadosGestos.estadoAL, value, gestos);
                } else if (ConstantesEstadosGestos.estadoBA.nome == key) {
                  MetodosAuxiliares.removerGestoLista(
                      ConstantesEstadosGestos.estadoBA, value, gestos);
                } else if (ConstantesEstadosGestos.estadoCE.nome == key) {
                  MetodosAuxiliares.removerGestoLista(
                      ConstantesEstadosGestos.estadoCE, value, gestos);
                } else if (ConstantesEstadosGestos.estadoMA.nome == key) {
                  MetodosAuxiliares.removerGestoLista(
                      ConstantesEstadosGestos.estadoMA, value, gestos);
                } else if (ConstantesEstadosGestos.estadoPB.nome == key) {
                  MetodosAuxiliares.removerGestoLista(
                      ConstantesEstadosGestos.estadoPB, value, gestos);
                } else if (ConstantesEstadosGestos.estadoPE.nome == key) {
                  MetodosAuxiliares.removerGestoLista(
                      ConstantesEstadosGestos.estadoPE, value, gestos);
                } else if (ConstantesEstadosGestos.estadoPI.nome == key) {
                  MetodosAuxiliares.removerGestoLista(
                      ConstantesEstadosGestos.estadoPI, value, gestos);
                } else if (ConstantesEstadosGestos.estadoRN.nome == key) {
                  MetodosAuxiliares.removerGestoLista(
                      ConstantesEstadosGestos.estadoRN, value, gestos);
                } else if (ConstantesEstadosGestos.estadoSE.nome == key) {
                  MetodosAuxiliares.removerGestoLista(
                      ConstantesEstadosGestos.estadoSE, value, gestos);
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
          debugPrint("ErroONNN${e.toString()}");
          validarErro(e.toString());
        });
      } catch (e) {
        debugPrint("ErroNN${e.toString()}");
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
            Constantes.rotaTelaRegiaoNordeste);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Visibility(
                visible: !exibirTelaCarregamento,
                child: Text(Textos.tituloTelaRegiaoNordeste)),
            backgroundColor: Colors.white,
            leading: Visibility(
              visible: !exibirTelaCarregamento,
              child: IconButton(
                  color: Colors.black,
                  //setando tamanho do icone
                  iconSize: 30,
                  enableFeedback: false,
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, Constantes.rotaTelaInicialRegioes);
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
