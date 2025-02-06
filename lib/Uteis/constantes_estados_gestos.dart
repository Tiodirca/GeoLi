import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/constantes_caminhos_imagens.dart';

class ConstantesEstadosGestos {
  // REGIAO CENTRO OESTE
  static Estado estadoGO = Estado(
      nome: Constantes.nomeRegiaoCentroGO,
      caminhoImagem: CaminhosImagens.regiaoCentroGOImagem,
      acerto: false);
  static Estado estadoMT = Estado(
      nome: Constantes.nomeRegiaoCentroMT,
      caminhoImagem: CaminhosImagens.regiaoCentroMTImagem,
      acerto: false);
  static Estado estadoMS = Estado(
      nome: Constantes.nomeRegiaoCentroMS,
      caminhoImagem: CaminhosImagens.regiaoCentroMSImagem,
      acerto: false);

  //GESTOS CENTRO OESTE
  static Gestos gestoGO = Gestos(
      nomeGesto: Constantes.nomeRegiaoCentroGO,
      nomeImagem: CaminhosImagens.gestoCentroGO);
  static Gestos gestoMT = Gestos(
      nomeGesto: Constantes.nomeRegiaoCentroMT,
      nomeImagem: CaminhosImagens.gestoCentroMT);
  static Gestos gestoMS = Gestos(
      nomeGesto: Constantes.nomeRegiaoCentroMS,
      nomeImagem: CaminhosImagens.gestoCentroMS);

  // REGIAO SUL
  static Estado estadoPR = Estado(
      nome: Constantes.nomeRegiaoSulPR,
      caminhoImagem: CaminhosImagens.regiaoSulPRImagem,
      acerto: false);
  static Estado estadoRS = Estado(
      nome: Constantes.nomeRegiaoSulRS,
      caminhoImagem: CaminhosImagens.regiaoSulRSImagem,
      acerto: false);
  static Estado estadoSC = Estado(
      nome: Constantes.nomeRegiaoSulSC,
      caminhoImagem: CaminhosImagens.regiaoSulSCImagem,
      acerto: false);

  // GESTOS SUL
  static Gestos gestoPR = Gestos(
      nomeGesto: Constantes.nomeRegiaoSulPR,
      nomeImagem: CaminhosImagens.gestoSulPR);
  static Gestos gestoRS = Gestos(
      nomeGesto: Constantes.nomeRegiaoSulRS,
      nomeImagem: CaminhosImagens.gestoSulRS);
  static Gestos gestoSC = Gestos(
      nomeGesto: Constantes.nomeRegiaoSulSC,
      nomeImagem: CaminhosImagens.gestoSulSC);

  //REGIAO SUDESTE
  static Estado estadoSP = Estado(
      nome: Constantes.nomeRegiaoSudesteSP,
      caminhoImagem: CaminhosImagens.regiaoSudesteSPImagem,
      acerto: false);
  static Estado estadoRJ = Estado(
      nome: Constantes.nomeRegiaoSudesteRJ,
      caminhoImagem: CaminhosImagens.regiaoSudesteRJImagem,
      acerto: false);
  static Estado estadoES = Estado(
      nome: Constantes.nomeRegiaoSudesteES,
      caminhoImagem: CaminhosImagens.regiaoSudesteESImagem,
      acerto: false);
  static Estado estadoMG = Estado(
      nome: Constantes.nomeRegiaoSudesteMG,
      caminhoImagem: CaminhosImagens.regiaoSudesteMGImagem,
      acerto: false);

  // GESTOS SUDESTE
  static Gestos gestoSP = Gestos(
      nomeGesto: Constantes.nomeRegiaoSudesteSP,
      nomeImagem: CaminhosImagens.gestoSudesteSP);
  static Gestos gestoRJ = Gestos(
      nomeGesto: Constantes.nomeRegiaoSudesteRJ,
      nomeImagem: CaminhosImagens.gestoSudesteRJ);
  static Gestos gestoES = Gestos(
      nomeGesto: Constantes.nomeRegiaoSudesteES,
      nomeImagem: CaminhosImagens.gestoSudesteES);
  static Gestos gestoMG = Gestos(
      nomeGesto: Constantes.nomeRegiaoSudesteMG,
      nomeImagem: CaminhosImagens.gestoSudesteMG);

  //REGIAO NORTE
  static Estado estadoAC = Estado(
      nome: Constantes.nomeRegiaoNorteAC,
      caminhoImagem: CaminhosImagens.regiaoNorteACImagem,
      acerto: false);
  static Estado estadoAP = Estado(
      nome: Constantes.nomeRegiaoNorteAP,
      caminhoImagem: CaminhosImagens.regiaoNorteAPImagem,
      acerto: false);
  static Estado estadoAM = Estado(
      nome: Constantes.nomeRegiaoNorteAM,
      caminhoImagem: CaminhosImagens.regiaoNorteAMImagem,
      acerto: false);
  static Estado estadoPA = Estado(
      nome: Constantes.nomeRegiaoNortePA,
      caminhoImagem: CaminhosImagens.regiaoNortePAImagem,
      acerto: false);
  static Estado estadoRO = Estado(
      nome: Constantes.nomeRegiaoNorteRO,
      caminhoImagem: CaminhosImagens.regiaoNorteROImagem,
      acerto: false);
  static Estado estadoRR = Estado(
      nome: Constantes.nomeRegiaoNorteRR,
      caminhoImagem: CaminhosImagens.regiaoNorteRRImagem,
      acerto: false);
  static Estado estadoTO = Estado(
      nome: Constantes.nomeRegiaoNorteTO,
      caminhoImagem: CaminhosImagens.regiaoNorteTOImagem,
      acerto: false);

