import 'package:flutter/material.dart';

import '../Uteis/textos.dart';

class TelaCarregamentoWidget extends StatefulWidget {
  const TelaCarregamentoWidget({super.key, required this.corPadrao});

  final Color corPadrao;

  @override
  State<TelaCarregamentoWidget> createState() => _TelaCarregamentoWidgetState();
}

class _TelaCarregamentoWidgetState extends State<TelaCarregamentoWidget> {

  validarTamanhoTelaCarregamento(double largura) {
    if (largura <= 600) {
      return 300.0;
    } else if (largura > 600 && largura <= 1000) {
      return 400.0;
    } else if (largura > 1000) {
      return 600.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaTela = MediaQuery.of(context).size.height;
    return Container(
        padding: const EdgeInsets.all(10),
        width: larguraTela,
        height: alturaTela,
        color: Colors.white,
        child: Center(
          child: SizedBox(
            width: validarTamanhoTelaCarregamento(larguraTela),
            height: 150,
            child: Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: widget.corPadrao),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Textos.txtTelaCarregamento,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(widget.corPadrao),
                    strokeWidth: 3.0,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
