import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoli/Uteis/variaveis_constantes/constantes.dart';

class ExclusaoDados {
  static String nomeColecaoUsuariosFireBase =
      Constantes.fireBaseColecaoUsuarios;

  // metodo para excluir informacoes do usuario no banco de dados,
  // como email alterado e nome de usuario
  static Future<bool> excluirInformacoesUsuario(String uidUsuario) async {
    bool retorno = false;
    try {
      var db = FirebaseFirestore.instance;
      await db
          .collection(nomeColecaoUsuariosFireBase) // passando a colecao
          .doc(uidUsuario)
          .delete()
          .then(
        (value) {
          retorno = true;
        },
        onError: (e) {
          retorno = false;
          debugPrint("Erro : ${e.toString()}");
        },
      );
    } catch (e) {
      retorno = false;
      debugPrint("Erro : ${e.toString()}");
    }
    return retorno;
  }

  static Future<bool> chamarDeletarItemAItem(
    String nomeColecao,
    String uidUsuario,
  ) async {
    bool retorno = false;
    var db = FirebaseFirestore.instance;
    await db
        .collection(nomeColecaoUsuariosFireBase)
        .doc(uidUsuario)
        .collection(nomeColecao)
        .get()
        .then(
      (querySnapshot) {
        //para cada iteracao do FOR excluir o
        //item corresponde ao ID da iteracao
        for (var docSnapshot in querySnapshot.docs) {
          db
              .collection(nomeColecaoUsuariosFireBase)
              .doc(uidUsuario)
              .collection(nomeColecao)
              .doc(docSnapshot.id)
              .delete()
              .then(
            (value) {
              retorno = true;
            },
            onError: (e) {
              debugPrint("Erro Excluir Item a item : ${e.toString()}");
            },
          );
        }
        retorno = true;
      },
      onError: (e) {
        debugPrint("Erro Excluir Item a item : ${e.toString()}");
        retorno = false;
      },
    );
    return retorno;
  }
}
