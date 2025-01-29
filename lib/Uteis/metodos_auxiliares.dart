import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Uteis/constantes.dart';

class MetodosAuxiliares {
  static String acertou = "";

  static Future<String> confirmarAcerto(String acerto) async {
    acertou = acerto;
    return acerto;
  }

  static Future<String> recuperarAcerto() async {
    return acertou;
  }

  // metodo para cadastrar item
 static resetarDadosRegiaoCentroOeste() async {
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
          .doc(Constantes
              .fireBaseDocumentoRegiaoCentroOeste) //passando o documento
          .set({
        Constantes.nomeRegiaoCentroGO: false,
        Constantes.nomeRegiaoCentroMG: false,
        Constantes.nomeRegiaoCentroMS: false,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  static exibirMensagens(String msg, String tipoAlerta, BuildContext context) {
    if (tipoAlerta == Constantes.msgAcertoGesto) {
      ElegantNotification.success(
        position: Alignment.center,
        width: 360,
        title: Text(tipoAlerta),
        showProgressIndicator: false,
        animationDuration: const Duration(seconds: 1),
        toastDuration: const Duration(seconds: 3),
        displayCloseButton: false,
        animation: AnimationType.fromTop,
        description: Text(msg),
      ).show(context);
    } else {
      return ElegantNotification.error(
        position: Alignment.center,
        width: 360,
        displayCloseButton: false,
        animation: AnimationType.fromTop,
        title: Text(tipoAlerta),
        showProgressIndicator: false,
        animationDuration: const Duration(seconds: 1),
        toastDuration: const Duration(seconds: 3),
        description: Text(msg),
      ).show(context);
    }
  }
}
