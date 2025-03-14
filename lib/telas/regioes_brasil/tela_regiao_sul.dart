import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/constantes_estados_gestos.dart';
import 'package:geoli/Widgets/estados/area_tela_regioes_widget.dart';
import 'package:geoli/Widgets/estados/widget_area_gestos_arrastar.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoli/Widgets/tela_carregamento_widget.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../Uteis/textos.dart';

class TelaRegiaoSul extends StatefulWidget {
  const TelaRegiaoSul({super.key});

  @override
  State<TelaRegiaoSul> createState() => _TelaRegiaoSulState();
}

class _TelaRegiaoSulState extends State<TelaRegiaoSul> {
  List<Gestos> gestos = [];
  Map<Estado, Gestos> estadoGestoMap = {};
  List<MapEntry<Estado, Gestos>> estadosSorteio = [];
  bool exibirTelaCarregamento = true;
  bool exibirTelaProximoNivel = false;
  late String uidUsuario;
  String nomeColecao = Constantes.fireBaseDocumentoRegiaoSul;

  bool exibirMensagem = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    validarConexao();
    gestos.addAll([
      ConstantesEstadosGestos.gestoPR,
      ConstantesEstadosGestos.gestoSC,
      ConstantesEstadosGestos.gestoRS
    ]); // adicionando gestos na lista
    gestos.shuffle(); //fazendo sorteio os itens na lista
    // chamando metodo para fazer busca no banco de dados
    recuperarUIDUsuario();
    validarConexao();
  }

  validarConexao() async {
    bool retornoConexao = await InternetConnection().hasInternetAccess;
    if (retornoConexao) {
      if (mounted) {
        setState(() {
          exibirTelaCarregamento = false;
          exibirMensagem = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          exibirTelaCarregamento = true;
          exibirMensagem = true;
        });
      }
    }
    Timer( Duration(seconds: Constantes.duracaoVerificarConexao), () {
      validarConexao();
    });
  }

  recuperarUIDUsuario() async {
    uidUsuario = await MetodosAuxiliares.recuperarUid();
    realizarBuscaDadosFireBase(nomeColecao);
  }

  // metodo para adicionar os estados no map
  // auxiliar e depois adicionar numa lista e fazer o sorteio dos itens
  carregarEstados() {
    estadoGestoMap[ConstantesEstadosGestos.estadoRS] =
        ConstantesEstadosGestos.gestoRS;
    estadoGestoMap[ConstantesEstadosGestos.estadoSC] =
        ConstantesEstadosGestos.gestoSC;
    estadoGestoMap[ConstantesEstadosGestos.estadoPR] =
        ConstantesEstadosGestos.gestoPR;
    estadosSorteio = estadoGestoMap.entries.toList();
    estadosSorteio.shuffle();
  }

  realizarBuscaDadosFireBase(String nomeDocumentoRegiao) async {
    var db = FirebaseFirestore.instance;
    //instanciano variavel
    db
        .collection(Constantes.fireBaseColecaoUsuarios) // passando a colecao
        .doc(uidUsuario)
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
              if (ConstantesEstadosGestos.estadoSC.nome == key) {
                MetodosAuxiliares.removerGestoLista(
                    ConstantesEstadosGestos.estadoSC, value, gestos);
              } else if (ConstantesEstadosGestos.estadoRS.nome == key) {
                MetodosAuxiliares.removerGestoLista(
                    ConstantesEstadosGestos.estadoRS, value, gestos);
              } else if (ConstantesEstadosGestos.estadoPR.nome == key) {
                MetodosAuxiliares.removerGestoLista(
                    ConstantesEstadosGestos.estadoPR, value, gestos);
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Visibility(
                visible: !exibirTelaCarregamento,
                child: Text(Textos.tituloTelaRegiaoSul)),
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
                exibirMensagemConexao: exibirMensagem,
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
