import 'package:flutter/material.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
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
    status = await MetodosAuxiliares.recuperarStatusTutorial();
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

  @override
  Widget build(BuildContext context) {
    //teste();
    return SizedBox(
        width: 170,
        height: 170,
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
                    height: 140,
                    width: 140,
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
                              image: AssetImage(
                                  '${CaminhosImagens.iconeClick}.png'),
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
                // chamando metodo para passar confirmacao do acerto
                MetodosAuxiliares.confirmarAcerto(Constantes.msgAcerto);
                MetodosAuxiliares.exibirMensagens(
                    Textos.msgAcertou,
                    Constantes.msgAcerto,
                    Constantes.duracaoExibicaoToastJogos,
                    Constantes.larguraToastNotificacaoJogos,
                    context);
              } else {
                MetodosAuxiliares.exibirMensagens(
                    Textos.msgErrou,
                    Constantes.msgErro,
                    Constantes.duracaoExibicaoToastJogos,
                    Constantes.larguraToastNotificacaoJogos,
                    context);
                // chamando metodo para passar confirmacao do erro
                MetodosAuxiliares.confirmarAcerto(Constantes.msgErro);
              }
            },
          ),
        ));
  }
}
