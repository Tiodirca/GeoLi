import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Widgets/tela_proximo_nivel.dart';

import '../Uteis/textos.dart';
import 'area_soltar.dart';

class WidgetAreaTela extends StatefulWidget {
  const WidgetAreaTela(
      {super.key,
      required this.nomeTela,
      required this.estadosSorteio,
      required this.exibirTelaProximoNivel});

  final String nomeTela;
  final bool exibirTelaProximoNivel;
  final List<MapEntry<Estado, Gestos>> estadosSorteio;

  @override
  State<WidgetAreaTela> createState() => _WidgetAreaTelaState();
}

class _WidgetAreaTelaState extends State<WidgetAreaTela> {
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
                    return Center(
                        child: AreaSoltar(
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
                    child: TelaProximoNivel(
                  estados: widget.estadosSorteio,
                )),
              ))
        ],
      ),
    );
  }
}
