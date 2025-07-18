import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MetodosAuxiliares {
  static String acertou = "";
  static String nomeGestoPlaneta = "";
  static int pontuacaoAtual = 0;
  static String status = "";
  static String uIDUsuario = "";
  static String telaAtualErroConexao = "";

  //Metodo para passar se o usuario acertou ou nao
  static Future<String> confirmarAcerto(String acerto) async {
    acertou = acerto;
    return acerto;
  }

  //Metodo para recuperar acerto
  static Future<String> recuperarAcerto() async {
    return acertou;
  }

  static Future<String> passarTelaAtualErroConexao(String telaAtual) async {
    telaAtualErroConexao = telaAtual;
    return telaAtualErroConexao;
  }

  //Metodo para recuperar acerto
  static Future<String> recuperarTelaAtualErroConexao() async {
    return telaAtualErroConexao;
  }

  static Future<String> passarStatusTutorial(String statusAtual) async {
    status = statusAtual;
    return status;
  }

  static Future<String> recuperarStatusTutorial() async {
    return status;
  }

  static Future<int> passarPontuacaoAtual(int pontuacao) async {
    pontuacaoAtual = pontuacao;
    return pontuacaoAtual;
  }

  static Future<int> recuperarPontuacaoAtual() async {
    return pontuacaoAtual;
  }

  static Future<String> passarGestoSorteado(String nomeGesto) async {
    nomeGestoPlaneta = nomeGesto;
    return nomeGestoPlaneta;
  }

  static Future<String> recuperarGestoSorteado() async {
    return nomeGestoPlaneta;
  }

  static Future<String> recuperarUid() async {
    return uIDUsuario;
  }

  static Future<String> passarUidUsuario(String uid) async {
    uIDUsuario = uid;
    return uIDUsuario;
  }

  // metodo para remover o gesto ja acertado da lista
  // de gestos quando voltar a jogar
  static removerGestoLista(
      Estado estado, bool value, List<Gestos> gestosCentro) {
    // definindo que a variavel vai receber o seguinte valor
    estado.acerto = value;
    if (value) {
      // caso a variavel for TRUE remover o item da lista
      gestosCentro.removeWhere(
        (element) {
          return element.nomeGesto == estado.nome;
        },
      );
      //exibirAcerto = estado.acerto;
    }
    return gestosCentro;
  }

  // metodo para exibir mensagem de retorno ao usuario
  static exibirMensagens(String msg, String tipoAlerta, int duracao,
      double largura, BuildContext context) {
    if (tipoAlerta == Constantes.msgAcerto) {
      ElegantNotification.success(
        position: Alignment.center,
        width: largura,
        showProgressIndicator: false,
        borderRadius: BorderRadius.circular(10),
        icon: Icon(
          Icons.check_circle_outline,
          size: 40,
          color: PaletaCores.corVerde,
        ),
        border: Border.all(color: PaletaCores.corVerde, width: 1),
        animationDuration: const Duration(seconds: 1),
        toastDuration: Duration(seconds: duracao),
        displayCloseButton: false,
        animation: AnimationType.fromTop,
        description: Text(msg),
      ).show(context);
    } else {
      return ElegantNotification.error(
        position: Alignment.center,
        width: largura,
        border: Border.all(color: PaletaCores.corVermelha, width: 1),
        displayCloseButton: false,
        animation: AnimationType.fromTop,
        showProgressIndicator: false,
        icon: Icon(
          Icons.close,
          size: 40,
          color: PaletaCores.corVermelha,
        ),
        animationDuration: const Duration(seconds: 1),
        toastDuration: Duration(seconds: duracao),
        description: Text(msg),
      ).show(context);
    }
  }

  // metodo para exibir mensagem de retorno ao usuario
  static exibirMensagensDuranteJogo(
      String msg, String tipoAlerta, BuildContext context) {
    if (tipoAlerta == Constantes.msgAcerto) {
      return ElegantNotification.success(
        position: Alignment.center,
        height: 130,
        width: 130,
        showProgressIndicator: false,
        borderRadius: BorderRadius.circular(40),
        icon: null,
        iconSize: 0,
        animation: AnimationType.fromTop,
        border: Border.all(color: PaletaCores.corVerde, width: 2),
        animationDuration: const Duration(milliseconds: 500),
        toastDuration: Duration(milliseconds: 1500),
        displayCloseButton: false,
        description: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              height: 80,
              width: 80,
              image: AssetImage("${CaminhosImagens.gestoAcertar}.png"),
            ),
            Text(msg)
          ],
        ),
      ).show(context);
    } else {
      return ElegantNotification.error(
        position: Alignment.center,
        height: 130,
        width: 130,
        showProgressIndicator: false,
        borderRadius: BorderRadius.circular(40),
        icon: null,
        iconSize: 0,
        animation: AnimationType.fromTop,
        border: Border.all(color: PaletaCores.corVermelha, width: 2),
        animationDuration: const Duration(milliseconds: 500),
        toastDuration: Duration(milliseconds: 1500),
        displayCloseButton: false,
        description: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              height: 80,
              width: 80,
              image: AssetImage("${CaminhosImagens.gestoErrado}.png"),
            ),
            Text(msg)
          ],
        ),
      ).show(context);
    }
  }

  // metodo para validar alteracao do email na tela de usuario
  static validarAlteracaoEmail(String emailAlterado, String nomeUsuario) async {
    bool retorno = false;
    String senha = "";
    String uid = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    senha = prefs.getString(Constantes.sharedPreferencesSenha) ?? '';
    uid = prefs.getString(Constantes.sharedPreferencesUID) ?? '';
    // caso  a variavel nao esteja vazio significa que a
    // alteracao do email foi solicitada
    if (emailAlterado.isNotEmpty) {
      //fazendo autenticacao do usuario para confirmar se a alteracao
      // do email foi concluida via link enviado para o email solitado na tela de usuario
      AuthCredential credential =
          EmailAuthProvider.credential(email: emailAlterado, password: senha);
      try {
        FirebaseAuth.instance.signInWithCredential(credential).then((value) {
          // caso a autenticacao seja VERDADEIRA sera feito
          // a atualizacao no banco de dados
          prefs.setString(Constantes.sharedPreferencesEmail, emailAlterado);
          // chamando metodo
          confirmarAlteracaoEmailBanco(uid, nomeUsuario);
          retorno = true;
          debugPrint("Validar Alteracao Email sucesso : $retorno");
          return retorno;
        }, onError: (e) {
          // caso de erro significa que o usuario ainda nao
          // confirmou a alteracao do email via link
          debugPrint("Email permanece o mesmo");
          retorno = false;
          return retorno;
        });
      } on FirebaseAuthException {
        //validarErro(e.toString());
        retorno = false;
        return retorno;
      }
    }
    return retorno;
  }

  //metodo para gravar no bando de dados
  // que o usuario confirmou a alteracao do email
  static confirmarAlteracaoEmailBanco(String uid, String nomeUsuario) {
    try {
      // passando que o campo EMAIL
      // vai receber o valor de VAZIO
      Map<String, dynamic> dadosAlteracaoEmail = {
        Constantes.fireBaseCampoNomeUsuario: nomeUsuario,
        Constantes.fireBaseCampoEmailAlterado: ""
      };
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(Constantes.fireBaseColecaoUsuarios)
          .doc(
            uid,
          )
          .set(dadosAlteracaoEmail)
          .then((value) {}, onError: (e) {
        debugPrint("AlteracaoEmail${e.toString()}");
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static exibirMensagemTextos(
      String tipoAlerta, String msg, BuildContext context) {
    if (tipoAlerta == Constantes.tipoNotificacaoSucesso) {
      ElegantNotification.success(
        width: 360,
        title: Text(tipoAlerta),
        showProgressIndicator: false,
        animationDuration: const Duration(seconds: 1),
        toastDuration: const Duration(seconds: 2),
        description: Text(msg),
      ).show(context);
    } else {
      return ElegantNotification.error(
        width: 360,
        title: Text(tipoAlerta),
        showProgressIndicator: false,
        animationDuration: const Duration(seconds: 1),
        toastDuration: const Duration(seconds: 2),
        description: Text(msg),
      ).show(context);
    }
  }

  static validarErro(String erro, BuildContext context) {
    if (erro == 'user-not-found') {
      chamarExibirMensagemErro(
        Textos.erroValidarUsuarioEmailNaoCadastrado,
        context,
      );
    } else if (erro == 'wrong-password') {
      chamarExibirMensagemErro(Textos.erroValidarUsuarioSenhaErrada, context);
      chamarExibirMensagemErro(erro, context);
    } else if (erro == "invalid-email") {
      chamarExibirMensagemErro(Textos.erroValidarUsuarioEmailErrado, context);
    } else if (erro == "unknown-error") {
      chamarExibirMensagemErro(Textos.erroValidarUsuarioSenhaErrada, context);
    } else if (erro == "email-already-in-use") {
      chamarExibirMensagemErro(Textos.erroValidarUsuarioEmailEmUso, context);
    } else if (erro.contains(
      "We have blocked all requests from this device due to unusual activity. Try again later.",
    )) {
      chamarExibirMensagemErro(Textos.erroAcaoBloqueada, context);
    } else {
      chamarExibirMensagemErro("Erro Desconhecido : $erro", context);
    }
  }

  static chamarExibirMensagemErro(String erro, BuildContext context) {
    exibirMensagemTextos(Constantes.tipoNotificacaoErro, erro, context);
  }

 static validarTamanhoTelaCarregamento(double largura) {
    if (largura <= 600) {
      return 300.0;
    } else if (largura > 600 && largura <= 1000) {
      return 400.0;
    } else if (largura > 1000) {
      return 600.0;
    }
  }

  static  validarTamanhoGestos(double largura) {
    if (largura <= 600) {
      return 70.0;
    } else if (largura > 600 && largura <= 1000) {
      return 90.0;
    } else if (largura > 1000) {
      return 100.0;
    }
  }

  static validarTamanhoLarguraBotao(double largura) {
    if (largura <= 600) {
      return 120.0;
    } else if (largura > 600 && largura <= 1000) {
      return 120.0;
    } else if (largura > 1000) {
      return 140.0;
    }
  }

static validarTamanhoAlturaBotao(double largula) {
    if (largula <= 600) {
      return 130.0;
    } else if (largula > 600 && largula <= 1000) {
      return 150.0;
    } else if (largula > 1000) {
      return 170.0;
    }
  }
}
