import 'package:flutter/material.dart';

class WidgetMsgTutoriais extends StatelessWidget {
  const WidgetMsgTutoriais(
      {super.key, required this.corBorda, required this.mensagem});

  final Color corBorda;
  final String mensagem;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: 200,
      height: 100,
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
