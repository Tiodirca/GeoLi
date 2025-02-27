import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Widgets/estados/widget_area_soltar_estados.dart';
import 'package:geoli/Widgets/estados/widget_tela_proximo_nivel.dart';

import '../../Uteis/textos.dart';

class WidgetAreaTelaRegioes extends StatefulWidget {
  const WidgetAreaTelaRegioes(
      {super.key,
      required this.estadosSorteio,
      required this.exibirTelaProximoNivel,
      required this.nomeColecao});

  final String nomeColecao;
  final bool exibirTelaProximoNivel;
  final List<MapEntry<Estado, Gestos>> estadosSorteio;

  @override
  State<WidgetAreaTelaRegioes> createState() => _WidgetAreaTelaRegioesState();
}

class _WidgetAreaTelaRegioesState extends State<WidgetAreaTelaRegioes> {
  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      width: larguraTela,
      height: alturaTela,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: larguraTela,
                child: Text(
                  Textos.descricaoAreaEstado,
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: Platform.isAndroid || Platform.isIOS
                    ? larguraTela
                    : larguraTela * 0.6,
                height: alturaTela * 0.6,
                child: GridView.builder(
                  itemCount: widget.estadosSorteio.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          Platform.isAndroid || Platform.isIOS ? 2 : 5),
                  itemBuilder: (context, index) {
                    if (widget.exibirTelaProximoNivel) {
                      for (var element in widget.estadosSorteio) {
                        element.key.acerto = true;
                      }
                    }
                    return Center(
                        child: WidgetAreaSoltarEstados(
                      estado: widget.estadosSorteio.elementAt(index).key,
                      gesto: widget.estadosSorteio.elementAt(index).value,
                    ));
                  },
                ),
              ),
            ],
          ),
          Visibility(
              visible: widget.exibirTelaProximoNivel,
              child: Positioned(
                child: Center(
                    child: WidgetTelaProximoNivel(
                  nomeColecao: widget.nomeColecao,
                  estados: widget.estadosSorteio,
                )),
              ))
        ],
      ),
    );
  }
}
