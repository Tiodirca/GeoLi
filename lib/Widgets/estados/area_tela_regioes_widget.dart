import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Widgets/estados/widget_area_soltar_estados.dart';
import 'package:geoli/Widgets/estados/widget_tela_proximo_nivel.dart';
import '../../Uteis/textos.dart';

class AreaTelaRegioesWidget extends StatelessWidget {
  const AreaTelaRegioesWidget(
      {super.key,
      required this.estadosSorteio,
      required this.exibirTelaProximoNivel,
      required this.nomeColecao});

  final String nomeColecao;
  final bool exibirTelaProximoNivel;
  final List<MapEntry<Estado, Gestos>> estadosSorteio;

  // conforme o tamanho da tela e
  // xibir determinda quantidade de colunas
  quantidadeColunasGridView(double larguraTela) {
    int tamanho = 5;
    //verificando qual o tamanho da tela
    if (larguraTela <= 400) {
      tamanho = 2;
    } else if (larguraTela > 400 && larguraTela <= 800) {
      tamanho = 3;
    } else if (larguraTela > 800 && larguraTela <= 1100) {
      tamanho = 5;
    } else if (larguraTela > 1100 && larguraTela <= 1300) {
      tamanho = 6;
    } else if (larguraTela > 1300) {
      tamanho = 7;
    }
    return tamanho;
  }

  @override
  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    return Container(
        color: Colors.white,
        width: larguraTela,
        height: alturaTela,
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
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
                    width: kIsWeb
                        ? larguraTela * 0.9
                        : Platform.isAndroid || Platform.isIOS
                            ? larguraTela
                            : larguraTela * 0.6,
                    height: alturaTela * 0.6,
                    child: GridView.builder(
                      itemCount: estadosSorteio.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: quantidadeColunasGridView(
                          larguraTela,
                        ),
                      ),
                      itemBuilder: (context, index) {
                        if (exibirTelaProximoNivel) {
                          for (var element in estadosSorteio) {
                            element.key.acerto = true;
                          }
                        }
                        return WidgetAreaSoltarEstados(
                          estado: estadosSorteio.elementAt(index).key,
                          gesto: estadosSorteio.elementAt(index).value,
                        );
                      },
                    ),
                  ),
                ],
              ),
              Visibility(
                  visible: exibirTelaProximoNivel,
                  child: Center(
                    child: WidgetTelaProximoNivel(
                      nomeColecao: nomeColecao,
                      estados: estadosSorteio,
                    ),
                  ))
            ],
          ),
        ));
  }
}
