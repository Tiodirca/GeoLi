import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/modelos/planeta.dart';

class BalaoWidget extends StatefulWidget {
  const BalaoWidget({super.key});

  @override
  State<BalaoWidget> createState() => _BalaoWidgetState();
}

class _BalaoWidgetState extends State<BalaoWidget> {
  List<Color> listaCorBalao = [];
  Random random = Random();
  late Color corbalao;
  List<Planeta> planetas = [];
  late Planeta planetaSorteado;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    planetas.addAll([
      Planeta(
          nomePlaneta: Textos.nomePlanetaMercurio,
          caminhoImagem: CaminhosImagens.planetaMercurioImagem),
      Planeta(
          nomePlaneta: Textos.nomePlanetaVenus,
          caminhoImagem: CaminhosImagens.planetaVenusImagem),
      Planeta(
          nomePlaneta: Textos.nomePlanetaTerra,
          caminhoImagem: CaminhosImagens.planetaTerraImagem),
      Planeta(
          nomePlaneta: Textos.nomePlanetaMarte,
          caminhoImagem: CaminhosImagens.planetaMarteImagem),
      Planeta(
          nomePlaneta: Textos.nomePlanetaJupiter,
          caminhoImagem: CaminhosImagens.planetaJupiterImagem),
      Planeta(
          nomePlaneta: Textos.nomePlanetaSaturno,
          caminhoImagem: CaminhosImagens.planetaSaturnoImagem),
      Planeta(
          nomePlaneta: Textos.nomePlanetaUrano,
          caminhoImagem: CaminhosImagens.planetaUranoImagem),
      Planeta(
          nomePlaneta: Textos.nomePlanetaNetuno,
          caminhoImagem: CaminhosImagens.planetaNetunoImagem),
    ]);
    listaCorBalao.addAll([
      Colors.redAccent,
      Colors.pinkAccent,
      Colors.blue,
      Colors.greenAccent,
      Colors.yellowAccent,
      Colors.cyan,
      Colors.purpleAccent,
      Colors.orange,
      Colors.deepOrangeAccent,
      Colors.deepPurpleAccent,
      Colors.lightGreen,
      Colors.grey,
    ]);
    corbalao = listaCorBalao.elementAt(sortearNumero(listaCorBalao.length));
    sortearPlanetas();
  }

  sortearPlanetas() {
    planetaSorteado = planetas.elementAt(sortearNumero(planetas.length));
  }

  sortearNumero(int tamanhoLista) {
    int randomNumber = random.nextInt(tamanhoLista);
    return randomNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: 80,
            height: 170,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Image(
                          color: corbalao,
                          height: 80,
                          width: 80,
                          image: AssetImage(
                              '${CaminhosImagens.balaoCabelaImagem}.png'),
                        ),
                        Positioned(
                            top: 20,
                            left: 15,
                            child: Center(
                                child: Container(
                              width: 50,
                              height: 50,
                              child: FloatingActionButton(
                                elevation: 0,
                                backgroundColor: corbalao,
                                onPressed: () async {
                                  String gesto = await MetodosAuxiliares
                                      .recuperarGestoSorteado();
                                  print("R${gesto}");
                                  // if (gesto.nomeGesto
                                  //     .contains(planetaSorteado.nomePlaneta)) {
                                  //   sortearPlanetas();
                                  // }
                                },
                                child: Image(
                                  height: 50,
                                  width: 50,
                                  image: AssetImage(
                                      '${planetaSorteado.caminhoImagem}.png'),
                                ),
                              ),
                            ))),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Image(
                        height: 80,
                        width: 60,
                        image: AssetImage(
                            '${CaminhosImagens.balaoCaldaImagem}.png'),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ],
    );
  }
}
