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
import 'package:geoli/Widgets/widget_area_gestos.dart';
import 'package:geoli/Widgets/widget_area_tela.dart';

import '../Uteis/textos.dart';

class TelaRegiaoNorte extends StatefulWidget {
  const TelaRegiaoNorte({super.key});

  @override
  State<TelaRegiaoNorte> createState() => _TelaRegiaoNorteState();
}

class _TelaRegiaoNorteState extends State<TelaRegiaoNorte> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  Estado estadoAC = Estado(
      nome: Constantes.nomeRegiaoNorteAC,
      caminhoImagem: CaminhosImagens.regiaoNorteACImagem,
      acerto: false);
  Estado estadoAP = Estado(
      nome: Constantes.nomeRegiaoNorteAP,
      caminhoImagem: CaminhosImagens.regiaoNorteAPImagem,
      acerto: false);
  Estado estadoAM = Estado(
      nome: Constantes.nomeRegiaoNorteAM,
      caminhoImagem: CaminhosImagens.regiaoNorteAMImagem,
      acerto: false);
  Estado estadoPA = Estado(
      nome: Constantes.nomeRegiaoNortePA,
      caminhoImagem: CaminhosImagens.regiaoNortePAImagem,
      acerto: false);
  Estado estadoRO = Estado(
      nome: Constantes.nomeRegiaoNorteRO,
      caminhoImagem: CaminhosImagens.regiaoNorteROImagem,
      acerto: false);
  Estado estadoRR = Estado(
      nome: Constantes.nomeRegiaoNorteRR,
      caminhoImagem: CaminhosImagens.regiaoNorteRRImagem,
      acerto: false);
  Estado estadoTO = Estado(
      nome: Constantes.nomeRegiaoNorteTO,
      caminhoImagem: CaminhosImagens.regiaoNorteTOImagem,
      acerto: false);

  Gestos gestoAC = Gestos(
      nomeGesto: Constantes.nomeRegiaoNorteAC,
      nomeImagem: CaminhosImagens.gestoNorteACImagem);
  Gestos gestoAP = Gestos(
      nomeGesto: Constantes.nomeRegiaoNorteAP,
      nomeImagem: CaminhosImagens.gestoNorteACImagem);
  Gestos gestoAM = Gestos(
      nomeGesto: Constantes.nomeRegiaoNorteAM,
      nomeImagem: CaminhosImagens.gestoNorteAMImagem);
  Gestos gestoPA = Gestos(
      nomeGesto: Constantes.nomeRegiaoNortePA,
      nomeImagem: CaminhosImagens.gestoNortePAImagem);
  Gestos gestoRO = Gestos(
      nomeGesto: Constantes.nomeRegiaoNorteRO,
      nomeImagem: CaminhosImagens.gestoNorteROImagem);
  Gestos gestoRR = Gestos(
      nomeGesto: Constantes.nomeRegiaoNorteRR,
      nomeImagem: CaminhosImagens.gestoNorteRRImagem);
  Gestos gestoTO = Gestos(
      nomeGesto: Constantes.nomeRegiaoNorteTO,
      nomeImagem: CaminhosImagens.gestoNorteTOImagem);

  Map<Estado, Gestos> estadosMapAuxiliar = {};
  List<MapEntry<Estado, Gestos>> estadosSorteio = [];
  List<Gestos> gestos = [];
  bool exibirTelaCarregamento = true;
  bool exibirTelaProximoNivel = false;
  String nomeTela = Constantes.nomeRegiaoNorte;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carregarEstados();
    gestos.addAll(
        [gestoAC, gestoAP, gestoAM, gestoPA, gestoRO, gestoRR, gestoTO]);
    gestos.shuffle();
    // chamando metodo para fazer busca no banco de dados
    realizarBuscaDadosFireBase(Constantes.fireBaseDocumentoRegiaoNorte);
  }

  carregarEstados() {
    estadosMapAuxiliar[estadoAC] = gestoAC;
    estadosMapAuxiliar[estadoAP] = gestoAP;
    estadosMapAuxiliar[estadoAM] = gestoAM;
    estadosMapAuxiliar[estadoPA] = gestoPA;
    estadosMapAuxiliar[estadoRO] = gestoRO;
    estadosMapAuxiliar[estadoRR] = gestoRR;
    estadosMapAuxiliar[estadoTO] = gestoTO;
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
              if (estadoAC.nome == key) {
                MetodosAuxiliares.removerGestoLista(estadoAC, value, gestos);
              } else if (estadoAP.nome == key) {
                MetodosAuxiliares.removerGestoLista(estadoAP, value, gestos);
              } else if (estadoAM.nome == key) {
                MetodosAuxiliares.removerGestoLista(estadoAM, value, gestos);
              } else if (estadoPA.nome == key) {
                MetodosAuxiliares.removerGestoLista(estadoPA, value, gestos);
              } else if (estadoRO.nome == key) {
                MetodosAuxiliares.removerGestoLista(estadoRO, value, gestos);
              } else if (estadoRR.nome == key) {
                MetodosAuxiliares.removerGestoLista(estadoRR, value, gestos);
              } else if (estadoTO.nome == key) {
                MetodosAuxiliares.removerGestoLista(estadoTO, value, gestos);
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
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
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
