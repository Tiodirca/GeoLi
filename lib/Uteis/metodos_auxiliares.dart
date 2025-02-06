import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
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
              .fireBaseDocumentoRegiaoNordeste) //passando o documento
          .set({
        Constantes.nomeRegiaoNordesteAL: false,
        Constantes.nomeRegiaoNordesteBA: false,
        Constantes.nomeRegiaoNordesteCE: false,
        Constantes.nomeRegiaoNordesteMA: false,
        Constantes.nomeRegiaoNordestePB: false,
        Constantes.nomeRegiaoNordestePE: false,
        Constantes.nomeRegiaoNordestePI: false,
        Constantes.nomeRegiaoNordesteRN: false,
        Constantes.nomeRegiaoNordesteCE: false,

      });
    } catch (e) {
      print(e.toString());
    }
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
