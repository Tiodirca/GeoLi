import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/constantes_caminhos_imagens.dart';
import 'package:geoli/Widgets/area_soltar.dart';
import 'package:geoli/Widgets/gestos_widget.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoli/Widgets/tela_carregamento.dart';
import 'package:geoli/Widgets/tela_proximo_nivel.dart';
import 'package:geoli/Widgets/widget_area_gestos.dart';
import 'package:geoli/Widgets/widget_area_tela.dart';

import '../Uteis/textos.dart';

class TelaRegiaoSul extends StatefulWidget {
  const TelaRegiaoSul({super.key});

  @override
  State<TelaRegiaoSul> createState() => _TelaRegiaoSulState();
}

class _TelaRegiaoSulState extends State<TelaRegiaoSul> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  Estado estadoPR = Estado(
      nome: Constantes.nomeRegiaoSulPR,
      caminhoImagem: CaminhosImagens.regiaoSulPRImagem,
      acerto: false);
  Estado estadoRS = Estado(
      nome: Constantes.nomeRegiaoSulRS,
      caminhoImagem: CaminhosImagens.regiaoSulRSImagem,
      acerto: false);
  Estado estadoSC = Estado(
      nome: Constantes.nomeRegiaoSulSC,
      caminhoImagem: CaminhosImagens.regiaoSulSCImagem,
      acerto: false);

  Gestos gestoPR = Gestos(
      nomeGesto: Constantes.nomeRegiaoSulPR,
      nomeImagem: CaminhosImagens.gestoSulPR);
  Gestos gestoRS = Gestos(
      nomeGesto: Constantes.nomeRegiaoSulRS,
      nomeImagem: CaminhosImagens.gestoSulRS);
  Gestos gestoSC = Gestos(
      nomeGesto: Constantes.nomeRegiaoSulSC,
      nomeImagem: CaminhosImagens.gestoSulSC);
  List<Gestos> gestos = [];
  Map<Estado, Gestos> estadosMapAuxiliar = {};
  List<MapEntry<Estado, Gestos>> estadosSorteio = [];
  bool exibirTelaCarregamento = true;
  bool exibirTelaProximoNivel = false;
  String nomeTela = Constantes.nomeRegiaoSul;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carregarEstados();
    gestos.addAll([gestoPR, gestoSC, gestoRS]); // adicionando gestos na lista
    gestos.shuffle(); //fazendo sorteio os itens na lista
    // chamando metodo para fazer busca no banco de dados
    realizarBuscaDadosFireBase(Constantes.fireBaseDocumentoRegiaoSul);
  }

  // metodo para adicionar os estados no map auxiliar e depois adicionar numa lista e fazer o sorteio dos itens
  carregarEstados() {
    estadosMapAuxiliar[estadoRS] = gestoRS;
    estadosMapAuxiliar[estadoSC] = gestoSC;
    estadosMapAuxiliar[estadoPR] = gestoPR;
    estadosSorteio = estadosMapAuxiliar.entries.toList();
    estadosSorteio.shuffle();
  }

  //metodo para realizar busca no bando de dados
  atualizarDadosBanco() async {
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
          .doc(Constantes.fireBaseDocumentoRegiaoSul) //passando o documento
          .set({
        Constantes.nomeRegiaoSulPR: estadoPR.acerto,
        Constantes.nomeRegiaoSulSC: estadoSC.acerto,
        Constantes.nomeRegiaoSulRS: estadoRS.acerto,
      });
    } catch (e) {
      print(e.toString());
    }
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
              if (estadoSC.nome == key) {
                MetodosAuxiliares.removerGestoLista(estadoSC, value, gestos);
              } else if (estadoRS.nome == key) {
                MetodosAuxiliares.removerGestoLista(estadoRS, value, gestos);
              } else if (estadoPR.nome == key) {
                MetodosAuxiliares.removerGestoLista(estadoPR, value, gestos);
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

  Widget itemSoltar(Gestos gesto) => Draggable(
        onDragCompleted: () async {
          // variavel vai receber o retorno do metodo para poder
          // verificar se o usuario acertou o gesto no estado correto
          String retorno = await MetodosAuxiliares.recuperarAcerto();
          if (retorno == Constantes.msgAcertoGesto) {
            // caso tenha acertado ele ira remover da
            // lista de gestos o gesto que foi acertado
            setState(() {
              gestos.removeWhere(
                (element) {
                  return element.nomeGesto == gesto.nomeGesto;
                },
              );
            });
            if (gestos.isEmpty) {
              setState(() {
                exibirTelaProximoNivel = true;
              });
            }
            atualizarDadosBanco();
          }
        },
        maxSimultaneousDrags: 1,
        data: gesto.nomeGesto,
        feedback: GestosWidget(
          nomeGestoImagem: gesto.nomeImagem,
          nomeGesto: gesto.nomeGesto,
          exibirAcerto: false,
        ),
        rootOverlay: true,
        childWhenDragging: Container(),
        child: GestosWidget(
          nomeGestoImagem: gesto.nomeImagem,
          nomeGesto: gesto.nomeGesto,
          exibirAcerto: false,
        ),
      );

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
          estadosMapAuxiliar: estadosMapAuxiliar,
          exibirTelaCarregamento: exibirTelaCarregamento,
        ));
  }
}
