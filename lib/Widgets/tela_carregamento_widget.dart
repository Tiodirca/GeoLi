import 'dart:async';

import 'package:flutter/material.dart';

import '../Uteis/textos.dart';

class TelaCarregamentoWidget extends StatefulWidget {
  const TelaCarregamentoWidget(
      {super.key,
      required this.corPadrao,
      required this.exibirMensagemConexao});

  final Color corPadrao;
  final bool exibirMensagemConexao;

  @override
  State<TelaCarregamentoWidget> createState() => _TelaCarregamentoWidgetState();
}

class _TelaCarregamentoWidgetState extends State<TelaCarregamentoWidget> {
  late Timer iniciarTempo;
  int tempo = 10;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.exibirMensagemConexao) {
      comecarTempo();
    }
  }

  void comecarTempo() {
    const segundo = Duration(seconds: 1);
    iniciarTempo = Timer.periodic(
      segundo,
      (timer) {
        if (tempo == 0) {
          if (mounted) {
            setState(() {
              tempo = 10;
              timer.cancel();
              comecarTempo();
            });
          }
        } else {
          if (mounted) {
            setState(() {
              tempo--;
            });
          }
        }
      },
    );
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
            width: larguraTela * 0.9,
            height: 150,
            child: Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: widget.corPadrao),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              color: Colors.white,
              child: Center(child: LayoutBuilder(
                builder: (context, constraints) {
                  if (widget.exibirMensagemConexao) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Textos.erroSemInternetAvisoTelaCarregamento,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          tempo.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  } else {
                    return Column(
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
                    );
                  }
                },
              )),
            ),
          ),
        ));
  }
}
