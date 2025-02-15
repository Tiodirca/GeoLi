import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Widgets/sistema_solar/balao_widget.dart';
import 'package:geoli/Widgets/sistema_solar/tela_fim_jogo.dart';
import 'package:geoli/modelos/planeta.dart';

class AreaAnimacaoBaloes extends StatefulWidget {
  AreaAnimacaoBaloes(
      {super.key,
      required this.planetas,
      required this.biggest,
      required this.statusAnimacao,
      required this.tempo,
      required this.quantidadeVidas});

  final List<Planeta> planetas;
  final Size biggest;
  int quantidadeVidas;
  int tempo;
  String statusAnimacao;

  @override
  State<AreaAnimacaoBaloes> createState() => _AreaAnimacaoBaloesState();
}

class _AreaAnimacaoBaloesState extends State<AreaAnimacaoBaloes>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);
  late final AnimationController _controller2 =
      AnimationController(vsync: this);
  late final AnimationController _controller3 =
      AnimationController(vsync: this);
  late final AnimationController _controller4 =
      AnimationController(vsync: this);
  late final AnimationController _controller5 =
      AnimationController(vsync: this);
  late final AnimationController _controller6 =
      AnimationController(vsync: this);
  late final AnimationController _controller7 =
      AnimationController(vsync: this);
  late final AnimationController _controller8 =
      AnimationController(vsync: this);
  late final AnimationController _controller9 =
      AnimationController(vsync: this);
  late final AnimationController _controller10 =
      AnimationController(vsync: this);
  late final AnimationController _controller11 =
      AnimationController(vsync: this);
  late final AnimationController _controller12 =
      AnimationController(vsync: this);
  late final AnimationController _controller13 =
      AnimationController(vsync: this);
  late final AnimationController _controller14 =
      AnimationController(vsync: this);

  bool exibirTelaFimJogo = false;

  Widget baloes(double tamanhoTela, Size biggest, double distacia,
          AnimationController controle, int indexPlaneta) =>
      PositionedTransition(
        rect: RelativeRectTween(
                begin: RelativeRect.fromSize(
                    // passando a Distancia um do outro
                    // o tamanho da tela onde a animacao ira ocorrer
                    Rect.fromLTWH(distacia, tamanhoTela, 80, tamanhoTela),
                    biggest),
                end: RelativeRect.fromSize(
                    Rect.fromLTWH(distacia, 0, 80, tamanhoTela), biggest))
            .animate(CurvedAnimation(
          parent: controle,
          curve: Curves.linear,
        )),
        child: BalaoWidget(
          planeta: widget.planetas.elementAt(indexPlaneta),
        ),
      );

  // metodo para iniciar a animacao dos baloes
  iniciarAnimacoesBaloes() {
    iniciarBalao(_controller, 5, _controller2, 1);
    iniciarBalao(_controller3, 5, _controller4, 1);
    iniciarBalao(_controller5, 5, _controller6, 1);
    // definindo que a animacao ira comecar apos o tempo passado no delay
    Future.delayed(Duration(seconds: 2), () {
      iniciarBalao(_controller7, 5, _controller8, 1);
      iniciarBalao(_controller9, 5, _controller10, 1);
      iniciarBalao(_controller11, 5, _controller12, 1);
    });
    // definindo que a animacao ira comecar apos o tempo passado no delay
    Future.delayed(Duration(milliseconds: 4300), () {
      iniciarBalao(_controller13, 5, _controller14, 0);
    });
  }

  // metodo para iniciar a animacao dos baloes
  iniciarBalao(AnimationController primeiroBalaoControle, int duracaoAnimacao,
      AnimationController segundoBalaoControle, int delay) {
    // iniciando a animacao do primeiro controle
    primeiroBalaoControle.repeat(
        count: 60, period: Duration(seconds: duracaoAnimacao));
    // definindo que havera um delay para comecar a animacao do segundo controle
    Future.delayed(Duration(seconds: delay), () {
      segundoBalaoControle.repeat(
          count: 60, period: Duration(seconds: duracaoAnimacao));
    });
  }

  chamarIniciarAnimacaoBalao() {
    if (widget.statusAnimacao == Constantes.statusAnimacaoIniciar) {
      if (_controller.isAnimating || _controller14.isAnimating) {
        print("JA ANIMADO");
      } else {
        print("INICIOU ANIMACAO");
        iniciarAnimacoesBaloes();
      }
    }
  }

  verificarInformacoes() {
    if (widget.quantidadeVidas == 0 || widget.tempo == 0) {
      setState(() {
        pararAnimacaoBaloes();
        exibirTelaFimJogo = true;
      });
    } else if (widget.statusAnimacao == Constantes.statusAnimacaoPausada) {
      setState(() {
        pararAnimacaoBaloes();
      });
    } else {
      chamarIniciarAnimacaoBalao();
    }
  }

  pararAnimacaoBaloes() {
    _controller.stop(canceled: false);
    _controller2.stop(canceled: false);
    _controller3.stop(canceled: false);
    _controller4.stop(canceled: false);
    _controller5.stop(canceled: false);
    _controller6.stop(canceled: false);
    _controller7.stop(canceled: false);
    _controller8.stop(canceled: false);
    _controller9.stop(canceled: false);
    _controller10.stop(canceled: false);
    _controller11.stop(canceled: false);
    _controller12.stop(canceled: false);
    _controller13.stop(canceled: false);
    _controller14.stop(canceled: false);
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    verificarInformacoes();
    return Container(
      color: Colors.white,
      width: larguraTela,
      height: alturaTela,
      child: Stack(
        children: [
          baloes(
            alturaTela,
            widget.biggest,
            0,
            _controller,
            0,
          ),
          baloes(alturaTela, widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 50 : 200, _controller2, 1),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 100 : 400,
              _controller3,
              2),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 150 : 600,
              _controller4,
              3),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 200 : 800,
              _controller5,
              4),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 250 : 1000,
              _controller6,
              5),
          baloes(alturaTela, widget.biggest, 0, _controller7, 6),
          baloes(alturaTela, widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 50 : 200, _controller8, 7),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 100 : 400,
              _controller9,
              0),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 150 : 600,
              _controller10,
              1),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 200 : 800,
              _controller11,
              2),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 250 : 1000,
              _controller12,
              3),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 50 : 250,
              _controller13,
              4),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 150 : 550,
              _controller14,
              5),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 300 : 1200,
              _controller,
              4),
          LayoutBuilder(
            builder: (context, constraints) {
              if (Platform.isAndroid || Platform.isIOS) {
                return Container();
              } else {
                return Stack(
                  children: [
                    baloes(alturaTela, widget.biggest, 1400, _controller4, 7),
                    baloes(alturaTela, widget.biggest, 1300, _controller10, 4),
                    baloes(alturaTela, widget.biggest, 1050, _controller13, 7),
                    baloes(alturaTela, widget.biggest, 1400, _controller14, 7),
                  ],
                );
              }
            },
          ),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 300 : 1200,
              _controller7,
              7),
          Positioned(
              child: Center(
            child: Visibility(visible: exibirTelaFimJogo, child: TelaFimJogo()),
          )),
        ],
      ),
    );
  }
}
