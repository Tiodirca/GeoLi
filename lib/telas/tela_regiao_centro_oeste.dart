import 'package:flutter/material.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/constantes_caminhos_imagens.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoli/Widgets/tela_carregamento.dart';
import 'package:geoli/Widgets/widget_area_gestos.dart';
import 'package:geoli/Widgets/widget_area_tela.dart';
import '../Uteis/textos.dart';

class TelaRegiaoCentroOeste extends StatefulWidget {
  const TelaRegiaoCentroOeste({super.key});

  @override
  State<TelaRegiaoCentroOeste> createState() => _TelaRegiaoCentroOesteState();
}

class _TelaRegiaoCentroOesteState extends State<TelaRegiaoCentroOeste> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  Estado estadoGO = Estado(
      nome: Constantes.nomeRegiaoCentroGO,
      caminhoImagem: CaminhosImagens.regiaoCentroGOImagem,
      acerto: false);
  Estado estadoMG = Estado(
      nome: Constantes.nomeRegiaoCentroMG,
      caminhoImagem: CaminhosImagens.regiaoCentroMGImagem,
      acerto: false);
  Estado estadoMS = Estado(
      nome: Constantes.nomeRegiaoCentroMS,
      caminhoImagem: CaminhosImagens.regiaoCentroMSImagem,
      acerto: false);

  Gestos gestoGO = Gestos(
      nomeGesto: Constantes.nomeRegiaoCentroGO,
      nomeImagem: CaminhosImagens.gestoCentroGO);
  Gestos gestoMG = Gestos(
      nomeGesto: Constantes.nomeRegiaoCentroMG,
      nomeImagem: CaminhosImagens.gestoCentroMG);
  Gestos gestoMS = Gestos(
      nomeGesto: Constantes.nomeRegiaoCentroMS,
      nomeImagem: CaminhosImagens.gestoCentroMS);

  List<Estado> estadosCentro = [];
  List<Gestos> gestos = [];
  bool exibirTelaCarregamento = true;
  bool exibirTelaProximoNivel = false;
  Map<Estado, Gestos> estadoGestoMap = {};
  List<MapEntry<Estado, Gestos>> estadosSorteio = [];
  String nomeTela = Constantes.nomeRegiaoCentroOeste;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gestos.addAll([gestoGO, gestoMG, gestoMS]); // adicionando itens na lista
    gestos.shuffle(); // fazendo sorteio dos gestos na lista
    // chamando metodo para fazer busca no banco de dados
    realizarBuscaDadosFireBase(Constantes.fireBaseDocumentoRegiaoCentroOeste);
  }

  // metodo para adicionar os estados no map auxiliar e
  // depois adicionar numa lista e fazer o sorteio dos itens
  carregarEstados() {
    estadoGestoMap[estadoMS] = gestoMS;
    estadoGestoMap[estadoGO] = gestoGO;
    estadoGestoMap[estadoMG] = gestoMG;
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
            //caso o valor da CHAVE for o mesmo que o nome do ESTADO entrar na condicao
            setState(() {
              if (estadoMG.nome == key) {
                MetodosAuxiliares.removerGestoLista(estadoMG, value, gestos);
              } else if (estadoMS.nome == key) {
                MetodosAuxiliares.removerGestoLista(estadoMS, value, gestos);
                estadoMS.acerto = value;
              } else if (estadoGO.nome == key) {
                MetodosAuxiliares.removerGestoLista(estadoGO, value, gestos);
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
              return TelaCarregamento();
            } else {
              return WidgetAreaTela(
                  nomeTela: nomeTela,
                  estadosSorteio: estadosSorteio,
                  exibirTelaProximoNivel: exibirTelaProximoNivel);
            }
          },
        ),
        bottomNavigationBar: WidgetAreaGestos(
          gestos: gestos,
          estadoGestoMap: estadoGestoMap,
          exibirTelaCarregamento: exibirTelaCarregamento,
        ));
  }
}
