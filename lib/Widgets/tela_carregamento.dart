import 'package:flutter/material.dart';

import '../Uteis/textos.dart';

class TelaCarregamento extends StatelessWidget {
  const TelaCarregamento({Key? key, required this.corPadrao}) : super(key: key);

  final Color corPadrao;

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
                  side: BorderSide(color: corPadrao),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              color: Colors.white,
              child: Center(
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
                      valueColor: AlwaysStoppedAnimation(corPadrao),
                      strokeWidth: 3.0,
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
