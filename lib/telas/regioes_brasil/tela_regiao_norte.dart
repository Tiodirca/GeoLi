import 'package:flutter/material.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/constantes_estados_gestos.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Widgets/tela_carregamento.dart';
import 'package:geoli/Widgets/estados/widget_area_gestos.dart';
import 'package:geoli/Widgets/estados/widget_area_tela.dart';


class TelaRegiaoNorte extends StatefulWidget {
  const TelaRegiaoNorte({super.key});

  @override
  State<TelaRegiaoNorte> createState() => _TelaRegiaoNorteState();
}

class _TelaRegiaoNorteState extends State<TelaRegiaoNorte> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  Map<Estado, Gestos> estadoGestoMap = {};
  List<MapEntry<Estado, Gestos>> estadosSorteio = [];
  List<Gestos> gestos = [];
  bool exibirTelaCarregamento = true;
  bool exibirTelaProximoNivel = false;
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
    var db = FirebaseFirestore.instance;
    //instanciano variavel
    db
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    Navigator.pushReplacementNamed(
                        context, Constantes.rotaTelaInicialRegioes);
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
            )),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (exibirTelaCarregamento) {
              return TelaCarregamento();
            } else {
              return WidgetAreaTela(
                  nomeColecao: nomeColecao,
                  estadosSorteio: estadosSorteio,
                  exibirTelaProximoNivel: exibirTelaProximoNivel);
            }
          },
        ),
        bottomNavigationBar: WidgetAreaGestos(
          nomeColecao: nomeColecao,
          gestos: gestos,
          estadoGestoMap: estadoGestoMap,
          exibirTelaCarregamento: exibirTelaCarregamento,
        ));
  }
}
