import 'package:flutter/material.dart';
import 'package:geoli/Uteis/paleta_cores.dart';

class Constantes {
  //ROTAS
  static const rotaTelaInicial = "telaIncial";
  static const rotaTelaSistemaSolar = "telaSistemaSolar";

  // ROTA REGIOES
  static const rotaTelaSplashScreen = "telaSplashScreen";
  static const rotaTelaInicialRegioes = "telaIncialRegioes";
  static const rotaTelaRegiaoCentroOeste = "telaRegiaoCentroOeste";
  static const rotaTelaRegiaoSul = "telaRegiaoSul";
  static const rotaTelaRegiaoSudeste = "telaRegiaoSudeste";
  static const rotaTelaRegiaoNorte = "telaRegiaoNorte";
  static const rotaTelaRegiaoNordeste = "telaRegiaoNordeste";
  static const rotaTelaRegiaoTodosEstados = "telaRegiaoTodosEstados";

  //TEMPO DE JOGO DO SISTEMA SOLAR
  static const int sistemaSolarTempoFacil = 60;
  static const int sistemaSolarTempoMedio = 40;
  static const int sistemaSolarTempoDificl = 25;

  //NOME DOCUMENTO FIBASE REGIOES
  static const fireBaseColecaoRegioes = "regioes";
  static const fireBaseDocumentoRegiaoCentroOeste = "regiaoCentroOeste";
  static const fireBaseDocumentoRegiaoSul = "regiaoSul";
  static const fireBaseDocumentoRegiaoSudeste = "regiaoSudeste";
  static const fireBaseDocumentoRegiaoNorte = "regiaoNorte";
  static const fireBaseDocumentoRegiaoNordeste = "regiaoNordeste";
  static const fireBaseDocumentoRegiaoTodosEstados = "regiaoTodosEstados";
  static const fireBaseDocumentoLiberarEstados = "liberarEstados";
  static const fireBaseDocumentoPontosJogadaRegioes = "postosJogadaRegioes";
  static const nomeTodosEstados = "todosEstados";

  static const fireBaseColecaoSistemaSolar = "sistemaSolar";
  static const fireBaseDocumentoPontosJogadaSistemaSolar =
      "pontosJogadaSistemaSolar";

  //STATUS PARA ANIMAR OS BALOES
  static const statusAnimacaoIniciar = "iniciarAnimacao";
  static const statusAnimacaoPausada = "pausarAnimacao";
  static const statusAnimacaoRetomar = "RetomarAnimacao";

  static const resetarAcaoExcluirTudo = "excluirTudo";
  static const resetarAcaoExcluirRegioes = "excluirRegioes";
  static const resetarAcaoExcluirSistemaSolar = "excluirSistemaSolar";

  static const statusTutorialAtivo = "Tutorial Ativo";
  static const  statusTutorialDesativado = "Tutorial Desativado";

  static Color corPadraoRegioes = PaletaCores.corLaranja;

  static const pontosJogada = "pontosJogada";
  static const msgErroAcertoGesto = "Errou";
  static const msgAcertoGesto = "Acertou";
}
