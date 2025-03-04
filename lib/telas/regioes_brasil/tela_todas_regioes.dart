import 'package:flutter/material.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/constantes_estados_gestos.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoli/Widgets/estados/widget_area_gestos_arrastar.dart';
import 'package:geoli/Widgets/estados/widget_area_tela_regioes.dart';
import 'package:geoli/Widgets/tela_carregamento_widget.dart';

import '../../Uteis/textos.dart';

class TelaTodasRegioes extends StatefulWidget {
  const TelaTodasRegioes({super.key});

  @override
  State<TelaTodasRegioes> createState() => _TelaTodasRegioesState();
}

class _TelaTodasRegioesState extends State<TelaTodasRegioes> {
  Map<Estado, Gestos> estadoGestoMap = {};
  List<MapEntry<Estado, Gestos>> estadosSorteio = [];
  List<Gestos> gestos = [];
  bool exibirTelaCarregamento = true;
  bool exibirTelaProximoNivel = false;
  late String uidUsuario;
  String nomeColecao = Constantes.fireBaseDocumentoRegiaoTodosEstados;

  @override
  void initState() {
    super.initState();
    carregarEstados();
    gestos.addAll([
      ConstantesEstadosGestos.gestoGO,
      ConstantesEstadosGestos.gestoMT,
      ConstantesEstadosGestos.gestoMS,
      ConstantesEstadosGestos.gestoPR,
      ConstantesEstadosGestos.gestoSC,
      ConstantesEstadosGestos.gestoRS,
      ConstantesEstadosGestos.gestoSP,
      ConstantesEstadosGestos.gestoRJ,
      ConstantesEstadosGestos.gestoMG,
      ConstantesEstadosGestos.gestoES,
      ConstantesEstadosGestos.gestoAC,
      ConstantesEstadosGestos.gestoAP,
      ConstantesEstadosGestos.gestoAM,
      ConstantesEstadosGestos.gestoPA,
      ConstantesEstadosGestos.gestoRO,
      ConstantesEstadosGestos.gestoRR,
      ConstantesEstadosGestos.gestoTO,
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
    //MetodosAuxiliares.addItensBancoDados(Constantes.fireBaseDocumentoRegiaoTodosEstados);
    // chamando metodo para fazer busca no banco de dados
    recuperarUIDUsuario();
  }

  recuperarUIDUsuario() async {
    uidUsuario = await MetodosAuxiliares.recuperarUid();
    realizarBuscaDadosFireBase(nomeColecao);
  }

  carregarEstados() {
    estadoGestoMap = ConstantesEstadosGestos.adicionarEstadosGestos();
    estadosSorteio = estadoGestoMap.entries.toList();
    estadosSorteio.shuffle();
  }

  realizarBuscaDadosFireBase(String nomeDocumentoRegiao) async {
    var db = FirebaseFirestore.instance;
    //instanciano variavel
    db
        .collection(uidUsuario) // passando a colecao
        .doc(Constantes.fireBaseColecaoRegioes)
        .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
        .doc(nomeDocumentoRegiao) // passando documento
        .get()
        .then(
      (querySnapshot) async {
        // verificando cada item que esta gravado no banco de dados
        querySnapshot.data()!.forEach(
          (key, value) {
            // caso o valor da CHAVE for o mesmo que o nome do ESTADO entrar na condicao
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
              } else if (ConstantesEstadosGestos.estadoSC.nome == key) {
                MetodosAuxiliares.removerGestoLista(
                    ConstantesEstadosGestos.estadoSC, value, gestos);
              } else if (ConstantesEstadosGestos.estadoRS.nome == key) {
                MetodosAuxiliares.removerGestoLista(
                    ConstantesEstadosGestos.estadoRS, value, gestos);
              } else if (ConstantesEstadosGestos.estadoPR.nome == key) {
                MetodosAuxiliares.removerGestoLista(
                    ConstantesEstadosGestos.estadoPR, value, gestos);
              } else if (ConstantesEstadosGestos.estadoRJ.nome == key) {
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
              } else if (ConstantesEstadosGestos.estadoAC.nome == key) {
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
              } else if (ConstantesEstadosGestos.estadoAL.nome == key) {
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Visibility(
                visible: !exibirTelaCarregamento,
                child: Text(Textos.tituloTelaTodasRegioes)),
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
                corPadrao: ConstantesEstadosGestos.corPadraoRegioes,
              );
            } else {
              return WidgetAreaTelaRegioes(
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
