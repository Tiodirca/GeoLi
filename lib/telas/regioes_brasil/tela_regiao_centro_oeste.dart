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
  String nomeColecao = Constantes.fireBaseDocumentoRegiaoCentroOeste;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recuperarUIDUsuario();
  }

  recuperarUIDUsuario() async {
    uidUsuario = await MetodosAuxiliares.recuperarUid();
    validarPrimeiraJogada();
  }

  validarPrimeiraJogada() async {
    // recebendo a pontuacao que esta sendo passada na
    // TELA INICIAL REGIOES e do WIDGET AREA GESTOS
    int pontuacao = await MetodosAuxiliares.recuperarPontuacaoAtual();
    // Entrar no tutorial de jogo caso a pontuacao seja 0
    if (pontuacao == 0) {
      setState(() {
        carregarEstados();
        exibirTelaCarregamento = false;
        gestos.addAll([ConstantesEstadosGestos.gestoMS]);
        //passando status de tutorial ativo para os WIGETS
        // validar acoes baseado no status passado
        MetodosAuxiliares.passarStatusTutorial(Constantes.statusTutorialAtivo);
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
