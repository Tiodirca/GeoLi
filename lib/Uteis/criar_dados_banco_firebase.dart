import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/constantes_estados_gestos.dart';
import 'package:geoli/Uteis/constantes_sistema_solar.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/modelos/planeta.dart';

class CriarDadosBanco {
  static Map<String, dynamic> dados = {};
  static List<Planeta> planetas = ConstantesSistemaSolar.adicinarPlanetas();
  static Map<Estado, Gestos> estadoGestoMap =
      ConstantesEstadosGestos.adicionarEstadosGestos();
  static List<String> nomeRegioes = [
    Constantes.fireBaseDocumentoRegiaoCentroOeste,
    Constantes.fireBaseDocumentoRegiaoSul,
    Constantes.fireBaseDocumentoRegiaoSudeste,
    Constantes.fireBaseDocumentoRegiaoNorte,
    Constantes.fireBaseDocumentoRegiaoNordeste,
    Constantes.fireBaseDocumentoRegiaoTodosEstados
  ];

  //metodo para gravar no banco de dados
  static gravarDadosFirebaseUsuario(
      String colecaoUIDUsuario, Map<String, dynamic> dados) {
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(Constantes.fireBaseColecaoUsuarios)
          .doc(colecaoUIDUsuario)
          .set(dados);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //metodo para gravar no banco de dados
  static gravarDadosFirebase(
      String colecaoUIDUsuario,
      String nomeColecaoDocumento,
      String nomeDocumentoFinal,
      Map<String, dynamic> dados) {
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(Constantes.fireBaseColecaoUsuarios)
          .doc(colecaoUIDUsuario)
          .collection(nomeColecaoDocumento)
          .doc(nomeDocumentoFinal)
          .set(dados);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // metodo para criar dados do usuario no banco de dados
  // e os dados necessarios para ele poder jogar
  static criarDadosUsuario(BuildContext context, String nomeUsuario) async {
    Map<String, dynamic> dadosPontuacao = {Constantes.pontosJogada: 0};
    Map<String, dynamic> dadosNomeUsuario = {
      Constantes.fireBaseDocumentoNomeUsuario: nomeUsuario
    };
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        criarDesbloquearPlaneta(user.uid);
        //gravando pontuacao de Regioes e Sistema Solar
        gravarDadosFirebase(user.uid, Constantes.fireBaseColecaoRegioes,
            Constantes.fireBaseDocumentoPontosJogadaRegioes, dadosPontuacao);
        // gravarDadosFirebase(user.uid, Constantes.fireBaseDocumentoDadosUsuario,
        //     Constantes.fireBaseDocumentoDadosUsuario, dadosNomeUsuario);
        gravarDadosFirebaseUsuario(user.uid, dadosNomeUsuario);
        gravarDadosFirebase(
            user.uid,
            Constantes.fireBaseColecaoSistemaSolar,
            Constantes.fireBaseDocumentoPontosJogadaSistemaSolar,
            dadosPontuacao);
        gravarNiveisLiberados(user.uid);
        for (var element in nomeRegioes) {
          criarDadosRegioesPorLevel(element, user.uid);
        }
      }
    });
    MetodosAuxiliares.exibirMensagens(
        Textos.sucessoCadastro,
        Constantes.msgAcerto,
        Constantes.duracaoExibicaoToastJogos,
        Constantes.larguraToastLoginCadastro,
        context);
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
    });
  }

  //metodo vai percorrer a o map e vai adicionar no MAP de Dados
  // os estados conforme for validado a
  // condicao para poder gravar no banco online
  static criarDadosRegioesPorLevel(String regiao, String uidUsuario) {
    int indexMap = 0;
    estadoGestoMap.forEach(
      (key, value) {
        // indexMAP para percorrer o index do MAP
        // de forma que busque somente os dados contidos naquele index
        indexMap = indexMap + 1;
        if (indexMap < 4 &&
            regiao == Constantes.fireBaseDocumentoRegiaoCentroOeste) {
          dados[key.nome] = false;
        } else if (indexMap > 3 &&
            indexMap < 7 &&
            regiao == Constantes.fireBaseDocumentoRegiaoSul) {
          dados[key.nome] = false;
        } else if (indexMap > 6 &&
            indexMap < 11 &&
            regiao == Constantes.fireBaseDocumentoRegiaoSudeste) {
          dados[key.nome] = false;
        } else if (indexMap > 10 &&
            indexMap < 18 &&
            regiao == Constantes.fireBaseDocumentoRegiaoNorte) {
          dados[key.nome] = false;
        } else if (indexMap > 17 &&
            indexMap < 27 &&
            regiao == Constantes.fireBaseDocumentoRegiaoNordeste) {
          dados[key.nome] = false;
        } else if (indexMap < 27 &&
            regiao == Constantes.fireBaseDocumentoRegiaoTodosEstados) {
          dados[key.nome] = false;
        }
      },
    );
    gravarDadosFirebase(
        uidUsuario, Constantes.fireBaseColecaoRegioes, regiao, dados);
    dados.clear();
  }

  static criarDesbloquearPlaneta(String uidUsuario) {
    Map<String, bool> dados = {};
    for (var element in planetas) {
      //definindo que o map vai receber o
      // nome do planeta e o valor boleano
      dados[element.nomePlaneta] = false;
    }
    gravarDadosFirebase(uidUsuario, Constantes.fireBaseColecaoSistemaSolar,
        Constantes.fireBaseDocumentoPlanetasDesbloqueados, dados);
  }

  // metodo criar no banco de dados os seguintes campos
  static gravarNiveisLiberados(String uidUsuario) async {
    Map<String, dynamic> dados = {
      Textos.nomeRegiaoSul: false,
      Textos.nomeRegiaoSudeste: false,
      Textos.nomeRegiaoNorte: false,
      Textos.nomeRegiaoNordeste: false,
      Constantes.nomeTodosEstados: false
    };
    gravarDadosFirebase(uidUsuario, Constantes.fireBaseColecaoRegioes,
        Constantes.fireBaseDocumentoLiberarEstados, dados);
  }
}
