import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/estilo.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/passar_pegar_dados.dart.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Widgets/tela_carregamento_widget.dart';

class TelaUsuarioDetalhes extends StatefulWidget {
  const TelaUsuarioDetalhes({super.key});

  @override
  State<TelaUsuarioDetalhes> createState() => _TelaUsuarioDetalhesState();
}

class _TelaUsuarioDetalhesState extends State<TelaUsuarioDetalhes> {
  bool exibirTelaCarregamento = true;
  bool ativarCampoUsuario = false;
  bool ativarCampoEmail = false;
  bool ativarCampoSenha = false;
  bool exibirTelaAutenticacao = false;
  bool ocultarSenhaDigitada = true;
  bool exibirOcultarBtnSalvar = false;
  bool exibirAlertaVerificacaoEmail = false;
  bool exibirMensagemSemConexao = false;
  IconData iconeSenhaVisivel = Icons.visibility;
  String emailAuxiliarValidar = "";
  String emailAlterado = "";
  String nomeUsuarioSemAlteracao = "";
  late String uidUsuario;
  Estilo estilo = Estilo();
  final _formKeyFormulario = GlobalKey<FormState>();
  final _formKeySenhaAlerta = GlobalKey<FormState>();
  TextEditingController campoEmail = TextEditingController(text: "");
  TextEditingController campoSenhaAutenticacao =
      TextEditingController(text: "");
  TextEditingController campoSenhaNova = TextEditingController(text: "Agosto");
  TextEditingController campoUsuario = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    recuperarInformacoesUsuario();
  }

  recuperarInformacoesUsuario() async {
    uidUsuario = await PassarPegarDados.recuperarInformacoesUsuario()
        .values
        .elementAt(0);
    campoEmail.text = await PassarPegarDados.recuperarInformacoesUsuario()
        .values
        .elementAt(1);
    recuperarNomeUsuario();
  }

  recuperarNomeUsuario() async {
    var db = FirebaseFirestore.instance;
    //instanciano variavel
    try {
      db
          .collection(Constantes.fireBaseColecaoUsuarios) // passando a colecao
          .doc(
            uidUsuario,
          )
          .get()
          .then((querySnapshot) async {
        // verificando cada item que esta gravado no banco de dados
        querySnapshot.data()!.forEach((key, value) async {
          if (key.toString() == Constantes.fireBaseCampoNomeUsuario) {
            setState(() {
              campoUsuario.text = value;
              nomeUsuarioSemAlteracao = value;
            });
          } else {
            if (value.toString().isNotEmpty) {
              setState(() {
                exibirAlertaVerificacaoEmail = true;
                emailAlterado = value;
              });
            }
          }
        });
        setState(() {
          exibirTelaCarregamento = false;
        });
      }, onError: (e) {
        debugPrint("RPON${e.toString()}");
        MetodosAuxiliares.validarErro(e.toString(), context);
      });
    } catch (e) {
      debugPrint("RP${e.toString()}");
      MetodosAuxiliares.validarErro(e.toString(), context);
    }
  }

  desconetarUsuario() async {
    setState(() {
      exibirTelaCarregamento = true;
    });
    await FirebaseAuth.instance.signOut();
    chamarExibirMensagens(Textos.sucessoDesconectar, Constantes.msgAcerto);
    redirecionarTelaLogin();
  }

  chamarExibirMensagens(String tipoMensagem, String tipoExibicao) {
    MetodosAuxiliares.exibirMensagens(
        tipoMensagem,
        tipoExibicao,
        Constantes.duracaoExibicaoToastLoginCadastro,
        Constantes.larguraToastLoginCadastro,
        context);
  }

  redirecionarTelaLogin() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, Constantes.rotaTelaLoginCadastro);
    });
  }

  recarregarTela() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(
          context, Constantes.rotaTelaUsuarioDetalhado);
    });
  }

  atualizarNomeUsuario() {
    setState(() {
      exibirTelaCarregamento = true;
    });
    Map<String, dynamic> nomeUsuario = {
      Constantes.fireBaseCampoNomeUsuario: campoUsuario.text,
      Constantes.fireBaseCampoEmailAlterado: emailAlterado
    };
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(Constantes.fireBaseColecaoUsuarios)
          .doc(
            uidUsuario,
          )
          .set(nomeUsuario)
          .then((value) {
        chamarExibirMensagens(Textos.sucessoAlterarNome, Constantes.msgAcerto);
        // MetodosAuxiliares.validarAlteracaoEmail(
        //     emailAlterado, campoUsuario.text);
        recarregarTela();
      }, onError: (e) {
        debugPrint("NOME${e.toString()}");
        chamarValidarErro(e.toString());
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  chamarValidarErro(String erro) {
    MetodosAuxiliares.validarErro(erro, context);
  }

  Widget camposInfoUsuario(
          String nomeImagem,
          String nomeCampo,
          double larguraTela,
          TextEditingController controle,
          bool ativarCampo) =>
      Container(
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              height: MetodosAuxiliares.validarTamanhoGestos(larguraTela),
              width: MetodosAuxiliares.validarTamanhoGestos(larguraTela),
              image: AssetImage("$nomeImagem.png"),
            ),
            SizedBox(
              width: MetodosAuxiliares.tamanhoCamposEditText(larguraTela),
              child: TextFormField(
                controller: controle,
                validator: (value) {
                  if (value!.isEmpty) {
                    return Textos.erroCampoVazio;
                  }
                  return null;
                },
                enabled: ativarCampo,
                decoration: InputDecoration(
                  labelText: nomeCampo,
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
            btnIcone(
              Icons.edit,
              PaletaCores.corOuro,
              nomeCampo,
            )
          ],
        ),
      );

  Widget camposSenhaAutenticacao(String nomeImagem, String nomeCampo,
          double larguraTela, TextEditingController controle) =>
      Container(
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              height: MetodosAuxiliares.validarTamanhoGestos(larguraTela),
              width: MetodosAuxiliares.validarTamanhoGestos(larguraTela),
              image: AssetImage("$nomeImagem.png"),
            ),
            SizedBox(
              width: MetodosAuxiliares.tamanhoCamposEditText(larguraTela),
              child: TextFormField(
                controller: controle,
                validator: (value) {
                  if (value!.isEmpty) {
                    return Textos.erroCampoVazio;
                  }
                  return null;
                },
                obscureText: ocultarSenhaDigitada,
                decoration: InputDecoration(
                  labelText: nomeCampo,
                  suffixIcon: IconButton(
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
                ),
              ),
            ),
          ],
        ),
      );

  Widget btnIcone(IconData icone, Color cor, String nomeBtn) => Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        width: 45,
        height: 45,
        child: FloatingActionButton(
          heroTag: nomeBtn,
          elevation: 0,
          backgroundColor: Colors.white,
          shape: OutlineInputBorder(
              borderSide: BorderSide(color: cor, width: 1),
              borderRadius: BorderRadius.circular(15)),
          onPressed: () {
            if (nomeBtn == Textos.campoEmail) {
              setState(() {
                exibirOcultarBtnSalvar = true;
                ativarCampoEmail = true;
                ativarCampoUsuario = false;
              });
            } else if (nomeBtn == Textos.campoUsuario) {
              setState(() {
                exibirOcultarBtnSalvar = true;
                ativarCampoEmail = false;
                ativarCampoUsuario = true;
              });
            } else if (nomeBtn == Textos.btnCancelarEdicao) {
              setState(() {
                exibirOcultarBtnSalvar = false;
                ativarCampoEmail = false;
                ativarCampoUsuario = false;
                exibirTelaAutenticacao = false;
                campoSenhaAutenticacao.text = "";
                campoUsuario.text = nomeUsuarioSemAlteracao;
              });
            }
          },
          child: Icon(
            icone,
            color: Colors.black,
            size: 30,
          ),
        ),
      );

  validarTamanhoLarguraBotao(double larguraTela) {
    double tamanhoCampo = 100.0;
    if (larguraTela <= 400) {
      tamanhoCampo = 120.0;
    } else if (larguraTela > 400 && larguraTela <= 1100) {
      tamanhoCampo = 120.0;
    } else if (larguraTela > 1100) {
      tamanhoCampo = 130.0;
    }
    return tamanhoCampo;
  }

  validarTamanhoAlturaBotao(double larguraTela) {
    double tamanhoCampo = 100.0;
    if (larguraTela <= 400) {
      tamanhoCampo = 100.0;
    } else if (larguraTela > 400 && larguraTela <= 1100) {
      tamanhoCampo = 120.0;
    } else if (larguraTela > 1100) {
      tamanhoCampo = 130.0;
    }
    return tamanhoCampo;
  }

  validarTamanhoGestos(double larguraTela) {
    double tamanhoCampo = 100.0;
    if (larguraTela <= 400) {
      tamanhoCampo = 70.0;
    } else if (larguraTela > 400 && larguraTela <= 800) {
      tamanhoCampo = 80.0;
    } else if (larguraTela > 800 && larguraTela <= 1100) {
      tamanhoCampo = 90.0;
    } else if (larguraTela > 1100) {
      tamanhoCampo = 100.0;
    }
    return tamanhoCampo;
  }

  Widget cartaoBtn(
          String nomeImagem, String nomeBtn, Color cor, double larguraTela) =>
      Container(
        margin: EdgeInsets.all(5),
        height: validarTamanhoAlturaBotao(larguraTela),
        width: validarTamanhoLarguraBotao(larguraTela),
        child: FloatingActionButton(
          elevation: 0,
          heroTag: nomeBtn,
          backgroundColor: Colors.white,
          onPressed: () {
            if (nomeBtn == Textos.btnSalvarAlteracoes) {
              if (ativarCampoUsuario) {
                if (_formKeyFormulario.currentState!.validate()) {
                  atualizarNomeUsuario();
                }
              } else if (ativarCampoEmail) {
                // Validacao quando for ALTERAR EMAIL
                if (_formKeyFormulario.currentState!.validate()) {
                  setState(() {
                    exibirTelaAutenticacao = true;
                  });
                }
              }
            }else if(nomeBtn == Textos.btnAutenticar){

            } else if (nomeBtn == Textos.btnExcluirUsuario) {

            } else if (nomeBtn == Textos.btnSair) {
              desconetarUsuario();
            }
          },
          shape: RoundedRectangleBorder(
              side: BorderSide(color: cor, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                height: validarTamanhoGestos(larguraTela),
                width: validarTamanhoGestos(larguraTela),
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
    return Theme(
        data: estilo.estiloGeral,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (exibirTelaCarregamento) {
              return TelaCarregamentoWidget(
                corPadrao: PaletaCores.corVerde,
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                      color: Colors.white,
                      //setando tamanho do icone
                      iconSize: 30,
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, Constantes.rotaTelaInicial);
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                  backgroundColor: PaletaCores.corVerde,
                  title: Text(
                    Textos.telaUsuarioTitulo,
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
                          child: Form(
                        key: _formKeyFormulario,
                        child: Column(
                          children: [
                            LayoutBuilder(
                              builder: (context, constraints) {
                                if (exibirTelaAutenticacao) {
                                  return Column(
                                    children: [
                                      Text(
                                        Textos.telaUsuarioAutenticacao,
                                        style: TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                      camposSenhaAutenticacao(
                                          CaminhosImagens.gestoSenha,
                                          Textos.campoSenha,
                                          larguraTela,
                                          campoSenhaAutenticacao),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          cartaoBtn(
                                              CaminhosImagens.gestoSalvar,
                                              Textos.btnAutenticar,
                                              PaletaCores.corAzulMagenta,
                                              larguraTela),
                                          btnIcone(
                                              Icons.close,
                                              PaletaCores.corVermelha,
                                              Textos.btnCancelarEdicao),
                                        ],
                                      )
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      Text(
                                        Textos.telaUsuarioDescricao,
                                        style: TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                      camposInfoUsuario(
                                          CaminhosImagens.gestoNome,
                                          Textos.campoUsuario,
                                          larguraTela,
                                          campoUsuario,
                                          ativarCampoUsuario),
                                      camposInfoUsuario(
                                          CaminhosImagens.gestoEmail,
                                          Textos.campoEmail,
                                          larguraTela,
                                          campoEmail,
                                          ativarCampoEmail),
                                      Visibility(
                                          visible: exibirOcultarBtnSalvar,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              cartaoBtn(
                                                  CaminhosImagens.gestoSalvar,
                                                  Textos.btnSalvarAlteracoes,
                                                  PaletaCores.corAzul,
                                                  larguraTela),
                                              btnIcone(
                                                  Icons.close,
                                                  PaletaCores.corVermelha,
                                                  Textos.btnCancelarEdicao),
                                            ],
                                          ))
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ))),
                  onTap: () {
                    if (Platform.isAndroid || Platform.isIOS) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  },
                ),
                bottomNavigationBar: Container(
                    color: Colors.white,
                    width: larguraTela,
                    height: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            cartaoBtn(CaminhosImagens.gestoSair, Textos.btnSair,
                                PaletaCores.corVermelha, larguraTela),
                            cartaoBtn(
                                CaminhosImagens.gestoExcluir,
                                Textos.btnExcluirUsuario,
                                PaletaCores.corVermelha,
                                larguraTela),
                          ],
                        )
                      ],
                    )),
              );
            }
          },
        ));
  }
}
