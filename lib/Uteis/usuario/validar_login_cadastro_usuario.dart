import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoli/Uteis/variaveis_constantes/constantes.dart';
import 'package:geoli/Uteis/usuario/criar_dados_banco_firebase.dart';
import 'package:geoli/Uteis/passar_pegar_dados.dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ValidarLoginCadastroUsuario {
  static Future<String> fazerLogin(
    String email,
    String senha,
    BuildContext context,
  ) async {
    try {
      String retorno = "";
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.replaceAll(" ", ""),
        password: senha,
      );
      if (credential.user != null) {
        passarInformacoes(
          credential.user!.uid,
          credential.user!.email.toString(),
          senha,
          "",
        );
        retorno = Constantes.tipoNotificacaoSucesso;
      } else {
        retorno = Constantes.tipoNotificacaoErro;
      }
      return retorno;
    } on FirebaseAuthException catch (e) {
      return e.code.toString();
    }
  }

  static Future<String> criarCadastro(
    String email,
    String senha,
    String usuario,
    BuildContext context,
  ) async {
    try {
      String retorno = "";
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email.replaceAll(" ", ""), password: senha);
      if (credential.user != null) {
        //passando as informacoes
        // para a proxima tela
        passarInformacoes(credential.user!.uid,
            credential.user!.email.toString(), senha, usuario);

        bool retornoCriacaoDados =
            await CriarDadosBanco.chamarCriarDadosUsuario();

        if (retornoCriacaoDados) {
          retorno = Constantes.tipoNotificacaoSucesso;
        } else {
          retorno = Constantes.tipoNotificacaoErro;
        }
      } else {
        retorno = Constantes.tipoNotificacaoErro;
      }
      return retorno;
    } on FirebaseAuthException catch (e) {
      return e.code.toString();
    }
  }
}

passarInformacoes(String uid, String email, senha, String usuario) {
  Map dados = {};
  dados[Constantes.infoUsuarioUID] = uid;
  dados[Constantes.infoUsuarioEmail] = email.replaceAll(" ", "");
  dados[Constantes.infoUsuarioNome] = usuario;
  gravarSenhaUsuario(senha);
  PassarPegarDados.passarInformacoesUsuario(dados);
}

gravarSenhaUsuario(String senha) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(Constantes.infoUsuarioSenha, senha);
}
