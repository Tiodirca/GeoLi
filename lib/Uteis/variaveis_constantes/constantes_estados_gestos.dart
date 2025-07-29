import 'package:flutter/material.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/textos.dart';

class ConstantesEstadosGestos {
  static Color corPadraoRegioes = PaletaCores.corLaranja;

  static const tipoAcaoCadastroRegioes = "pontuacao";
  static const tipoAcaoCadastroRegioesLiberarNiveis = "liberarNiveis";

  static adicionarEstadosGestos() {
    Map<Estado, Gestos> estadoGestoMap = {};
    estadoGestoMap[ConstantesEstadosGestos.estadoMS] =
        ConstantesEstadosGestos.gestoMS;
    estadoGestoMap[ConstantesEstadosGestos.estadoGO] =
        ConstantesEstadosGestos.gestoGO;
    estadoGestoMap[ConstantesEstadosGestos.estadoMT] =
        ConstantesEstadosGestos.gestoMT;
    estadoGestoMap[ConstantesEstadosGestos.estadoRS] =
        ConstantesEstadosGestos.gestoRS;
    estadoGestoMap[ConstantesEstadosGestos.estadoSC] =
        ConstantesEstadosGestos.gestoSC;
    estadoGestoMap[ConstantesEstadosGestos.estadoPR] =
        ConstantesEstadosGestos.gestoPR;
    estadoGestoMap[ConstantesEstadosGestos.estadoMG] =
        ConstantesEstadosGestos.gestoMG;
    estadoGestoMap[ConstantesEstadosGestos.estadoES] =
        ConstantesEstadosGestos.gestoES;
    estadoGestoMap[ConstantesEstadosGestos.estadoSP] =
        ConstantesEstadosGestos.gestoSP;
    estadoGestoMap[ConstantesEstadosGestos.estadoRJ] =
        ConstantesEstadosGestos.gestoRJ;
    estadoGestoMap[ConstantesEstadosGestos.estadoAC] =
        ConstantesEstadosGestos.gestoAC;
    estadoGestoMap[ConstantesEstadosGestos.estadoAP] =
        ConstantesEstadosGestos.gestoAP;
    estadoGestoMap[ConstantesEstadosGestos.estadoAM] =
        ConstantesEstadosGestos.gestoAM;
    estadoGestoMap[ConstantesEstadosGestos.estadoPA] =
        ConstantesEstadosGestos.gestoPA;
    estadoGestoMap[ConstantesEstadosGestos.estadoRO] =
        ConstantesEstadosGestos.gestoRO;
    estadoGestoMap[ConstantesEstadosGestos.estadoRR] =
        ConstantesEstadosGestos.gestoRR;
    estadoGestoMap[ConstantesEstadosGestos.estadoTO] =
        ConstantesEstadosGestos.gestoTO;
    estadoGestoMap[ConstantesEstadosGestos.estadoAL] =
        ConstantesEstadosGestos.gestoAL;
    estadoGestoMap[ConstantesEstadosGestos.estadoBA] =
        ConstantesEstadosGestos.gestoBA;
    estadoGestoMap[ConstantesEstadosGestos.estadoCE] =
        ConstantesEstadosGestos.gestoCE;
    estadoGestoMap[ConstantesEstadosGestos.estadoMA] =
        ConstantesEstadosGestos.gestoMA;
    estadoGestoMap[ConstantesEstadosGestos.estadoPB] =
        ConstantesEstadosGestos.gestoPB;
    estadoGestoMap[ConstantesEstadosGestos.estadoPE] =
        ConstantesEstadosGestos.gestoPE;
    estadoGestoMap[ConstantesEstadosGestos.estadoPI] =
        ConstantesEstadosGestos.gestoPI;
    estadoGestoMap[ConstantesEstadosGestos.estadoRN] =
        ConstantesEstadosGestos.gestoRN;
    estadoGestoMap[ConstantesEstadosGestos.estadoSE] =
        ConstantesEstadosGestos.gestoSE;
    return estadoGestoMap;
  }

  // REGIAO CENTRO OESTE
  static Estado estadoGO = Estado(
      nome: Textos.nomeRegiaoCentroGO,
      caminhoImagem: CaminhosImagens.regiaoCentroGOImagem,
      acerto: false);
  static Estado estadoMT = Estado(
      nome: Textos.nomeRegiaoCentroMT,
      caminhoImagem: CaminhosImagens.regiaoCentroMTImagem,
      acerto: false);
  static Estado estadoMS = Estado(
      nome: Textos.nomeRegiaoCentroMS,
      caminhoImagem: CaminhosImagens.regiaoCentroMSImagem,
      acerto: false);

