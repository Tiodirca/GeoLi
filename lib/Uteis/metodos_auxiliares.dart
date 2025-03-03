import 'dart:async';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/paleta_cores.dart';

class MetodosAuxiliares {
  static String acertou = "";
  static String nomeGestoPlaneta = "";
  static int pontuacaoAtual = 0;
  static String status = "";
  static int quantRegioesLiberadas = 0;
  static String uIDUsuario = "";

  //Metodo para passar se o usuario acertou ou nao
  static Future<String> confirmarAcerto(String acerto) async {
    acertou = acerto;
    return acerto;
  }

  //Metodo para recuperar acerto
  static Future<String> recuperarAcerto() async {
    return acertou;
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
  static exibirMensagens(String msg, String tipoAlerta, BuildContext context) {
    if (tipoAlerta == Constantes.msgAcerto) {
      ElegantNotification.success(
        position: Alignment.center,
        width: 200,
        showProgressIndicator: false,
        icon: Icon(
          Icons.check_circle_outline,
          size: 40,
          color: PaletaCores.corVerde,
        ),
        border: Border.all(color: PaletaCores.corVerde, width: 1),
        animationDuration: const Duration(seconds: 1),
        toastDuration: const Duration(seconds: 1),
        displayCloseButton: false,
        animation: AnimationType.fromTop,
        description: Text(msg),
      ).show(context);
    } else {
      return ElegantNotification.error(
        position: Alignment.center,
        width: 150,
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
        toastDuration: const Duration(seconds: 1),
        description: Text(msg),
      ).show(context);
    }
  }
}
