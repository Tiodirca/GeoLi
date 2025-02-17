import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import '../Uteis/constantes.dart';
import '../Uteis/metodos_auxiliares.dart';
import '../Widgets/tela_carregamento.dart';

class TelaSplashScreen extends StatefulWidget {
  const TelaSplashScreen({Key? key}) : super(key: key);

  @override
  State<TelaSplashScreen> createState() => _TelaSplashScreenState();
}

class _TelaSplashScreenState extends State<TelaSplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
    });
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          height: alturaTela,
          width: larguraTela,
          color: PaletaCores.corAzulEscuro,
          child: SingleChildScrollView(
              child: SizedBox(
                  width: larguraTela,
                  height: alturaTela,
                  child: TelaCarregamento(),))),
    );
  }
}
