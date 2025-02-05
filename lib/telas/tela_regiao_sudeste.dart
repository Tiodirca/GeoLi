import 'package:flutter/material.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/constantes_caminhos_imagens.dart';
import 'package:geoli/Widgets/gestos_widget.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoli/Widgets/tela_carregamento.dart';
import 'package:geoli/Widgets/widget_area_gestos.dart';
import 'package:geoli/Widgets/widget_area_tela.dart';

import '../Uteis/textos.dart';

class TelaRegiaoSudeste extends StatefulWidget {
  const TelaRegiaoSudeste({super.key});

  @override
  State<TelaRegiaoSudeste> createState() => _TelaRegiaoSudesteState();
}

class _TelaRegiaoSudesteState extends State<TelaRegiaoSudeste> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  Estado estadoSP = Estado(
      nome: Constantes.nomeRegiaoSudesteSP,
      caminhoImagem: CaminhosImagens.regiaoSudesteSPImagem,
      acerto: false);
  Estado estadoRJ = Estado(
      nome: Constantes.nomeRegiaoSudesteRJ,
      caminhoImagem: CaminhosImagens.regiaoSudesteRJImagem,
      acerto: false);
  Estado estadoES = Estado(
      nome: Constantes.nomeRegiaoSudesteES,
      caminhoImagem: CaminhosImagens.regiaoSudesteESImagem,
      acerto: false);
  Estado estadoMG = Estado(
      nome: Constantes.nomeRegiaoSudesteMG,
      caminhoImagem: CaminhosImagens.regiaoSudesteMGImagem,
      acerto: false);

  Gestos gestoSP = Gestos(
      nomeGesto: Constantes.nomeRegiaoSudesteSP,
      nomeImagem: CaminhosImagens.gestoSudesteSP);
  Gestos gestoRJ = Gestos(
      nomeGesto: Constantes.nomeRegiaoSudesteRJ,
      nomeImagem: CaminhosImagens.gestoSudesteRJ);
  Gestos gestoES = Gestos(
      nomeGesto: Constantes.nomeRegiaoSudesteES,
      nomeImagem: CaminhosImagens.gestoSudesteES);
  Gestos gestoMG = Gestos(
      nomeGesto: Constantes.nomeRegiaoSudesteMG,
      nomeImagem: CaminhosImagens.gestoSudesteMG);

  Map<Estado, Gestos> estadosMapAuxiliar = {};
  List<MapEntry<Estado, Gestos>> estadosSorteio = [];
  List<Gestos> gestos = [];
  bool exibirTelaCarregamento = true;
  bool exibirTelaProximoNivel = false;
  String nomeTela = Constantes.nomeRegiaoSudeste;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carregarEstados();
    // adicionando itens na lista e fazendo o sorteio dos itens na lista
    gestos.addAll([gestoSP, gestoRJ, gestoMG, gestoES]);
    gestos.shuffle();
    // chamando metodo para fazer busca no banco de dados
    realizarBuscaDadosFireBase(Constantes.fireBaseDocumentoRegiaoSudeste);
  }

  // metodo para adicionar os estados no map auxiliar e depois adicionar numa lista e fazer o sorteio dos itens
  carregarEstados() {
    estadosMapAuxiliar[estadoMG] = gestoMG;
    estadosMapAuxiliar[estadoES] = gestoES;
    estadosMapAuxiliar[estadoSP] = gestoSP;
    estadosMapAuxiliar[estadoRJ] = gestoRJ;
    estadosSorteio = estadosMapAuxiliar.entries.toList();
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
              if (estadoRJ.nome == key) {
                gestos = MetodosAuxiliares.removerGestoLista(
                    estadoRJ, value, gestos);
              } else if (estadoSP.nome == key) {
                gestos = MetodosAuxiliares.removerGestoLista(
                    estadoSP, value, gestos);
              } else if (estadoES.nome == key) {
                gestos = MetodosAuxiliares.removerGestoLista(
                    estadoES, value, gestos);
              } else if (estadoMG.nome == key) {
                gestos = MetodosAuxiliares.removerGestoLista(
                    estadoMG, value, gestos);
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