  //GESTOS CENTRO OESTE
  static Gestos gestoGO = Gestos(
      nomeGesto: Textos.nomeRegiaoCentroGO,
      nomeImagem: CaminhosImagens.gestoCentroGO);
  static Gestos gestoMT = Gestos(
      nomeGesto: Textos.nomeRegiaoCentroMT,
      nomeImagem: CaminhosImagens.gestoCentroMT);
  static Gestos gestoMS = Gestos(
      nomeGesto: Textos.nomeRegiaoCentroMS,
      nomeImagem: CaminhosImagens.gestoCentroMS);

  // REGIAO SUL
  static Estado estadoPR = Estado(
      nome: Textos.nomeRegiaoSulPR,
      caminhoImagem: CaminhosImagens.regiaoSulPRImagem,
      acerto: false);
  static Estado estadoRS = Estado(
      nome: Textos.nomeRegiaoSulRS,
      caminhoImagem: CaminhosImagens.regiaoSulRSImagem,
      acerto: false);
  static Estado estadoSC = Estado(
      nome: Textos.nomeRegiaoSulSC,
      caminhoImagem: CaminhosImagens.regiaoSulSCImagem,
      acerto: false);

  // GESTOS SUL
  static Gestos gestoPR = Gestos(
      nomeGesto: Textos.nomeRegiaoSulPR,
      nomeImagem: CaminhosImagens.gestoSulPR);
  static Gestos gestoRS = Gestos(
      nomeGesto: Textos.nomeRegiaoSulRS,
      nomeImagem: CaminhosImagens.gestoSulRS);
  static Gestos gestoSC = Gestos(
      nomeGesto: Textos.nomeRegiaoSulSC,
      nomeImagem: CaminhosImagens.gestoSulSC);

  //REGIAO SUDESTE
  static Estado estadoSP = Estado(
      nome: Textos.nomeRegiaoSudesteSP,
      caminhoImagem: CaminhosImagens.regiaoSudesteSPImagem,
      acerto: false);
  static Estado estadoRJ = Estado(
      nome: Textos.nomeRegiaoSudesteRJ,
      caminhoImagem: CaminhosImagens.regiaoSudesteRJImagem,
      acerto: false);
  static Estado estadoES = Estado(
      nome: Textos.nomeRegiaoSudesteES,
      caminhoImagem: CaminhosImagens.regiaoSudesteESImagem,
      acerto: false);
  static Estado estadoMG = Estado(
      nome: Textos.nomeRegiaoSudesteMG,
      caminhoImagem: CaminhosImagens.regiaoSudesteMGImagem,
      acerto: false);

  // GESTOS SUDESTE
  static Gestos gestoSP = Gestos(
      nomeGesto: Textos.nomeRegiaoSudesteSP,
      nomeImagem: CaminhosImagens.gestoSudesteSP);
  static Gestos gestoRJ = Gestos(
      nomeGesto: Textos.nomeRegiaoSudesteRJ,
      nomeImagem: CaminhosImagens.gestoSudesteRJ);
  static Gestos gestoES = Gestos(
      nomeGesto: Textos.nomeRegiaoSudesteES,
      nomeImagem: CaminhosImagens.gestoSudesteES);
  static Gestos gestoMG = Gestos(
      nomeGesto: Textos.nomeRegiaoSudesteMG,
      nomeImagem: CaminhosImagens.gestoSudesteMG);

  //REGIAO NORTE
  static Estado estadoAC = Estado(
      nome: Textos.nomeRegiaoNorteAC,
      caminhoImagem: CaminhosImagens.regiaoNorteACImagem,
      acerto: false);
  static Estado estadoAP = Estado(
      nome: Textos.nomeRegiaoNorteAP,
      caminhoImagem: CaminhosImagens.regiaoNorteAPImagem,
      acerto: false);
  static Estado estadoAM = Estado(
      nome: Textos.nomeRegiaoNorteAM,
      caminhoImagem: CaminhosImagens.regiaoNorteAMImagem,
      acerto: false);
  static Estado estadoPA = Estado(
      nome: Textos.nomeRegiaoNortePA,
      caminhoImagem: CaminhosImagens.regiaoNortePAImagem,
      acerto: false);
  static Estado estadoRO = Estado(
      nome: Textos.nomeRegiaoNorteRO,
      caminhoImagem: CaminhosImagens.regiaoNorteROImagem,
      acerto: false);
  static Estado estadoRR = Estado(
      nome: Textos.nomeRegiaoNorteRR,
      caminhoImagem: CaminhosImagens.regiaoNorteRRImagem,
      acerto: false);
  static Estado estadoTO = Estado(
      nome: Textos.nomeRegiaoNorteTO,
      caminhoImagem: CaminhosImagens.regiaoNorteTOImagem,
      acerto: false);

