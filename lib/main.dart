import 'package:flutter/material.dart';
import 'package:geoli/Uteis/constantes.dart';

import 'Uteis/rotas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Constantes.rotaTelaInicialRegioes,
      onGenerateRoute: Rotas.generateRoute,
    );
  }
}
