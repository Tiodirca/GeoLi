import 'package:flutter/material.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Widgets/gestos_widget.dart';

class AreaSoltar extends StatefulWidget {
   const AreaSoltar({super.key, required this.estado, required this.gesto});

  final Estado estado;
  final Gestos gesto;

  @override
  State<AreaSoltar> createState() => _AreaSoltarState();
}

class _AreaSoltarState extends State<AreaSoltar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Estado estado = widget.estado;
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
                });
                // chamando metodo para passar confirmacao do acerto
                MetodosAuxiliares.confirmarAcerto(Constantes.msgAcertoGesto);
                MetodosAuxiliares.exibirMensagens(
                    Textos.msgAcertou, Constantes.msgAcertoGesto, context);
              } else {
                MetodosAuxiliares.exibirMensagens(Textos.msgErrou,
                    Constantes.msgErroAcertoGesto, context);
                // chamando metodo para passar confirmacao do erro
                MetodosAuxiliares.confirmarAcerto(
                    Constantes.msgErroAcertoGesto);
              }
            },
          ),
        ));
  }
}
