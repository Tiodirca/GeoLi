import 'package:flutter/material.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/telas/regioes_brasil/tela_inicial_regioes.dart';
import 'package:geoli/telas/regioes_brasil/tela_regiao_centro_oeste.dart';
import 'package:geoli/telas/regioes_brasil/tela_regiao_nordeste.dart';
import 'package:geoli/telas/regioes_brasil/tela_regiao_norte.dart';
import 'package:geoli/telas/regioes_brasil/tela_regiao_sudeste.dart';
import 'package:geoli/telas/tela_inicial.dart';
import 'package:geoli/telas/regioes_brasil/tela_regiao_sul.dart';
import 'package:geoli/telas/regioes_brasil/tela_todas_regioes.dart';
import 'package:geoli/telas/tela_login_cadastro.dart';
import 'package:geoli/telas/tela_sistema_solar.dart';
import 'package:geoli/telas/tela_splash.dart';
import 'package:geoli/telas/tela_usuario_detalhado.dart';

class Rotas {
  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Constantes.rotaTelaSplashScreen:
        return MaterialPageRoute(builder: (_) => TelaSplashScreen());
      case Constantes.rotaTelaInicial:
        return MaterialPageRoute(builder: (_) => TelaInicial());
      case Constantes.rotaTelaInicialRegioes:
        return MaterialPageRoute(builder: (_) => TelaInicialRegioes());
      case Constantes.rotaTelaRegiaoCentroOeste:
        return MaterialPageRoute(builder: (_) => TelaRegiaoCentroOeste());
      case Constantes.rotaTelaRegiaoSul:
        return MaterialPageRoute(builder: (_) => TelaRegiaoSul());
      case Constantes.rotaTelaRegiaoSudeste:
        return MaterialPageRoute(builder: (_) => TelaRegiaoSudeste());
      case Constantes.rotaTelaRegiaoNorte:
        return MaterialPageRoute(builder: (_) => TelaRegiaoNorte());
      case Constantes.rotaTelaRegiaoNordeste:
        return MaterialPageRoute(builder: (_) => TelaRegiaoNordeste());
      case Constantes.rotaTelaRegiaoTodosEstados:
        return MaterialPageRoute(builder: (_) => TelaTodasRegioes());
      case Constantes.rotaTelaSistemaSolar:
        return MaterialPageRoute(builder: (_) => TelaSistemaSolar());
      case Constantes.rotaTelaLoginCadastro:
        return MaterialPageRoute(builder: (_) => TelaLoginCadastro());
      case Constantes.rotaTelaUsuarioDetalhado:
        return MaterialPageRoute(builder: (_) => TelaUsuarioDetalhado());
    }
    // Se o argumento não é do tipo correto, retorna erro
    return erroRota(settings);
  }

  //metodo para exibir tela de erro
  static Route<dynamic> erroRota(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Telas não encontrada!"),
        ),
        body: Container(
          color: Colors.red,
          child: const Center(
            child: Text("Erro de Rota"),
          ),
        ),
      );
    });
  }
}
