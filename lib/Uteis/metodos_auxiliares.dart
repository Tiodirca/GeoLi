import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/paleta_cores.dart';

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

  static resetarDadosRegiaoSul() async {
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
          .doc(Constantes.fireBaseDocumentoRegiaoSul) //passando o documento
          .set({
        Constantes.nomeRegiaoSulRS: false,
        Constantes.nomeRegiaoSulSC: false,
        Constantes.nomeRegiaoSulPR: false,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  static resetarDadosRegiaoSudeste() async {
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
          .doc(Constantes.fireBaseDocumentoRegiaoSudeste) //passando o documento
          .set({
        Constantes.nomeRegiaoSudesteRJ: false,
        Constantes.nomeRegiaoSudesteES: false,
        Constantes.nomeRegiaoSudesteMG: false,
        Constantes.nomeRegiaoSudesteSP: false,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  static resetarDadosRegiaoNorte() async {
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
          .doc(Constantes.fireBaseDocumentoRegiaoNorte) //passando o documento
          .set({
        Constantes.nomeRegiaoNorteAC: false,
        Constantes.nomeRegiaoNorteAP: false,
        Constantes.nomeRegiaoNorteAM: false,
        Constantes.nomeRegiaoNortePA: false,
        Constantes.nomeRegiaoNorteRO: false,
        Constantes.nomeRegiaoNorteRR: false,
        Constantes.nomeRegiaoNorteTO: false,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  static exibirMensagens(String msg, String tipoAlerta, BuildContext context) {
    if (tipoAlerta == Constantes.msgAcertoGesto) {
      ElegantNotification.success(
        position: Alignment.center,
        width: 200,
        title: Text(tipoAlerta),
        showProgressIndicator: false,
        icon: Icon(
          Icons.check_circle_outline,
          size: 40,
          color: PaletaCores.corVerde,
        ),
        border: Border(
            top: BorderSide(color: PaletaCores.corVerde, width: 1),
            bottom: BorderSide(color: PaletaCores.corVerde, width: 1),
            left: BorderSide(color: PaletaCores.corVerde, width: 1),
            right: BorderSide(color: PaletaCores.corVerde, width: 1)),
        animationDuration: const Duration(seconds: 1),
        toastDuration: const Duration(seconds: 2),
        displayCloseButton: false,
        animation: AnimationType.fromTop,
        description: Text(msg),
      ).show(context);
    } else {
      return ElegantNotification.error(
        position: Alignment.center,
        width: 150,
        border: Border(
            top: BorderSide(color: PaletaCores.corVermelha, width: 1),
            bottom: BorderSide(color: PaletaCores.corVermelha, width: 1),
            left: BorderSide(color: PaletaCores.corVermelha, width: 1),
            right: BorderSide(color: PaletaCores.corVermelha, width: 1)),
        displayCloseButton: false,
        animation: AnimationType.fromTop,
        showProgressIndicator: false,
        icon: Icon(
          Icons.close,
          size: 40,
          color: PaletaCores.corVermelha,
        ),
        animationDuration: const Duration(seconds: 1),
        toastDuration: const Duration(seconds: 2),
        description: Text(msg),
      ).show(context);
    }
  }
}
