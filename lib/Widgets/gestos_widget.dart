import 'package:flutter/material.dart';

class GestosWidget extends StatelessWidget {
  const GestosWidget(
      {super.key,
      required this.nomeGestoImagem,
      required this.nomeGesto,
      required this.exibirAcerto});

  final String nomeGestoImagem;
  final String nomeGesto;
  final bool exibirAcerto;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 120,
        height: 120,
        child: Card(
          color: Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      width: 70,
                      height: 70,
                      image: AssetImage('$nomeGestoImagem.png'),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        nomeGesto,
                        style: TextStyle(
                          color: Colors.black,
                          inherit: false,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                Visibility(
                    visible: exibirAcerto,
                    child: Positioned(
                        child: SizedBox(
                      width: 110,
                      height: 110,
                      child: Icon(
                        Icons.done_all,
                        color: Colors.green,
                        size: 100,
                      ),
                    )))
              ],
            )));
  }
}