  //GESTOS NORTE
  static Gestos gestoAC = Gestos(
      nomeGesto: Textos.nomeRegiaoNorteAC,
      nomeImagem: CaminhosImagens.gestoNorteACImagem);
  static Gestos gestoAP = Gestos(
      nomeGesto: Textos.nomeRegiaoNorteAP,
      nomeImagem: CaminhosImagens.gestoNorteAPImagem);
  static Gestos gestoAM = Gestos(
      nomeGesto: Textos.nomeRegiaoNorteAM,
      nomeImagem: CaminhosImagens.gestoNorteAMImagem);
  static Gestos gestoPA = Gestos(
      nomeGesto: Textos.nomeRegiaoNortePA,
      nomeImagem: CaminhosImagens.gestoNortePAImagem);
  static Gestos gestoRO = Gestos(
      nomeGesto: Textos.nomeRegiaoNorteRO,
      nomeImagem: CaminhosImagens.gestoNorteROImagem);
  static Gestos gestoRR = Gestos(
      nomeGesto: Textos.nomeRegiaoNorteRR,
      nomeImagem: CaminhosImagens.gestoNorteRRImagem);
  static Gestos gestoTO = Gestos(
      nomeGesto: Textos.nomeRegiaoNorteTO,
      nomeImagem: CaminhosImagens.gestoNorteTOImagem);

  //REGIAO NORDESTE
  static Estado estadoAL = Estado(
      nome: Textos.nomeRegiaoNordesteAL,
      caminhoImagem: CaminhosImagens.regiaoNordesteALImagem,
      acerto: false);
  static Estado estadoBA = Estado(
      nome: Textos.nomeRegiaoNordesteBA,
      caminhoImagem: CaminhosImagens.regiaoNordesteBAImagem,
      acerto: false);
  static Estado estadoCE = Estado(
      nome: Textos.nomeRegiaoNordesteCE,
      caminhoImagem: CaminhosImagens.regiaoNordesteCEImagem,
      acerto: false);
  static Estado estadoMA = Estado(
      nome: Textos.nomeRegiaoNordesteMA,
      caminhoImagem: CaminhosImagens.regiaoNordesteMAImagem,
      acerto: false);
  static Estado estadoPB = Estado(
      nome: Textos.nomeRegiaoNordestePB,
      caminhoImagem: CaminhosImagens.regiaoNordestePBImagem,
      acerto: false);
  static Estado estadoPE = Estado(
      nome: Textos.nomeRegiaoNordestePE,
      caminhoImagem: CaminhosImagens.regiaoNordestePEImagem,
      acerto: false);
  static Estado estadoPI = Estado(
      nome: Textos.nomeRegiaoNordestePI,
      caminhoImagem: CaminhosImagens.regiaoNordestePIImagem,
      acerto: false);
  static Estado estadoRN = Estado(
      nome: Textos.nomeRegiaoNordesteRN,
      caminhoImagem: CaminhosImagens.regiaoNordesteRNImagem,
      acerto: false);
  static Estado estadoSE = Estado(
      nome: Textos.nomeRegiaoNordesteSE,
      caminhoImagem: CaminhosImagens.regiaoNordesteSEImagem,
      acerto: false);

  //GESTOS NORDESTE
  static Gestos gestoAL = Gestos(
      nomeGesto: Textos.nomeRegiaoNordesteAL,
      nomeImagem: CaminhosImagens.gestoNordesteALImagem);
  static Gestos gestoBA = Gestos(
      nomeGesto: Textos.nomeRegiaoNordesteBA,
      nomeImagem: CaminhosImagens.gestoNordesteBAImagem);
  static Gestos gestoCE = Gestos(
      nomeGesto: Textos.nomeRegiaoNordesteCE,
      nomeImagem: CaminhosImagens.gestoNordesteCEImagem);
  static Gestos gestoMA = Gestos(
      nomeGesto: Textos.nomeRegiaoNordesteMA,
      nomeImagem: CaminhosImagens.gestoNordesteMAImagem);
  static Gestos gestoPB = Gestos(
      nomeGesto: Textos.nomeRegiaoNordestePB,
      nomeImagem: CaminhosImagens.gestoNordestePBImagem);
  static Gestos gestoPE = Gestos(
      nomeGesto: Textos.nomeRegiaoNordestePE,
      nomeImagem: CaminhosImagens.gestoNordestePEImagem);
  static Gestos gestoPI = Gestos(
      nomeGesto: Textos.nomeRegiaoNordestePI,
      nomeImagem: CaminhosImagens.gestoNordestePIImagem);
  static Gestos gestoRN = Gestos(
      nomeGesto: Textos.nomeRegiaoNordesteRN,
      nomeImagem: CaminhosImagens.gestoNordesteRNImagem);
  static Gestos gestoSE = Gestos(
      nomeGesto: Textos.nomeRegiaoNordesteSE,
      nomeImagem: CaminhosImagens.gestoNordesteSEImagem);
}
