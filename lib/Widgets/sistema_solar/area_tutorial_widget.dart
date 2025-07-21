import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Widgets/gestos_widget.dart';
import 'package:geoli/Widgets/msg_tutoriais_widget.dart';
import 'package:geoli/modelos/planeta.dart';

import 'balao_widget.dart';

class AreaTutorialWidget extends StatefulWidget {
  const AreaTutorialWidget({super.key, required this.corPadrao});

  final Color corPadrao;

  @override
  State<AreaTutorialWidget> createState() => _AreaTutorialWidgetState();
}

class _AreaTutorialWidgetState extends State<AreaTutorialWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controllerFade =
      AnimationController(vsync: this);
  late final Animation<double> _fadeAnimation =
      Tween<double>(begin: 1, end: 0.0).animate(_controllerFade);

  @override
  void initState() {
    super.initState();
    _controllerFade.repeat(count: 1000, period: Duration(milliseconds: 800));
  }

  @override
  void dispose() {
    _controllerFade.dispose();
    super.dispose();
  }

  Widget areaSorteioPlaneta(double larguraTela) => SizedBox(
        width: larguraTela,
        height: 140,
        child: Card(
          color: Colors.white,
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
              side: BorderSide(color: PaletaCores.corAzulMagenta, width: 1),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(25), topLeft: Radius.circular(25))),
          child: Column(
            children: [
              Text(
                Textos.telaSistemaSolarDescricaoPlanetaSorteado,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                  height: kIsWeb
                      ? 120
                      : Platform.isAndroid || Platform.isIOS
                          ? 100
                          : 120,
                  child: GestosWidget(
                      nomeGestoImagem: CaminhosImagens.gestoPlanetaTerraImagem,
                      nomeGesto: Textos.nomePlanetaTerra,
                      exibirAcerto: false))
            ],
          ),
        ),
      );

  Widget indicadorMsg(String msg, bool inverter, double larguraCaixaMensagem) =>
      Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: inverter == true
            ? WrapCrossAlignment.end
            : WrapCrossAlignment.start,
        children: [
          MsgTutoriaisWidget(
            corBorda: widget.corPadrao,
            mensagem: msg,
            larguraCaixaMensagem: larguraCaixaMensagem,
          ),
          Transform.flip(
              flipX: inverter,
              flipY: inverter,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Image(
                  width: 30,
                  height: 50,
                  image: AssetImage('${CaminhosImagens.iconeClick}.png'),
                ),
              )),
        ],
      );

  tamanhoAreaPlanetaSorteado(double larguraTela) {
    double tamanho = 200.0;
    //verificando qual o tamanho da tela
    if (larguraTela <= 400) {
      tamanho = 250.0;
    } else if (larguraTela > 400 && larguraTela <= 800) {
      tamanho = 250.0;
    } else if (larguraTela > 800 && larguraTela <= 1100) {
      tamanho = 300.0;
    } else if (larguraTela > 1100 && larguraTela <= 1300) {
      tamanho = 350.0;
    } else if (larguraTela > 1300) {
      tamanho = 400.0;
    }
    return tamanho;
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
            color: Colors.white,
            width: larguraTela,
            height: alturaTela,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: kIsWeb
                          ? larguraTela
                          : Platform.isAndroid || Platform.isIOS
                              ? larguraTela * 0.8
                              : larguraTela * 0.2,
                      height: 100,
                      child: indicadorMsg(
                        Textos.tutorialSistemaSolarCabecalho,
                        false,
                        220,
                      )),
                  SizedBox(
                    width: 150,
                    child: Column(
                      children: [
                        indicadorMsg(
                            Textos.tutorialSistemaSolarClickBalao, true, 150),
                        BalaoWidget(
                            planeta: Planeta(
                                nomePlaneta: Textos.nomePlanetaTerra,
                                caminhoImagem:
                                    CaminhosImagens.planetaTerraImagem),
                            desativarBotao: false),
                      ],
                    ),
                  )
                ],
              ),
            )),
        bottomNavigationBar: Container(
            color: Colors.white,
            width: larguraTela,
            height: 260,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 400,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          indicadorMsg(
                              Textos.tutorialSistemaSolarPlanetaSorteado,
                              true,
                              220),
                        ],
                      ),
                      areaSorteioPlaneta(
                          tamanhoAreaPlanetaSorteado(larguraTela))
                    ],
                  ),
                )
              ],
            )));
  }
}
