import 'package:flutter/material.dart';

class MsgTutoriaisWidget extends StatelessWidget {
  const MsgTutoriaisWidget(
      {super.key,
      required this.corBorda,
      required this.mensagem,
      this.larguraCaixaMensagem = 220});

  final Color corBorda;
  final String mensagem;
  final double larguraCaixaMensagem;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: larguraCaixaMensagem,
      height: 90,
      child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: corBorda),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              mensagem,
              textAlign: TextAlign.center,
            ),
          )),
    );
  }
}
