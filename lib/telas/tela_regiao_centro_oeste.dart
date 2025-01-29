import 'package:flutter/material.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Widgets/area_soltar.dart';
import 'package:geoli/Widgets/gestos_widget.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';

import '../Uteis/textos.dart';

class TelaRegiaoCentroOeste extends StatefulWidget {
  const TelaRegiaoCentroOeste({super.key});

  @override
  State<TelaRegiaoCentroOeste> createState() => _TelaRegiaoCentroOesteState();
}

class _TelaRegiaoCentroOesteState extends State<TelaRegiaoCentroOeste> {
  Estado estadoGO = Estado(
      nome: Constantes.nomeRegiaoCentroGO,
      nomeImagem: Constantes.regiaoCentroGOImagem);
  Estado estadoMG = Estado(
      nome: Constantes.nomeRegiaoCentroMG,
      nomeImagem: Constantes.regiaoCentroMGImagem);
  Estado estadoMS = Estado(
      nome: Constantes.nomeRegiaoCentroMS,
      nomeImagem: Constantes.regiaoCentroMSImagem);

  Gestos gestoGO = Gestos(
      nomeGesto: Constantes.nomeRegiaoCentroGO,
      nomeImagem: Constantes.gestoCentroGO);
  Gestos gestoMG = Gestos(
      nomeGesto: Constantes.nomeRegiaoCentroMG,
      nomeImagem: Constantes.gestoCentroMG);
  Gestos gestoMS = Gestos(
      nomeGesto: Constantes.nomeRegiaoCentroMS,
      nomeImagem: Constantes.gestoCentroMS);

  List<Estado> estadosCentro = [];
  List<Gestos> gestosCentro = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    estadosCentro.addAll([estadoGO, estadoMS, estadoMG]);
    gestosCentro.addAll([gestoGO, gestoMG, gestoMS]);
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  Widget itemSoltar(Gestos gesto) => Draggable(
        onDragCompleted: () async {
          // variavel vai receber o retorno do metodo para poder
          // verificar se o usuario acertou o gesto no estado correto
          String retorno = await MetodosAuxiliares.recuperarAcerto();
          if (retorno == Constantes.msgAcertoGesto) {
            // caso tenha acertado ele ira remover da
            // lista de gestos o gesto que foi acertado
            setState(() {
              gestosCentro.removeWhere(
                (element) {
                  return element.nomeGesto == gesto.nomeGesto;
                },
              );
            });
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
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(Textos.tituloTelaRegiaoCentro),
        backgroundColor: Colors.white,
        leading: IconButton(
            color: Colors.black,
            //setando tamanho do icone
            iconSize: 30,
            enableFeedback: false,
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaInicialRegioes);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        color: Colors.white,
        width: larguraTela,
        height: alturaTela,
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              width: larguraTela,
              // Text(
              //   textAlign: TextAlign.center,
              //   Textos.descricaoAreaGestos,
              // )
            ),
            AreaSoltar(
              estado: estadoGO,
              gesto: gestoGO,
            ),
            AreaSoltar(
              estado: estadoMG,
              gesto: gestoMG,
            ),
            AreaSoltar(
              estado: estadoMS,
              gesto: gestoMS,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
          width: larguraTela,
          height: 160,
          child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    Textos.descricaoAreaGestos,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: larguraTela,
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: gestosCentro.length,
                      itemBuilder: (context, index) {
                        return itemSoltar(
                          gestosCentro.elementAt(index),
                        );
                      },
                    ),
                  ),
                ],
              ))),
    );
  }
}
