import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/passar_pegar_dados.dart.dart';
import 'package:geoli/Widgets/tela_carregamento_widget.dart';
import '../Uteis/variaveis_constantes/constantes.dart';

class TelaSplashScreen extends StatefulWidget {
  const TelaSplashScreen({super.key});

  @override
  State<TelaSplashScreen> createState() => _TelaSplashScreenState();
}

class _TelaSplashScreenState extends State<TelaSplashScreen> {
  late StreamSubscription<User?> validacao;
  int index = 0;
  String emailAlteracao = "";
  String usuarioEmail = "";
  String usuarioUID = "";
  String nomeCampoEmailAlterado = Constantes.fireBaseCampoUsuarioEmailAlterado;
  String nomeColecaoUsuariosFireBase = Constantes.fireBaseColecaoUsuarios;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      validarUsuarioLogado();
    });
  }

  validarUsuarioLogado() async {
    validacao = FirebaseAuth.instance.authStateChanges().listen((
      User? user,
    ) async {
      index++;
      if(kIsWeb){
        if (user != null) {
          debugPrint("Usuario Logado");
          usuarioEmail = user.email.toString();
          usuarioUID = user.uid.toString();
          passarInformacoes(usuarioUID, usuarioEmail);
          redirecionarTelaInicial();
        } else {
          debugPrint("Sem Usuario Logado");
          redirecionarTelaLoginCadastro();
        }
      }else{
        if (index == 2 && (!Platform.isIOS || !Platform.isAndroid) ||
            index == 1 && (Platform.isIOS || Platform.isAndroid)) {
          index = 0;
          if (user != null) {
            debugPrint("Usuario Logado");
            usuarioEmail = user.email.toString();
            usuarioUID = user.uid.toString();
            passarInformacoes(usuarioUID, usuarioEmail);
            redirecionarTelaInicial();
          } else {
            debugPrint("Sem Usuario Logado");
            redirecionarTelaLoginCadastro();
          }
        }
      }
    });
  }

  redirecionarTelaLoginCadastro() {
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaLoginCadastro);
  }

  redirecionarTelaInicial() {
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
  }

  passarInformacoes(String uid, String email) {
    Map dados = {};
    dados[Constantes.infoUsuarioUID] = uid;
    dados[Constantes.infoUsuarioEmail] = email;
    PassarPegarDados.passarInformacoesUsuario(dados);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    validacao.cancel();
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
