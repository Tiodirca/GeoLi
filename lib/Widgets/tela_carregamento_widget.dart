import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Uteis/textos.dart';

class TelaCarregamentoWidget extends StatefulWidget {
  const TelaCarregamentoWidget(
      {super.key,
      required this.corPadrao,
      required this.exibirMensagemConexao});

  final Color corPadrao;
  final bool exibirMensagemConexao;

  @override
  State<TelaCarregamentoWidget> createState() => _TelaCarregamentoWidgetState();
}

class _TelaCarregamentoWidgetState extends State<TelaCarregamentoWidget> {
  late Timer iniciarTempo;
  int tempo = 10;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  recarregarTela() async {
    String telaAtual = await MetodosAuxiliares.recuperarTelaAtualErroConexao();
    if (telaAtual == Constantes.rotaTelaInicial) {
      Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
    } else if (telaAtual == Constantes.rotaTelaInicialRegioes) {
      Navigator.pushReplacementNamed(
          context, Constantes.rotaTelaInicialRegioes);
    } else if (telaAtual == Constantes.rotaTelaRegiaoCentroOeste) {
      Navigator.pushReplacementNamed(
          context, Constantes.rotaTelaRegiaoCentroOeste);
    } else if (telaAtual == Constantes.rotaTelaRegiaoSul) {
      Navigator.pushReplacementNamed(context, Constantes.rotaTelaRegiaoSul);
    } else if (telaAtual == Constantes.rotaTelaRegiaoSudeste) {
      Navigator.pushReplacementNamed(context, Constantes.rotaTelaRegiaoSudeste);
    } else if (telaAtual == Constantes.rotaTelaRegiaoNorte) {
      Navigator.pushReplacementNamed(context, Constantes.rotaTelaRegiaoNorte);
    } else if (telaAtual == Constantes.rotaTelaRegiaoNordeste) {
      Navigator.pushReplacementNamed(
          context, Constantes.rotaTelaRegiaoNordeste);
    } else if (telaAtual == Constantes.rotaTelaRegiaoTodosEstados) {
      Navigator.pushReplacementNamed(
          context, Constantes.rotaTelaRegiaoTodosEstados);
    } else if (telaAtual == Constantes.rotaTelaSistemaSolar) {
      Navigator.pushReplacementNamed(context, Constantes.rotaTelaSistemaSolar);
    } else if (telaAtual == Constantes.rotaTelaUsuarioDetalhado) {
      Navigator.pushReplacementNamed(
          context, Constantes.rotaTelaUsuarioDetalhado);
    }
  }

  desconetarUsuario() async {
    await FirebaseAuth.instance.signOut();
    MetodosAuxiliares.passarUidUsuario("");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constantes.sharedPreferencesEmail, "");
    prefs.setString(Constantes.sharedPreferencesSenha, "");
    prefs.setString(Constantes.sharedPreferencesUID, "");
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaLoginCadastro);
  }


  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaTela = MediaQuery.of(context).size.height;
    return Container(
        padding: const EdgeInsets.all(10),
        width: larguraTela,
        height: alturaTela,
        color: Colors.white,
        child: Center(
          child: SizedBox(
            width: kIsWeb
                ? larguraTela * 0.4
                : Platform.isAndroid || Platform.isIOS
                    ? larguraTela * 0.9
                    : larguraTela * 0.3,
            height: widget.exibirMensagemConexao == true ? 400 : 150,
            child: Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: widget.corPadrao),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              color: Colors.white,
              child: Center(child: LayoutBuilder(
                builder: (context, constraints) {
                  if (widget.exibirMensagemConexao) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              Textos.erroSemInternetAvisoTelaCarregamento,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(
                              Icons.signal_wifi_connected_no_internet_4,
                              color: PaletaCores.corVermelha,
                              size: 50,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 120,
                                child: FloatingActionButton(
                                  elevation: 0,
                                  heroTag: Textos.btnSair,
                                  backgroundColor: Colors.white,
                                  onPressed: () {
                                    desconetarUsuario();
                                  },
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: PaletaCores.corVermelha,
                                          width: 1),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(30))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                        height: 70,
                                        width: 70,
                                        image: AssetImage(
                                            "${CaminhosImagens.gestoSair}.png"),
                                      ),
                                      Text(
                                        Textos.btnSair,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 140,
                                height: 150,
                                child: FloatingActionButton(
                                  elevation: 0,
                                  heroTag: Textos.btnRecarregarTelaNovamente,
                                  backgroundColor: Colors.white,
                                  onPressed: () {
                                    recarregarTela();
                                  },
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: widget.corPadrao, width: 1),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(40))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                        height: 90,
                                        width: 90,
                                        image: AssetImage(
                                            "${CaminhosImagens.btnNovamenteGesto}.png"),
                                      ),
                                      Text(
                                        Textos.btnRecarregarTelaNovamente,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Textos.txtTelaCarregamento,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(widget.corPadrao),
                          strokeWidth: 3.0,
                        )
                      ],
                    );
                  }
                },
              )),
            ),
          ),
        ));
  }
}
