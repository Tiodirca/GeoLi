import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/constantes_estados_gestos.dart';
import 'package:geoli/Uteis/constantes_sistema_solar.dart';
import 'package:geoli/Uteis/passar_pegar_dados.dart.dart';
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
  static Future<bool> gravarDadosFirebaseUsuario(
      String colecaoUIDUsuario, Map<String, dynamic> dados) async {
    bool retorno = false;
    try {
      var db = FirebaseFirestore.instance;
      await db
          .collection(Constantes.fireBaseColecaoUsuarios)
          .doc(colecaoUIDUsuario)
          .set(dados)
          .then((value) {
        retorno = true;
      }, onError: (e) {
        debugPrint(e.toString());
        retorno = false;
      });
    } catch (e) {
      retorno = false;
      debugPrint(e.toString());
    }
    return retorno;
  }

  //metodo para gravar no banco de dados
  static Future<bool> gravarDadosFirebase(
      String colecaoUIDUsuario,
      String nomeColecaoDocumento,
      String nomeDocumentoFinal,
      Map<String, dynamic> dados) async {
    bool retorno = false;
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      await db
          .collection(Constantes.fireBaseColecaoUsuarios)
          .doc(colecaoUIDUsuario)
          .collection(nomeColecaoDocumento)
          .doc(nomeDocumentoFinal)
          .set(dados)
          .then((value) {
        retorno = true;
      }, onError: (e) {
        retorno = false;
      });
    } catch (e) {
      retorno = false;
      debugPrint(e.toString());
    }
    return retorno;
  }

  static Future<bool> chamarCriarDadosUsuario() async {
    bool retornoCriacaoDados = false;
    String uid =
        PassarPegarDados.recuperarInformacoesUsuario().values.elementAt(0);
    String usuario =
        PassarPegarDados.recuperarInformacoesUsuario().values.elementAt(2);
    Map<String, dynamic> dadosPontuacao = {Constantes.pontosJogada: 0};
    Map<String, dynamic> dadosNomeUsuario = {
      Constantes.fireBaseCampoNomeUsuario: usuario,
      Constantes.fireBaseCampoUsuarioEmailAlterado: ""
    };

    bool retornoDadosPontuacaoRegioes = await gravarDadosFirebase(
        uid,
        Constantes.fireBaseColecaoRegioes,
        Constantes.fireBaseDocumentoPontosJogadaRegioes,
        dadosPontuacao);
    bool retornoDadosPontuacaoSistemaSolar = await gravarDadosFirebase(
        uid,
        Constantes.fireBaseColecaoSistemaSolar,
        Constantes.fireBaseDocumentoPontosJogadaSistemaSolar,
        dadosPontuacao);
    bool retornoDadosUsuario =
        await gravarDadosFirebaseUsuario(uid, dadosNomeUsuario);
    bool retornoDesbloquearPLateta = await criarDesbloquearPlaneta(uid);
    bool retornoNiveisLiberados = await gravarNiveisLiberados(uid);

    bool retornoDadosPorNivelFinal = await chamarCriarDadosRegioesPorNivel(uid);

    if (retornoDadosPontuacaoRegioes &&
        retornoDadosPontuacaoSistemaSolar &&
        retornoDadosUsuario &&
        retornoDesbloquearPLateta &&
        retornoNiveisLiberados &&
        retornoDadosPorNivelFinal) {
      retornoCriacaoDados = true;
    } else {
      retornoCriacaoDados = false;
    }
    return retornoCriacaoDados;
  }

  //metodo para criar informacoes no banco de dados nivel por nivel
  static Future<bool> chamarCriarDadosRegioesPorNivel(String uid) async {
    bool retorno = false;
    int index = 0;
    //percorrendo a lista para poder gravar as informacoes de cada nivel
    for (var element in nomeRegioes) {
      bool retornoDadosPorNivel = await criarDadosRegioesPorLevel(element, uid);
      if (retornoDadosPorNivel) {
        index++;
        if (index == nomeRegioes.length) {
          retorno = true;
        }
      } else {
        retorno = false;
      }
    }
    return retorno;
  }

  //metodo vai percorrer a o map e vai adicionar no MAP de Dados
  // os estados conforme for validado a
  // condicao para poder gravar no banco online
  static Future<bool> criarDadosRegioesPorLevel(
      String regiao, String uidUsuario) async {
    bool retorno = false;
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
    retorno = await gravarDadosFirebase(
        uidUsuario, Constantes.fireBaseColecaoRegioes, regiao, dados);
    dados.clear();
    return retorno;
  }

  static Future<bool> criarDesbloquearPlaneta(String uidUsuario) async {
    bool retorno = false;
    Map<String, bool> dados = {};
    for (var element in planetas) {
      //definindo que o map vai receber o
      // nome do planeta e o valor boleano
      dados[element.nomePlaneta] = false;
    }
    retorno = await gravarDadosFirebase(
        uidUsuario,
        Constantes.fireBaseColecaoSistemaSolar,
        Constantes.fireBaseDocumentoPlanetasDesbloqueados,
        dados);
    return retorno;
  }

  // metodo criar no banco de dados os seguintes campos
  static Future<bool> gravarNiveisLiberados(String uidUsuario) async {
    bool retorno = false;
    Map<String, dynamic> dados = {
      Textos.nomeRegiaoSul: false,
      Textos.nomeRegiaoSudeste: false,
      Textos.nomeRegiaoNorte: false,
      Textos.nomeRegiaoNordeste: false,
      Constantes.nomeTodosEstados: false
    };
    retorno = await gravarDadosFirebase(
        uidUsuario,
        Constantes.fireBaseColecaoRegioes,
        Constantes.fireBaseDocumentoLiberarEstados,
        dados);
    return retorno;
  }
}
