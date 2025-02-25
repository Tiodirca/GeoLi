import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Widgets/sistema_solar/balao_widget.dart';
import 'package:geoli/Widgets/sistema_solar/widget_tela_fim_jogo.dart';
import 'package:geoli/modelos/planeta.dart';

//ignore: must_be_immutable
class WidgetAreaAnimacaoBaloes extends StatefulWidget {
  WidgetAreaAnimacaoBaloes(
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
  State<WidgetAreaAnimacaoBaloes> createState() =>
      _WidgetAreaAnimacaoBaloesState();
}

class _WidgetAreaAnimacaoBaloesState extends State<WidgetAreaAnimacaoBaloes>
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
  late final AnimationController _controllerFade =
      AnimationController(vsync: this);
  late final Animation<double> _fadeAnimation =
      Tween<double>(begin: 1, end: 0.0).animate(_controllerFade);

  bool exibirTelaFimJogo = false;
  bool desativarToqueBalao = false;

  Widget baloes(double tamanhoTela, Size biggest, double distacia,
          AnimationController controle, int indexPlaneta, String nome) =>
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
          child: Column(
            children: [
              BalaoWidget(
                desativarBotao: desativarToqueBalao,
                planeta: widget.planetas.elementAt(indexPlaneta),
              ),
              Text(nome)
            ],
          ));

  // metodo para iniciar a animacao dos baloes
  iniciarAnimacoesBaloes() {
    iniciarBalao(_controller, 5, _controller2, 1);
    iniciarBalao(_controller3, 5, _controller4, 1);
    iniciarBalao(_controller5, 5, _controller6, 1);
    // definindo que a animacao ira comecar apos
    // o tempo passado no delay
    Future.delayed(Duration(seconds: 2), () {
      // verificando se a quantidade de vida nao e igual a
      // zero ou se o status nao esta pausado
      if (widget.quantidadeVidas != 0) {
        if (widget.statusAnimacao != Constantes.statusAnimacaoPausada) {
          iniciarBalao(_controller7, 5, _controller8, 1);
          iniciarBalao(_controller9, 5, _controller10, 1);
          iniciarBalao(_controller11, 5, _controller12, 1);
        }
      }
    });
    // definindo que a animacao ira comecar apos o tempo passado no delay
    Future.delayed(Duration(milliseconds: 4300), () {
      if (widget.quantidadeVidas != 0) {
        if (widget.statusAnimacao != Constantes.statusAnimacaoPausada) {
          iniciarBalao(_controller13, 5, _controller14, 0);
        }
      }
    });
  }

  // metodo para reiniciar as animacoes dos baloes apos a pausa
  iniciarAnimacoesBaloesPausado() {
    iniciarBalao(_controller, 5, _controller2, 0);
    iniciarBalao(_controller3, 5, _controller4, 0);
    iniciarBalao(_controller5, 5, _controller6, 0);
    iniciarBalao(_controller7, 5, _controller8, 0);
    iniciarBalao(_controller9, 5, _controller10, 0);
    iniciarBalao(_controller11, 5, _controller12, 0);
    iniciarBalao(_controller13, 5, _controller14, 0);
  }

  // metodo para iniciar a animacao dos baloes
  iniciarBalao(AnimationController primeiroBalaoControle, int duracaoAnimacao,
      AnimationController segundoBalaoControle, int delay) {
    // iniciando a animacao do primeiro controle
    primeiroBalaoControle.repeat(
        count: 60, period: Duration(seconds: duracaoAnimacao));
    // definindo que havera um delay para comecar a animacao do segundo controle
    Future.delayed(Duration(seconds: delay), () {
      if (widget.quantidadeVidas != 0) {
        if (widget.statusAnimacao != Constantes.statusAnimacaoPausada) {
          segundoBalaoControle.repeat(
              count: 60, period: Duration(seconds: duracaoAnimacao));
        }
      }
    });
  }

  chamarIniciarAnimacaoBalao() {
    // verificando se a animacao
    if (widget.statusAnimacao == Constantes.statusAnimacaoRetomar &&
        !(_controller.isAnimating || _controller14.isAnimating)) {
      iniciarAnimacoesBaloesPausado();
    } else if (!(_controller.isAnimating || _controller14.isAnimating)) {
      iniciarAnimacoesBaloes();
    }
  }

  verificarInformacoes() {
    //caso os parametros sejam igual a zero parar a animacao
    if (widget.quantidadeVidas == 0 || widget.tempo == 0) {
      setState(() {
        pararAnimacaoBaloes();
        exibirTelaFimJogo = true;
        desativarToqueBalao = true;
      });
    } else if (widget.statusAnimacao == Constantes.statusAnimacaoPausada) {
      setState(() {
        _controllerFade.repeat(
            count: 1000, period: Duration(milliseconds: 500));
        desativarToqueBalao = true;
        pararAnimacaoBaloes();
      });
    } else {
      setState(() {
        _controllerFade.stop();
        desativarToqueBalao = false;
        chamarIniciarAnimacaoBalao();
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pararAnimacaoBaloes();
    super.dispose();
  }

  pararAnimacaoBaloes() {
    _controller.stop();
    _controller2.stop();
    _controller3.stop();
    _controller4.stop();
    _controller5.stop();
    _controller6.stop();
    _controller7.stop();
    _controller8.stop();
    _controller9.stop();
    _controller10.stop();
    _controller11.stop();
    _controller12.stop();
    _controller13.stop();
    _controller14.stop();
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
          baloes(alturaTela, widget.biggest, 0, _controller, 0, "1"),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 50 : 200,
              _controller2,
              1,
              "2"),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 100 : 400,
              _controller3,
              2,
              "3"),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 150 : 600,
              _controller4,
              3,
              "4"),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 200 : 800,
              _controller5,
              4,
              "5"),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 250 : 1000,
              _controller6,
              5,
              "6"),
          baloes(alturaTela, widget.biggest, 0, _controller7, 6, "7"),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 50 : 200,
              _controller8,
              7,
              "8"),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 100 : 400,
              _controller9,
              0,
              "9"),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 150 : 600,
              _controller10,
              1,
              "10"),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 200 : 800,
              _controller11,
              2,
              "11"),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 250 : 1000,
              _controller12,
              3,
              "12"),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 50 : 250,
              _controller13,
              4,
              "13"),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 150 : 550,
              _controller14,
              5,
              "14"),
          Visibility(
            visible: Platform.isAndroid || Platform.isIOS ? true : false,
            child: baloes(
                alturaTela, widget.biggest, 250, _controller14, 6, "14s"),
          ),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 300 : 1200,
              _controller,
              7,
              "1s"),
          baloes(
              alturaTela,
              widget.biggest,
              Platform.isAndroid || Platform.isIOS ? 300 : 1200,
              _controller7,
              0,
              "7s"),
          LayoutBuilder(
            builder: (context, constraints) {
              if (Platform.isAndroid || Platform.isIOS) {
                return Container();
              } else {
                return Stack(
                  children: [
                    baloes(alturaTela, widget.biggest, 1400, _controller4, 1,
                        "4s"),
                    baloes(alturaTela, widget.biggest, 1300, _controller10, 2,
                        "10s"),
                    baloes(alturaTela, widget.biggest, 1050, _controller13, 3,
                        "13s"),
                    baloes(alturaTela, widget.biggest, 1400, _controller14, 4,
                        "14s"),
                  ],
                );
              }
            },
          ),
          Positioned(
              child: Center(
            child: Visibility(
                visible: exibirTelaFimJogo, child: WidgetTelaFimJogo()),
          )),
          Positioned(
            child: Center(
                child: Visibility(
              visible: widget.statusAnimacao == Constantes.statusAnimacaoPausada
                  ? true
                  : false,
              child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Card(
                      elevation: 0,
                      color: Colors.transparent,
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          Textos.telaSistemaSolarPausa,
                          style: TextStyle(fontSize: 30),
                        ),
                      ))),
            )),
          )
        ],
      ),
    );
  }
}
