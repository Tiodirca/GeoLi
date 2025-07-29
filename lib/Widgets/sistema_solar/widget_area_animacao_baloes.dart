import 'package:flutter/material.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Uteis/variaveis_constantes/constantes_sistema_solar.dart';
import 'package:geoli/Widgets/sistema_solar/balao_widget.dart';
import 'package:geoli/Widgets/sistema_solar/tela_fim_jogo_widget.dart';
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

  double distacia01 = 0.0;

  Widget baloes(double tamanhoTela, double distacia,
          AnimationController controle, int indexPlaneta, String nome) =>
      PositionedTransition(
          rect: RelativeRectTween(
                  begin: RelativeRect.fromSize(
                      // passando a Distancia um do outro
                      // o tamanho da tela onde a animacao ira ocorrer
                      Rect.fromLTWH(distacia, tamanhoTela, 80, tamanhoTela),
                      widget.biggest),
                  end: RelativeRect.fromSize(
                      Rect.fromLTWH(distacia, 0, 80, tamanhoTela),
                      widget.biggest))
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
              Text(nome),
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
        if (widget.statusAnimacao !=
            ConstantesSistemaSolar.statusAnimacaoPausada) {
          iniciarBalao(_controller7, 5, _controller8, 1);
          iniciarBalao(_controller9, 5, _controller10, 1);
          iniciarBalao(_controller11, 5, _controller12, 1);
        }
      }
    });
    // definindo que a animacao ira comecar apos o tempo passado no delay
    Future.delayed(Duration(milliseconds: 4300), () {
      if (widget.quantidadeVidas != 0) {
        if (widget.statusAnimacao !=
            ConstantesSistemaSolar.statusAnimacaoPausada) {
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
        if (widget.statusAnimacao !=
            ConstantesSistemaSolar.statusAnimacaoPausada) {
          segundoBalaoControle.repeat(
              count: 60, period: Duration(seconds: duracaoAnimacao));
        }
      }
    });
  }

  chamarIniciarAnimacaoBalao() {
    // verificando se a animacao
    if (widget.statusAnimacao == ConstantesSistemaSolar.statusAnimacaoRetomar &&
        !(_controller.isAnimating || _controller14.isAnimating)) {
      iniciarAnimacoesBaloesPausado();
    } else if (!(_controller.isAnimating || _controller14.isAnimating)) {
      iniciarAnimacoesBaloes();
    }
  }

  verificarPeriodicamenteInformacoes() {
    //caso os parametros sejam igual a zero parar a animacao
    if (widget.quantidadeVidas == 0 || widget.tempo == 0) {
      setState(() {
        pararAnimacaoBaloes();
        exibirTelaFimJogo = true;
        desativarToqueBalao = true;
      });
    } else if (widget.statusAnimacao ==
        ConstantesSistemaSolar.statusAnimacaoPausada) {
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
    _controller.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    _controller6.dispose();
    _controller7.dispose();
    _controller8.dispose();
    _controller9.dispose();
    _controller10.dispose();
    _controller11.dispose();
    _controller12.dispose();
    _controller13.dispose();
    _controller14.dispose();
    _controllerFade.dispose();
    super.dispose();
  }

  pararAnimacaoBaloes() {
    _controller.stop(canceled: true);
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



  Widget exibicaoBaloesMobile(double alturaTela) => Stack(
        children: [
          baloes(alturaTela, 0, _controller, 0, "1"),
          baloes(alturaTela, 50, _controller2, 1, "2"),
          baloes(alturaTela, 100, _controller3, 2, "3"),
          baloes(alturaTela, 150, _controller4, 3, "4"),
          baloes(alturaTela, 200, _controller5, 4, "5"),
          baloes(alturaTela, 250, _controller6, 5, "6"),
          baloes(alturaTela, 0, _controller7, 6, "7"),
          baloes(alturaTela, 50, _controller8, 7, "8"),
          baloes(alturaTela, 100, _controller9, 0, "9"),
          baloes(alturaTela, 150, _controller10, 1, "10"),
          baloes(alturaTela, 200, _controller11, 2, "11"),
          baloes(alturaTela, 250, _controller12, 3, "12"),
          baloes(alturaTela, 50, _controller13, 4, "13"),
          baloes(alturaTela, 150, _controller14, 5, "14"),
          baloes(alturaTela, 300, _controller, 6, "1s"),
          baloes(alturaTela, 300, _controller7, 7, "7s"),
          baloes(alturaTela, 250, _controller13, 0, "13s"),
        ],
      );

  Widget exibicaoFold(double alturaTela) => Stack(
    children: [
      //primeira coluna
      baloes(alturaTela, 0, _controller, 0, "1f"),
      baloes(alturaTela, 100, _controller2, 1, "2f"),
      baloes(alturaTela, 200, _controller3, 2, "3f"),
      baloes(alturaTela, 300, _controller4, 3, "4f"),
      baloes(alturaTela, 400, _controller5, 4, "5f"),
      baloes(alturaTela, 500, _controller6, 5, "6f"),
      //segunda coluna
      baloes(alturaTela, 0, _controller7, 6, "7"),
      baloes(alturaTela, 100, _controller8, 7, "8"),
      baloes(alturaTela, 200, _controller9, 0, "9"),
      baloes(alturaTela, 300, _controller10, 1, "10"),
      baloes(alturaTela, 400, _controller11, 2, "11"),
      baloes(alturaTela, 500, _controller12, 3, "12"),
      baloes(alturaTela, 100, _controller13, 4, "13"),
      baloes(alturaTela, 300, _controller14, 5, "14"),
      baloes(alturaTela, 500, _controller13, 6, "13s"),
    ],
  );

  Widget exibicaoTablet(double alturaTela) => Stack(
        children: [
          //primeira coluna
          baloes(alturaTela, 0, _controller, 0, "1"),
          baloes(alturaTela, 100, _controller2, 1, "2"),
          baloes(alturaTela, 200, _controller3, 2, "3"),
          baloes(alturaTela, 300, _controller4, 3, "4"),
          baloes(alturaTela, 400, _controller5, 4, "5"),
          baloes(alturaTela, 500, _controller6, 5, "6"),
          //segunda coluna
          baloes(alturaTela, 0, _controller7, 6, "7"),
          baloes(alturaTela, 100, _controller8, 7, "8"),
          baloes(alturaTela, 200, _controller9, 0, "9"),
          baloes(alturaTela, 300, _controller10, 1, "10"),
          baloes(alturaTela, 400, _controller11, 2, "11"),
          baloes(alturaTela, 500, _controller12, 3, "12"),
          baloes(alturaTela, 100, _controller13, 4, "13"),
          baloes(alturaTela, 300, _controller14, 5, "14"),
          baloes(alturaTela, 500, _controller13, 6, "13s"),

          baloes(alturaTela, 600, _controller, 7, "1s"),
          baloes(alturaTela, 700, _controller2, 0, "2s"),
          baloes(alturaTela, 600, _controller7, 1, "7s"),
          baloes(alturaTela, 700, _controller8, 2, "8s"),
        ],
      );

  Widget exibicaoExibicaoDesktop(double alturaTela) => Stack(
    children: [
      //primeira coluna
      baloes(alturaTela, 0, _controller, 0, "1"),
      baloes(alturaTela, 150, _controller2, 1, "2"),
      baloes(alturaTela, 300, _controller3, 2, "3"),
      baloes(alturaTela, 450, _controller4, 3, "4"),
      baloes(alturaTela, 600, _controller5, 4, "5"),
      baloes(alturaTela, 750, _controller6, 5, "6"),
      //segunda coluna
      baloes(alturaTela, 0, _controller7, 6, "7"),
      baloes(alturaTela, 150, _controller8, 7, "8"),
      baloes(alturaTela, 300, _controller9, 0, "9"),
      baloes(alturaTela, 450, _controller10, 1, "10"),
      baloes(alturaTela, 600, _controller11, 2, "11"),
      baloes(alturaTela, 750, _controller12, 3, "12"),
      baloes(alturaTela, 150, _controller13, 4, "13"),
      baloes(alturaTela, 450, _controller14, 5, "14"),

      //primeira coluna
      baloes(alturaTela, 900, _controller, 0, "1"),
      baloes(alturaTela, 1050, _controller2, 1, "2"),
      baloes(alturaTela, 1300, _controller3, 2, "3"),
      baloes(alturaTela, 1450, _controller4, 3, "4"),
      baloes(alturaTela, 1600, _controller5, 4, "5"),
      baloes(alturaTela, 1750, _controller6, 5, "6"),
      //segunda coluna
      baloes(alturaTela, 900, _controller7, 6, "7"),
      baloes(alturaTela, 1050, _controller8, 7, "8"),
      baloes(alturaTela, 1300, _controller9, 0, "9"),
      baloes(alturaTela, 1450, _controller10, 1, "10"),
      baloes(alturaTela, 1600, _controller11, 2, "11"),
      baloes(alturaTela, 1750, _controller12, 3, "12"),
      baloes(alturaTela, 1150, _controller13, 4, "13"),
      baloes(alturaTela, 1450, _controller14, 5, "14"),
    ],
  );

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    //metodo sera chamado de forma periodica
    verificarPeriodicamenteInformacoes();
    return Container(
      color: Colors.white,
      width: larguraTela,
      height: alturaTela,
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (larguraTela <= 400) {
                return exibicaoBaloesMobile(alturaTela);
              } else if (larguraTela > 400 && larguraTela <= 600) {
                return exibicaoFold(alturaTela);
              } else if (larguraTela > 600 && larguraTela <= 800) {
                return exibicaoTablet(alturaTela);
              } else {
                return exibicaoExibicaoDesktop(alturaTela);
              }
            },
          ),
          Positioned(
              child: Center(
            child: Visibility(
                visible: exibirTelaFimJogo, child: TelaFimJogoWidget()),
          )),
          Positioned(
            child: Center(
                child: Visibility(
              visible: widget.statusAnimacao ==
                      ConstantesSistemaSolar.statusAnimacaoPausada
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
