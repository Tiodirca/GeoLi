import 'package:flutter/material.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/constantes_estados_gestos.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Widgets/estados/widget_area_gestos_arrastar.dart';
import 'package:geoli/Widgets/estados/widget_area_tela_regioes.dart';
import 'package:geoli/Widgets/widget_tela_carregamento.dart';


class TelaRegiaoSudeste extends StatefulWidget {
  const TelaRegiaoSudeste({super.key});

  @override
  State<TelaRegiaoSudeste> createState() => _TelaRegiaoSudesteState();
}

class _TelaRegiaoSudesteState extends State<TelaRegiaoSudeste> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  Map<Estado, Gestos> estadoGestoMap = {};
  List<MapEntry<Estado, Gestos>> estadosSorteio = [];
  List<Gestos> gestos = [];
  bool exibirTelaCarregamento = true;
  bool exibirTelaProximoNivel = false;
  String nomeColecao = Constantes.fireBaseDocumentoRegiaoSudeste;

  @override
  void initState() {
    // TODO: implement initState
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
    realizarBuscaDadosFireBase(nomeColecao);
  }

  // metodo para adicionar os estados no map auxiliar e depois adicionar numa lista e fazer o sorteio dos itens
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    Navigator.pushReplacementNamed(
                        context, Constantes.rotaTelaInicialRegioes);
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
            )),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (exibirTelaCarregamento) {
              return WidgetTelaCarregamento(corPadrao: Constantes.corPadraoRegioes,);
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
