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

class TelaRegiaoNordeste extends StatefulWidget {
  const TelaRegiaoNordeste({super.key});

  @override
  State<TelaRegiaoNordeste> createState() => _TelaRegiaoNordesteState();
}

class _TelaRegiaoNordesteState extends State<TelaRegiaoNordeste> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  Estado estadoAL = Estado(
      nome: Constantes.nomeRegiaoNordesteAL,
      caminhoImagem: CaminhosImagens.regiaoNordesteALImagem,
      acerto: false);
  Estado estadoBA = Estado(
      nome: Constantes.nomeRegiaoNordesteBA,
      caminhoImagem: CaminhosImagens.regiaoNordesteBAImagem,
      acerto: false);
  Estado estadoCE = Estado(
      nome: Constantes.nomeRegiaoNordesteCE,
      caminhoImagem: CaminhosImagens.regiaoNordesteCEImagem,
      acerto: false);
  Estado estadoMA = Estado(
      nome: Constantes.nomeRegiaoNordesteMA,
      caminhoImagem: CaminhosImagens.regiaoNordesteMAImagem,
      acerto: false);
  Estado estadoPB = Estado(
      nome: Constantes.nomeRegiaoNordestePB,
      caminhoImagem: CaminhosImagens.regiaoNordestePBImagem,
      acerto: false);
  Estado estadoPE = Estado(
      nome: Constantes.nomeRegiaoNordestePE,
      caminhoImagem: CaminhosImagens.regiaoNordestePEImagem,
      acerto: false);
  Estado estadoPI = Estado(
      nome: Constantes.nomeRegiaoNordestePI,
      caminhoImagem: CaminhosImagens.regiaoNordestePIImagem,
      acerto: false);
  Estado estadoRN = Estado(
      nome: Constantes.nomeRegiaoNordesteRN,
      caminhoImagem: CaminhosImagens.regiaoNordesteRNImagem,
      acerto: false);
  Estado estadoSE = Estado(
      nome: Constantes.nomeRegiaoNordesteSE,
      caminhoImagem: CaminhosImagens.regiaoNordesteSEImagem,
      acerto: false);

  Gestos gestoAL = Gestos(
      nomeGesto: Constantes.nomeRegiaoNordesteAL,
      nomeImagem: CaminhosImagens.gestoNordesteALImagem);
  Gestos gestoBA = Gestos(
      nomeGesto: Constantes.nomeRegiaoNordesteBA,
      nomeImagem: CaminhosImagens.gestoNordesteBAImagem);
  Gestos gestoCE = Gestos(
      nomeGesto: Constantes.nomeRegiaoNordesteCE,
      nomeImagem: CaminhosImagens.gestoNordesteCEImagem);
  Gestos gestoMA = Gestos(
      nomeGesto: Constantes.nomeRegiaoNordesteMA,
      nomeImagem: CaminhosImagens.gestoNordesteMAImagem);
  Gestos gestoPB = Gestos(
      nomeGesto: Constantes.nomeRegiaoNordestePB,
      nomeImagem: CaminhosImagens.gestoNordestePBImagem);
  Gestos gestoPE = Gestos(
      nomeGesto: Constantes.nomeRegiaoNordestePE,
      nomeImagem: CaminhosImagens.gestoNordestePEImagem);
  Gestos gestoPI = Gestos(
      nomeGesto: Constantes.nomeRegiaoNordestePI,
      nomeImagem: CaminhosImagens.gestoNordestePIImagem);
  Gestos gestoRN = Gestos(
      nomeGesto: Constantes.nomeRegiaoNordesteRN,
      nomeImagem: CaminhosImagens.gestoNordesteRNImagem);
  Gestos gestoSE = Gestos(
      nomeGesto: Constantes.nomeRegiaoNordesteSE,
      nomeImagem: CaminhosImagens.gestoNordesteSEImagem);

  Map<Estado, Gestos> estadoGestoMap = {};
  List<MapEntry<Estado, Gestos>> estadosSorteio = [];
  List<Gestos> gestos = [];
  bool exibirTelaCarregamento = true;
  bool exibirTelaProximoNivel = false;
  String nomeTela = Constantes.nomeRegiaoNordeste;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carregarEstados();
    gestos.addAll([
      gestoAL,
      gestoBA,
      gestoCE,
      gestoMA,
      gestoPB,
      gestoPE,
      gestoPI,
      gestoRN,
      gestoSE
    ]);
    gestos.shuffle();
    // chamando metodo para fazer busca no banco de dados
    realizarBuscaDadosFireBase(Constantes.fireBaseDocumentoRegiaoNordeste);
  }

  carregarEstados() {
    estadoGestoMap[estadoAL] = gestoAL;
    estadoGestoMap[estadoBA] = gestoBA;
    estadoGestoMap[estadoCE] = gestoCE;
    estadoGestoMap[estadoMA] = gestoMA;
    estadoGestoMap[estadoPB] = gestoPB;
    estadoGestoMap[estadoPE] = gestoPE;
    estadoGestoMap[estadoPI] = gestoPI;
    estadoGestoMap[estadoRN] = gestoRN;
    estadoGestoMap[estadoSE] = gestoSE;
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
              if (estadoAL.nome == key) {
                MetodosAuxiliares.removerGestoLista(estadoAL, value, gestos);
              } else if (estadoBA.nome == key) {
                MetodosAuxiliares.removerGestoLista(estadoBA, value, gestos);
              } else if (estadoCE.nome == key) {
                MetodosAuxiliares.removerGestoLista(estadoCE, value, gestos);
              } else if (estadoMA.nome == key) {
                MetodosAuxiliares.removerGestoLista(estadoMA, value, gestos);
              } else if (estadoPB.nome == key) {
                MetodosAuxiliares.removerGestoLista(estadoPB, value, gestos);
              } else if (estadoPE.nome == key) {
                MetodosAuxiliares.removerGestoLista(estadoPE, value, gestos);
              } else if (estadoPI.nome == key) {
                MetodosAuxiliares.removerGestoLista(estadoPI, value, gestos);
              } else if (estadoRN.nome == key) {
                MetodosAuxiliares.removerGestoLista(estadoRN, value, gestos);
              } else if (estadoSE.nome == key) {
                MetodosAuxiliares.removerGestoLista(estadoSE, value, gestos);
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