  //GESTOS NORTE
  static Gestos gestoAC = Gestos(
      nomeGesto: Constantes.nomeRegiaoNorteAC,
      nomeImagem: CaminhosImagens.gestoNorteACImagem);
  static Gestos gestoAP = Gestos(
      nomeGesto: Constantes.nomeRegiaoNorteAP,
      nomeImagem: CaminhosImagens.gestoNorteACImagem);
  static Gestos gestoAM = Gestos(
      nomeGesto: Constantes.nomeRegiaoNorteAM,
      nomeImagem: CaminhosImagens.gestoNorteAMImagem);
  static Gestos gestoPA = Gestos(
      nomeGesto: Constantes.nomeRegiaoNortePA,
      nomeImagem: CaminhosImagens.gestoNortePAImagem);
  static Gestos gestoRO = Gestos(
      nomeGesto: Constantes.nomeRegiaoNorteRO,
      nomeImagem: CaminhosImagens.gestoNorteROImagem);
  static Gestos gestoRR = Gestos(
      nomeGesto: Constantes.nomeRegiaoNorteRR,
      nomeImagem: CaminhosImagens.gestoNorteRRImagem);
  static Gestos gestoTO = Gestos(
      nomeGesto: Constantes.nomeRegiaoNorteTO,
      nomeImagem: CaminhosImagens.gestoNorteTOImagem);

  //REGIAO NORDESTE
  static Estado estadoAL = Estado(
      nome: Constantes.nomeRegiaoNordesteAL,
      caminhoImagem: CaminhosImagens.regiaoNordesteALImagem,
      acerto: false);
  static Estado estadoBA = Estado(
      nome: Constantes.nomeRegiaoNordesteBA,
      caminhoImagem: CaminhosImagens.regiaoNordesteBAImagem,
      acerto: false);
  static Estado estadoCE = Estado(
      nome: Constantes.nomeRegiaoNordesteCE,
      caminhoImagem: CaminhosImagens.regiaoNordesteCEImagem,
      acerto: false);
  static Estado estadoMA = Estado(
      nome: Constantes.nomeRegiaoNordesteMA,
      caminhoImagem: CaminhosImagens.regiaoNordesteMAImagem,
      acerto: false);
  static Estado estadoPB = Estado(
      nome: Constantes.nomeRegiaoNordestePB,
      caminhoImagem: CaminhosImagens.regiaoNordestePBImagem,
      acerto: false);
  static Estado estadoPE = Estado(
      nome: Constantes.nomeRegiaoNordestePE,
      caminhoImagem: CaminhosImagens.regiaoNordestePEImagem,
      acerto: false);
  static Estado estadoPI = Estado(
      nome: Constantes.nomeRegiaoNordestePI,
      caminhoImagem: CaminhosImagens.regiaoNordestePIImagem,
      acerto: false);
  static Estado estadoRN = Estado(
      nome: Constantes.nomeRegiaoNordesteRN,
      caminhoImagem: CaminhosImagens.regiaoNordesteRNImagem,
      acerto: false);
  static Estado estadoSE = Estado(
      nome: Constantes.nomeRegiaoNordesteSE,
      caminhoImagem: CaminhosImagens.regiaoNordesteSEImagem,
      acerto: false);

  //GESTOS NORDESTE
  static Gestos gestoAL = Gestos(
      nomeGesto: Constantes.nomeRegiaoNordesteAL,
      nomeImagem: CaminhosImagens.gestoNordesteALImagem);
  static Gestos gestoBA = Gestos(
      nomeGesto: Constantes.nomeRegiaoNordesteBA,
      nomeImagem: CaminhosImagens.gestoNordesteBAImagem);
  static Gestos gestoCE = Gestos(
      nomeGesto: Constantes.nomeRegiaoNordesteCE,
      nomeImagem: CaminhosImagens.gestoNordesteCEImagem);
  static Gestos gestoMA = Gestos(
      nomeGesto: Constantes.nomeRegiaoNordesteMA,
      nomeImagem: CaminhosImagens.gestoNordesteMAImagem);
  static Gestos gestoPB = Gestos(
      nomeGesto: Constantes.nomeRegiaoNordestePB,
      nomeImagem: CaminhosImagens.gestoNordestePBImagem);
  static Gestos gestoPE = Gestos(
      nomeGesto: Constantes.nomeRegiaoNordestePE,
      nomeImagem: CaminhosImagens.gestoNordestePEImagem);
  static Gestos gestoPI = Gestos(
      nomeGesto: Constantes.nomeRegiaoNordestePI,
      nomeImagem: CaminhosImagens.gestoNordestePIImagem);
  static Gestos gestoRN = Gestos(
      nomeGesto: Constantes.nomeRegiaoNordesteRN,
      nomeImagem: CaminhosImagens.gestoNordesteRNImagem);
  static Gestos gestoSE = Gestos(
      nomeGesto: Constantes.nomeRegiaoNordesteSE,
      nomeImagem: CaminhosImagens.gestoNordesteSEImagem);
}
