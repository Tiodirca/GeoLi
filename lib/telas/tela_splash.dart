import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Widgets/tela_carregamento_widget.dart';
import '../Uteis/constantes.dart';

class TelaSplashScreen extends StatefulWidget {
  const TelaSplashScreen({super.key});

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
            child: TelaCarregamentoWidget(
              corPadrao: PaletaCores.corVerde,
            ),
          ))),
    );
  }
}
