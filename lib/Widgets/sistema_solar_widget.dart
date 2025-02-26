import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/constantes_sistema_solar.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Widgets/widget_tela_carregamento.dart';
import 'package:geoli/modelos/gestos.dart';
import 'package:geoli/modelos/planeta.dart';

class SistemaSolarWidget extends StatefulWidget {
  const SistemaSolarWidget({super.key, required this.corPadrao});

  final Color corPadrao;

  @override
  State<SistemaSolarWidget> createState() => _SistemaSolarWidgetState();
}

class _SistemaSolarWidgetState extends State<SistemaSolarWidget> {
  bool exibirTelaCarregamento = true;
  bool exibirPlanetaGestoDetalhado = false;
  List<Gestos> gestoPlanetasSistemaSolar = [];
  List<Planeta> planetas = [];
  int quantPlanetaDesbloqueados = 0;
  int quantPlanetaFaltaDesbloquear = 0;
  int indexPlaneta = 0;

  @override
  void initState() {
    super.initState();
    planetas = ConstantesSistemaSolar.adicinarPlanetas();
    gestoPlanetasSistemaSolar.addAll([
      Gestos(
          nomeGesto: Textos.nomePlanetaMercurio,
          nomeImagem: CaminhosImagens.gestoPlanetaMercurioImagem),
      Gestos(
          nomeGesto: Textos.nomePlanetaVenus,
          nomeImagem: CaminhosImagens.gestoPlanetaVenusImagem),
      Gestos(
          nomeGesto: Textos.nomePlanetaTerra,
          nomeImagem: CaminhosImagens.gestoPlanetaTerraImagem),
      Gestos(
          nomeGesto: Textos.nomePlanetaMarte,
          nomeImagem: CaminhosImagens.gestoPlanetaMarteImagem),
      Gestos(
          nomeGesto: Textos.nomePlanetaJupiter,
          nomeImagem: CaminhosImagens.gestoPlanetaJupiterImagem),
      Gestos(
          nomeGesto: Textos.nomePlanetaSaturno,
          nomeImagem: CaminhosImagens.gestoPlanetaSaturnoImagem),
      Gestos(
          nomeGesto: Textos.nomePlanetaUrano,
          nomeImagem: CaminhosImagens.gestoPlanetaUranoImagem),
      Gestos(
          nomeGesto: Textos.nomePlanetaNetuno,
          nomeImagem: CaminhosImagens.gestoPlanetaNetunoImagem),
    ]);
    recuperarPlanetasDesbloqueados();
  }

  // metodo para consultar o banco de dados
  recuperarPlanetasDesbloqueados() async {
    var db = FirebaseFirestore.instance;
    db
        .collection(
            Constantes.fireBaseColecaoSistemaSolar) // passando a colecao
        .doc(Constantes
            .fireBaseDocumentoPlanetasDesbloqueados) // passando documento
        .get()
        .then(
      (querySnapshot) async {
        querySnapshot.data()!.forEach(
          (key, value) {
            setState(() {
              // percorendo a lista
              for (var element in planetas) {
                //verificando se o nome do elemento e igual ao nome do item na lista
                if (element.nomePlaneta == key) {
                  // caso for o campo do elemento vai receber o valor que esta no banco
                  element.desbloqueado = value;
                  if (element.desbloqueado) {
                    quantPlanetaDesbloqueados = quantPlanetaDesbloqueados + 1;
                  } else {
                    quantPlanetaFaltaDesbloquear =
                        quantPlanetaFaltaDesbloquear + 1;
                  }
                }
              }
              exibirTelaCarregamento = false;
            });
          },
        );
      },
    );
  }

  Widget planetaLiberados(Planeta planeta, Gestos gesto, int index) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Visibility(
            visible: planeta.desbloqueado,
            child: Container(
                margin: EdgeInsets.only(bottom: 10),
                width: 300,
                height: 100,
                child: FloatingActionButton(
                    enableFeedback: !exibirPlanetaGestoDetalhado,
                    backgroundColor: Colors.white,
                    shape: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: widget.corPadrao),
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      setState(() {
                        indexPlaneta = index;
                        exibirPlanetaGestoDetalhado = true;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        imagemPlanetaGesto(
                            planeta.nomePlaneta, planeta.caminhoImagem, 60),
                        imagemPlanetaGesto(
                            gesto.nomeGesto, gesto.nomeImagem, 60)
                      ],
                    ))),
          ),
        ],
      );

  Widget imagemPlanetaGesto(
          String nome, String caminhoImagem, double tamanhoImagem) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            height: tamanhoImagem,
            width: tamanhoImagem,
            image: AssetImage('$caminhoImagem.png'),
          ),
          Text(
            nome,
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    return SizedBox(
        width: larguraTela,
        height: alturaTela,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (exibirTelaCarregamento) {
              return WidgetTelaCarregamento(corPadrao: widget.corPadrao);
            } else {
              return Stack(
                children: [
                  Column(
                    children: [
                      Column(
                        children: [
                          Text(
                            Textos.telaPlanetasDesbloqueadosTitulo,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(Textos.telaPlanetasDesbloqueadosDescricao),
                        ],
                      ),
                      SizedBox(
                        width: larguraTela,
                        height: 300,
                        child: ListView.builder(
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            return planetaLiberados(
                                planetas.elementAt(index),
                                gestoPlanetasSistemaSolar.elementAt(index),
                                index);
                          },
                        ),
                      ),
                      SizedBox(
                          width: larguraTela,
                          height: 50,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    Textos
                                        .telaPlanetasPlanetasDesbloqueadosQuanti,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(quantPlanetaDesbloqueados.toString())
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    Textos
                                        .telaPlanetasPlanetasDesbloqueadosFalta,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(quantPlanetaFaltaDesbloquear.toString())
                                ],
                              )
                            ],
                          ))
                    ],
                  ),
                  Visibility(
                      visible: exibirPlanetaGestoDetalhado,
                      child: Positioned(
                          top: 60,
                          child: SizedBox(
                              width: Platform.isIOS || Platform.isAndroid
                                  ? larguraTela * 0.9
                                  : larguraTela * 0.4,
                              height: 300,
                              child: Card(
                                color: Colors.white,
                                shape: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: widget.corPadrao),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        imagemPlanetaGesto(
                                            planetas
                                                .elementAt(indexPlaneta)
                                                .nomePlaneta,
                                            planetas
                                                .elementAt(indexPlaneta)
                                                .caminhoImagem,
                                            120),
                                        imagemPlanetaGesto(
                                            gestoPlanetasSistemaSolar
                                                .elementAt(indexPlaneta)
                                                .nomeGesto,
                                            gestoPlanetasSistemaSolar
                                                .elementAt(indexPlaneta)
                                                .nomeImagem,
                                            120)
                                      ],
                                    ),
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: FloatingActionButton(
                                        backgroundColor: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            exibirPlanetaGestoDetalhado = false;
                                          });
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: PaletaCores.corVermelha,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ))))
                ],
              );
            }
          },
        ));
  }
}
