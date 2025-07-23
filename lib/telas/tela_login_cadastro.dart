import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/criar_dados_banco_firebase.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Uteis/validar_login_cadastro_usuario.dart';
import 'package:geoli/Widgets/tela_carregamento_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaLoginCadastro extends StatefulWidget {
  const TelaLoginCadastro({super.key});

  @override
  State<TelaLoginCadastro> createState() => _TelaLoginCadastroState();
}

class _TelaLoginCadastroState extends State<TelaLoginCadastro> {
  bool exibirTelaCarregamento = false;
  bool exibirDadosCadastro = false;
  bool exibirCampos = false;
  bool ocultarSenhaDigitada = true;
  IconData iconeSenhaVisivel = Icons.visibility;
  final _formKeyFormulario = GlobalKey<FormState>();
  TextEditingController campoEmail = TextEditingController(text: "");
  TextEditingController campoSenha = TextEditingController(text: "");
  TextEditingController campoUsuario = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
  }

  chamarValidarLogin() async {
    String retorno = await ValidarLoginCadastroUsuario.fazerLogin(
      campoEmail.text,
      campoSenha.text,
      context,
    );
    if (retorno == Constantes.tipoNotificacaoSucesso) {
      redirecionarTelaInicial();
    } else {
      setState(() {
        exibirTelaCarregamento = false;
      });
      chamarValidarErro(retorno);
    }
  }

  chamarValidarCriarCadastro() async {
    String retorno = await ValidarLoginCadastroUsuario.criarCadastro(
      campoEmail.text,
      campoSenha.text,
      campoUsuario.text,
      context,
    );
    if (retorno == Constantes.tipoNotificacaoSucesso) {
      print("FOI");
      redirecionarTelaInicial();
    } else {
      setState(() {
        exibirTelaCarregamento = false;
        chamarValidarErro(retorno);
      });
    }
  }

  chamarValidarErro(String erro) {
    MetodosAuxiliares.validarErro(erro, context);
  }

  redirecionarTelaLoginCadastro() {
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaLoginCadastro);
  }

  redirecionarTelaInicial() {
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
  }

  validarTamanhoCampos(double largura) {
    if (largura <= 600) {
      return 250.0;
    } else if (largura > 600) {
      return 300.0;
    }
  }

  validarTamanhoGestos(double largura) {
    if (largura <= 600) {
      return 70.0;
    } else if (largura > 600 && largura <= 1000) {
      return 90.0;
    } else if (largura > 1000) {
      return 100.0;
    }
  }

  validarTamanhoLarguraBotao(double largura) {
    if (largura <= 600) {
      return 120.0;
    } else if (largura > 600 && largura <= 1000) {
      return 120.0;
    } else if (largura > 1000) {
      return 140.0;
    }
  }

  validarTamanhoAlturaBotao(double largula) {
    if (largula <= 600) {
      return 130.0;
    } else if (largula > 600 && largula <= 1000) {
      return 150.0;
    } else if (largula > 1000) {
      return 170.0;
    }
  }


  Widget campos(TextEditingController controle, String nomeCampo,
          String nomeImagem,double largura) =>
      Container(
          margin: EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                height: MetodosAuxiliares.validarTamanhoGestos(largura),
                width:MetodosAuxiliares.validarTamanhoGestos(largura),
                image: AssetImage("$nomeImagem.png"),
              ),
              SizedBox(
                width: validarTamanhoCampos(largura),
                height: 80,
                child: TextFormField(
                  controller: controle,
                  obscureText: nomeCampo == Textos.campoEmail ||
                          nomeCampo == Textos.campoUsuario
                      ? false
                      : ocultarSenhaDigitada,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return Textos.erroCampoVazio;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: nomeCampo,
                      suffixIcon: nomeCampo == Textos.campoEmail ||
                              nomeCampo == Textos.campoUsuario
                          ? null
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  if (ocultarSenhaDigitada) {
                                    setState(() {
                                      ocultarSenhaDigitada = false;
                                      iconeSenhaVisivel = Icons.visibility_off;
                                    });
                                  } else {
                                    setState(() {
                                      ocultarSenhaDigitada = true;
                                      iconeSenhaVisivel = Icons.visibility;
                                    });
                                  }
                                });
                              },
                              icon: Icon(iconeSenhaVisivel)),
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              width: 1, color: PaletaCores.corVerde)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              width: 1, color: PaletaCores.corVerde)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              width: 1, color: PaletaCores.corVermelha)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              width: 1, color: PaletaCores.corVermelha))),
                ),
              )
            ],
          ));

  Widget cartaoBtn(String nomeImagem, String nomeBtn,double largura) => Container(
        margin: EdgeInsets.all(10),
        width: MetodosAuxiliares.validarTamanhoLarguraBotao(largura),
        height: MetodosAuxiliares.validarTamanhoAlturaBotao(largura),
        child: FloatingActionButton(
          elevation: 0,
          heroTag: nomeBtn,
          backgroundColor: Colors.white,
          onPressed: () {
            if (nomeBtn == Textos.btnAcessar) {
              setState(() {
                exibirCampos = true;
                exibirDadosCadastro = false;
              });
            } else if (nomeBtn == Textos.btnCadastrar) {
              setState(() {
                exibirCampos = true;
                exibirDadosCadastro = true;
              });
            } else if (nomeBtn == Textos.btnEntrar) {
              if (_formKeyFormulario.currentState!.validate()) {
                if (exibirDadosCadastro) {
                  chamarValidarCriarCadastro();
                  setState(() {
                    exibirTelaCarregamento = true;
                  });
                } else {
                  setState(() {
                    exibirTelaCarregamento = true;
                  });
                  chamarValidarLogin();
                }
              }
            }
          },
          shape: RoundedRectangleBorder(
              side: BorderSide(color: PaletaCores.corVerde, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(30))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                height: MetodosAuxiliares.validarTamanhoGestos(largura),
                width: MetodosAuxiliares.validarTamanhoGestos(largura),
                image: AssetImage("$nomeImagem.png"),
              ),
              Text(
                nomeBtn,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    Timer(Duration(seconds: 2), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    });
    return LayoutBuilder(
      builder: (context, constraints) {
        if (exibirTelaCarregamento) {
          return TelaCarregamentoWidget(
            corPadrao: PaletaCores.corVerde,
          );
        } else {
          return Scaffold(
              appBar: AppBar(
                leading: Container(),
                backgroundColor: PaletaCores.corVerde,
                title: Text(
                  Textos.telaLoginCadastroTitulo,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              body: GestureDetector(
                child: Container(
                    color: Colors.white,
                    width: larguraTela,
                    height: alturaTela,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                bottom: 10, right: 10, left: 10),
                            child: Text(
                              Textos.telaLoginCadastroDescricao,
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Visibility(
                              visible: exibirCampos,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Form(
                                      key: _formKeyFormulario,
                                      child: SizedBox(
                                        width: 500,
                                        height: 350,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Visibility(
                                                  visible: exibirDadosCadastro,
                                                  child: campos(
                                                      campoUsuario,
                                                      Textos.campoUsuario,
                                                      CaminhosImagens.gestoNome,larguraTela)),
                                              campos(campoEmail, Textos.campoEmail,
                                                  CaminhosImagens.gestoEmail,larguraTela),
                                              campos(campoSenha, Textos.campoSenha,
                                                  CaminhosImagens.gestoSenha,larguraTela),
                                            ],
                                          ),
                                        ),
                                      )),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: cartaoBtn(
                                        CaminhosImagens.gestoEntrar,
                                        Textos.btnEntrar,larguraTela),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(top: 10),
                                      width: 40,
                                      height: 40,
                                      child: FloatingActionButton(
                                        backgroundColor: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            exibirCampos = false;
                                            campoSenha.clear();
                                            campoUsuario.clear();
                                            campoEmail.clear();
                                            ocultarSenhaDigitada = true;
                                          });
                                        },
                                        child: Icon(
                                          size: 30,
                                          Icons.close,
                                          color: PaletaCores.corVermelha,
                                        ),
                                      ))
                                ],
                              )),
                          Visibility(
                              visible: !exibirCampos,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  cartaoBtn(CaminhosImagens.gestoEntrar,
                                      Textos.btnAcessar,larguraTela),
                                  cartaoBtn(CaminhosImagens.gestoCadastro,
                                      Textos.btnCadastrar,larguraTela),
                                ],
                              )),
                        ],
                      ),
                    ),),
                onTap: () {
                  if (Platform.isIOS || Platform.isAndroid) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  }
                },
              ));
        }
      },
    );
  }
}
