import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/variaveis_constantes/constantes.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/passar_pegar_dados.dart.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Widgets/gestos_widget.dart';

class WidgetAreaSoltarEstados extends StatefulWidget {
  const WidgetAreaSoltarEstados(
      {super.key, required this.estado, required this.gesto});

  final Estado estado;
  final Gestos gesto;

  @override
  State<WidgetAreaSoltarEstados> createState() =>
      _WidgetAreaSoltarEstadosState();
}

class _WidgetAreaSoltarEstadosState extends State<WidgetAreaSoltarEstados>
    with SingleTickerProviderStateMixin {
  bool exibirIndicadorTutorial = false;
  late Estado estado = widget.estado;
  late String status;
  late final AnimationController _controllerFade =
      AnimationController(vsync: this);
  late final Animation<double> _fadeAnimation =
      Tween<double>(begin: 1, end: 0.0).animate(_controllerFade);

  @override
  void initState() {
    super.initState();
    validarTutorial();
  }

  //metodo para verificar se o tutorial esta ativo
  validarTutorial() async {
    status = await PassarPegarDados.recuperarStatusTutorial();
    if (status == Constantes.statusTutorialAtivo) {
      setState(() {
        exibirIndicadorTutorial = true;
      });
      _controllerFade.repeat(count: 1000, period: Duration(milliseconds: 800));
    }
  }

  cancelarAcertoTutorial() async {
    if (status == Constantes.statusTutorialAtivo) {
      estado.acerto = false;
    }
  }

  @override
  void dispose() {
    _controllerFade.stop(canceled: true);
    cancelarAcertoTutorial();
    super.dispose();
  }

  // conforme o tamanho da tela exibir determinda quantidade de colunas
  static tamanhoImagemEstados(double larguraTela) {
    double tamanho = 170.0;
    //verificando qual o tamanho da tela
    if (larguraTela <= 600) {
      tamanho = 110.0;
    } else if (larguraTela > 600 && larguraTela <= 800) {
      tamanho = 120.0;
    } else if (larguraTela > 800 && larguraTela <= 1100) {
      tamanho = 130.0;
    } else if (larguraTela > 1100 && larguraTela <= 1300) {
      tamanho = 140.0;
    } else if (larguraTela > 1300) {
      tamanho = 150.0;
    }
    return tamanho;
  }

  // conforme o tamanho da tela exibir determinda quantidade de colunas
  static tamanhoImagemEstadosWindows(double larguraTela) {
    double tamanho = 0.0;
    //verificando qual o tamanho da tela
    if (larguraTela <= 600) {
      tamanho = 90.0;
    } else if (larguraTela > 600 && larguraTela <= 800) {
      tamanho = 110.0;
    } else if (larguraTela > 800 && larguraTela <= 1100) {
      tamanho = 120.0;
    } else if (larguraTela > 1100 && larguraTela <= 1300) {
      tamanho = 130.0;
    } else if (larguraTela > 1300) {
      tamanho = 140.0;
    }
    return tamanho;
  }

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    return SizedBox(
        child: Card(
      elevation: 7,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: PaletaCores.corOuro, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: DragTarget(
        builder: (context, candidateData, rejectedData) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Image(
                height: kIsWeb
                    ? tamanhoImagemEstados(larguraTela)
                    : tamanhoImagemEstadosWindows(larguraTela),
                width: kIsWeb
                    ? tamanhoImagemEstados(larguraTela)
                    : tamanhoImagemEstadosWindows(larguraTela),
                image: AssetImage('${estado.caminhoImagem}.png'),
              ),
              Positioned(
                right: 10,
                bottom: 0,
                child: Visibility(
                  visible: estado.nome == Textos.nomeRegiaoCentroMS
                      ? exibirIndicadorTutorial
                      : false,
                  child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        transform: Matrix4.rotationZ(12 // here
                            ),
                        child: Image(
                          width: 50,
                          height: 50,
                          image:
                              AssetImage('${CaminhosImagens.iconeClick}.png'),
                        ),
                      )),
                ),
              ),
              Visibility(
                  visible: estado.acerto,
                  child: Positioned(
                    child: Center(
                      child: GestosWidget(
                        nomeGestoImagem: widget.gesto.nomeImagem,
                        nomeGesto: widget.gesto.nomeGesto,
                        exibirAcerto: true,
                      ),
                    ),
                  ))
            ],
          );
        },
        onAcceptWithDetails: (data) async {
          // verificando se o data passado e igual ao nome do estado que esta aqui no widget
          if (data.data == estado.nome) {
            setState(() {
              estado.acerto = true;
              exibirIndicadorTutorial = false;
            });
            if (mounted) {
              MetodosAuxiliares.exibirMensagensDuranteJogo(
                  Textos.msgAcertou, Constantes.msgAcerto, context);
              // chamando metodo para passar confirmacao do acerto
              PassarPegarDados.confirmarAcerto(Constantes.msgAcerto);
            }
          } else {
            if (mounted) {
              MetodosAuxiliares.exibirMensagensDuranteJogo(
                  Textos.msgErrou, Constantes.msgErro, context);
              // chamando metodo para passar confirmacao do erro
              PassarPegarDados.confirmarAcerto(Constantes.msgErro);
            }
          }
        },
      ),
    ));
  }
}
