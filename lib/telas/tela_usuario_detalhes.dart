import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/passar_pegar_dados.dart.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Widgets/tela_carregamento_widget.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool ocultarSenhaDigitada = true;
  bool exibirAlertaVerificacaoEmail = false;
  bool exibirMensagemSemConexao = false;
  IconData iconeSenhaVisivel = Icons.visibility;
  String emailAuxiliarValidar = "";
  String emailAlterado = "";
  String nomeUsuarioSemAlteracao = "";
  late String uidUsuario;
  final _formKeyFormulario = GlobalKey<FormState>();
  final _formKeySenhaAlerta = GlobalKey<FormState>();
  TextEditingController campoEmail = TextEditingController(text: "");
  TextEditingController campoSenhaConfirmacao = TextEditingController(text: "");
  TextEditingController campoSenhaNova = TextEditingController(text: "Agosto");
  TextEditingController campoUsuario = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    recuperarUIDUsuario();
  }

  recuperarUIDUsuario() async {
    uidUsuario = await PassarPegarDados.recuperarInformacoesUsuario()
        .values
        .elementAt(0);
    recuperarInformacoesUsuario();
  }

  recuperarInformacoesUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = "";
    email = prefs.getString(Constantes.sharedPreferencesEmail) ?? '';
    campoEmail.text = email;
    emailAuxiliarValidar = campoEmail.text;
    recuperarNomeUsuario();
  }

  recuperarNomeUsuario() async {
    var db = FirebaseFirestore.instance;
    bool retornoConexao = await InternetConnection().hasInternetAccess;
    //instanciano variavel
    if (retornoConexao) {
      try {
        db
            .collection(
                Constantes.fireBaseColecaoUsuarios) // passando a colecao
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
          validarErros(e.toString());
        });
      } catch (e) {
        debugPrint("RP${e.toString()}");
        validarErros(e.toString());
      }
    } else {
      exibirErroConexao();
    }
  }

  exibirErroConexao() {
    if (mounted) {
      setState(() {
        exibirTelaCarregamento = true;
        exibirMensagemSemConexao = true;
        PassarPegarDados.passarTelaAtualErroConexao(
            Constantes.rotaTelaUsuarioDetalhado);
      });
    }
  }

  desconetarUsuario() async {
    setState(() {
      exibirTelaCarregamento = true;
    });
    await FirebaseAuth.instance.signOut();
    chamarExibirMensagens(Textos.sucessoDesconectar, Constantes.msgAcerto);
    //MetodosAuxiliares.passarUidUsuario("");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constantes.sharedPreferencesEmail, "");
    prefs.setString(Constantes.sharedPreferencesSenha, "");
    prefs.setString(Constantes.sharedPreferencesUID, "");
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

  // Metodo para chamar deletar tabela
  chamarDeletarDadosBancoDados() async {
    bool retornoRegioes =
        await excluirDocumentoDentroColecao(Constantes.fireBaseColecaoRegioes);
    if (retornoRegioes) {
      bool retornoSistemaSolar = await excluirDocumentoDentroColecao(
          Constantes.fireBaseColecaoSistemaSolar);
      if (retornoSistemaSolar) {
        var db = FirebaseFirestore.instance;
        db
            .collection(Constantes.fireBaseColecaoUsuarios)
            .doc(uidUsuario)
            .delete()
            .then((doc) {
          if (FirebaseAuth.instance.currentUser != null) {
            FirebaseAuth.instance.currentUser?.delete();
          }
          desconetarUsuario();
          chamarExibirMensagens(Textos.sucessoExcluirDados, Textos.msgAcertou);
        }, onError: (e) {
          chamarExibirMensagens(Textos.erroExcluirDados, Textos.msgErrou);
          setState(() {
            exibirTelaCarregamento = false;
          });
        });
      }
    }
  }

  //metodo para excluir cada elemento dentro dos documento que compoem
  // aquela colecao de registros no UID do usuario
  Future<bool> excluirDocumentoDentroColecao(String idDocumentoFirebase) async {
    bool retorno = false;
    var db = FirebaseFirestore.instance;
    await db
        .collection(Constantes.fireBaseColecaoUsuarios)
        .doc(uidUsuario)
        .collection(idDocumentoFirebase)
        .get()
        .then((querySnapshot) {
      //para cada iteracao do FOR excluir o
      //item corresponde ao ID da iteracao
      for (var docSnapshot in querySnapshot.docs) {
        db
            .collection(Constantes.fireBaseColecaoUsuarios)
            .doc(uidUsuario)
            .collection(idDocumentoFirebase)
            .doc(docSnapshot.id)
            .delete();
      }
      retorno = true;
    }, onError: (e) {
      retorno = false;
    });
    return retorno;
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
        MetodosAuxiliares.validarAlteracaoEmail(
            emailAlterado, campoUsuario.text);
        recarregarTela();
      }, onError: (e) {
        debugPrint("NOME${e.toString()}");
        validarErros(e.toString());
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  autenticarUsuario() async {
    AuthCredential credential = EmailAuthProvider.credential(
        email: emailAuxiliarValidar, password: campoSenhaConfirmacao.text);
    try {
      FirebaseAuth.instance.signInWithCredential(credential).then((value) {
        if (ativarCampoSenha) {
          atualizarSenha();
        } else if (ativarCampoEmail) {
          atualizarEmail();
        } else if (exibirAlertaVerificacaoEmail) {
          reenviarEmailAlteracao();
        } else {
          chamarDeletarDadosBancoDados();
        }
        campoSenhaConfirmacao.text = "";
      }, onError: (e) {
        setState(() {
          exibirTelaCarregamento = false;
        });
        validarErros(e);
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        exibirTelaCarregamento = false;
      });
      validarErros(e);
    }
  }

  validarErros(erro) {
    if (erro.code.contains('invalid-email')) {
      chamarExibirMensagens(Textos.erroEmailInvalido, Constantes.msgErro);
    } else if (erro.code.contains('unknown-error')) {
      chamarExibirMensagens(
          Textos.erroEmailNaoCadastradoSenhaIncorreta, Constantes.msgErro);
    } else if (erro.contains("An internal error has occurred")) {
      exibirErroConexao();
    }
  }

  // metodo para atualizar Email do usuario
  atualizarEmail() async {
    if (FirebaseAuth.instance.currentUser != null) {
      //chamando funcao para enviar link ao email passado
      // para poder atualizar o email do usuario
      FirebaseAuth.instance.currentUser
          ?.verifyBeforeUpdateEmail(campoEmail.text)
          .then((value) {
        // em caso de sucesso do envio fazer as seguinte acoes
        chamarExibirMensagens(Textos.sucessoEnvioLink, Constantes.msgAcerto);
        Map<String, dynamic> dadosAlteracaoEmail = {
          Constantes.fireBaseCampoNomeUsuario: nomeUsuarioSemAlteracao,
          Constantes.fireBaseCampoEmailAlterado: campoEmail.text
        };
        // gravando no banco de dados que o
        // campo email foi alterado e gravando o nome do email
        try {
          // instanciando Firebase
          var db = FirebaseFirestore.instance;
          db
              .collection(Constantes.fireBaseColecaoUsuarios)
              .doc(
                uidUsuario,
              )
              .set(dadosAlteracaoEmail)
              .then((value) {
            recarregarTela();
          }, onError: (e) {
            debugPrint("EMAILALTE${e.toString()}");
            validarErros(e.toString());
          });
        } catch (e) {
          debugPrint(e.toString());
        }
      }, onError: (e) {
        debugPrint("EMAIL${e.toString()}");
        validarErros(e.toString());
      });
    }
  }

  //metodo para reenviar o link de alteracao do email
  reenviarEmailAlteracao() {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.currentUser
          ?.verifyBeforeUpdateEmail(emailAlterado)
          .then((value) {
        chamarExibirMensagens(Textos.sucessoEnvioLink, Constantes.msgAcerto);
      }, onError: (e) {
        debugPrint("EMAILREE${e.toString()}");
        validarErros(e.toString());
      });
    }
  }

  // metodo para atualizar
  // a senha de usuario
  atualizarSenha() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.currentUser
          ?.updatePassword(campoSenhaNova.text)
          .then((value) {
        chamarExibirMensagens(
            Textos.sucessoAtualizarSenha, Constantes.msgAcerto);
        prefs.setString(Constantes.sharedPreferencesSenha, campoSenhaNova.text);
        recarregarTela();
      }, onError: (e) {
        debugPrint("SENHA${e.toString()}");
        validarErros(e.toString());
      });
    }
  }

  Widget campos(TextEditingController controle, String nomeCampo,
          bool ativarCampo, String nomeImagem) =>
      Container(
          width: 550,
          margin: EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image(
                height: kIsWeb
                    ? 80
                    : Platform.isAndroid || Platform.isIOS
                        ? 60
                        : 80,
                width: kIsWeb
                    ? 80
                    : Platform.isAndroid || Platform.isIOS
                        ? 60
                        : 80,
                image: AssetImage("$nomeImagem.png"),
              ),
              SizedBox(
                  width: kIsWeb
                      ? 300
                      : Platform.isAndroid || Platform.isIOS
                          ? 220
                          : 300,
                  height: 100,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controle,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Textos.erroCampoVazio;
                          }
                          return null;
                        },
                        enabled: ativarCampo,
                        obscureText: nomeCampo == Textos.campoEmail ||
                                nomeCampo == Textos.campoEmailAntigo ||
                                nomeCampo == Textos.campoUsuario
                            ? false
                            : ocultarSenhaDigitada,
                        decoration: InputDecoration(
                            suffixIcon: nomeCampo == Textos.campoEmail ||
                                    nomeCampo == Textos.campoEmailAntigo ||
                                    nomeCampo == Textos.campoUsuario
                                ? nomeCampo == Textos.campoEmailAntigo &&
                                        exibirAlertaVerificacaoEmail == true
                                    ? Icon(Icons.warning)
                                    : null
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (ocultarSenhaDigitada) {
                                          setState(() {
                                            ocultarSenhaDigitada = false;
                                            iconeSenhaVisivel =
                                                Icons.visibility_off;
                                          });
                                        } else {
                                          setState(() {
                                            ocultarSenhaDigitada = true;
                                            iconeSenhaVisivel =
                                                Icons.visibility;
                                          });
                                        }
                                      });
                                    },
                                    icon: Icon(iconeSenhaVisivel)),
                            labelText: nomeCampo,
                            labelStyle: TextStyle(color: Colors.black),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    width: 1, color: PaletaCores.corVerde)),
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
                      Visibility(
                        visible: exibirAlertaVerificacaoEmail == true &&
                                    nomeCampo == Textos.campoEmail ||
                                nomeCampo == Textos.campoEmailAntigo
                            ? true
                            : false,
                        child: Column(
                          children: [
                            Text(
                              style: TextStyle(fontSize: 13),
                              Textos.telaUsuarioConfirmarEmail,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              emailAlterado,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
              Column(
                children: [
                  Visibility(
                      visible: nomeCampo == Textos.campoEmail ||
                              nomeCampo == Textos.campoEmailAntigo ||
                              nomeCampo == Textos.campoUsuario ||
                              nomeCampo == Textos.campoSenhaNova
                          ? true
                          : false,
                      child: btnIcone(
                        Icons.edit,
                        PaletaCores.corOuro,
                        nomeCampo,
                      )),
                  Visibility(
                      visible: exibirAlertaVerificacaoEmail == true &&
                                  nomeCampo == Textos.campoEmail ||
                              nomeCampo == Textos.campoEmailAntigo
                          ? true
                          : false,
                      child: Container(
                        margin: EdgeInsets.all(5),
                        width: 70,
                        height: 50,
                        child: FloatingActionButton(
                          shape: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(15)),
                          backgroundColor: Colors.white,
                          elevation: 0,
                          heroTag: Textos.btnReenviarEmail,
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            campoSenhaConfirmacao.text = prefs.getString(
                                    Constantes.sharedPreferencesSenha) ??
                                '';
                            autenticarUsuario();
                          },
                          child: Text(
                            Textos.btnReenviarEmail,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      )),
                ],
              )
            ],
          ));

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
            if (_formKeyFormulario.currentState!.validate()) {
              if (nomeBtn == Textos.campoUsuario) {
                setState(() {
                  ativarCampoUsuario = true;
                  ativarCampoEmail = false;
                  ativarCampoSenha = false;
                });
              } else if (nomeBtn == Textos.campoEmail ||
                  nomeBtn == Textos.campoEmailAntigo) {
                setState(() {
                  ativarCampoEmail = true;
                  ativarCampoUsuario = false;
                  ativarCampoSenha = false;
                  exibirAlertaVerificacaoEmail = false;
                });
              } else if (nomeBtn == Textos.campoSenhaNova) {
                setState(() {
                  ativarCampoSenha = true;
                  ativarCampoEmail = false;
                  ativarCampoUsuario = false;
                  campoSenhaNova.text = "";
                });
              }
            }
            if (nomeBtn == Textos.btnCancelarEdicao) {
              setState(() {
                if (_formKeyFormulario.currentState!.validate()) {
                  ativarCampoSenha = false;
                  ativarCampoUsuario = false;
                  ativarCampoEmail = false;
                  ocultarSenhaDigitada = true;
                  if (emailAlterado.isNotEmpty) {
                    exibirAlertaVerificacaoEmail = true;
                  }
                }
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

  Widget cartaoBtn(
          String nomeImagem, String nomeBtn, Color cor, double altura) =>
      Container(
        margin: EdgeInsets.all(5),
        width: 140,
        height: altura,
        child: FloatingActionButton(
          elevation: 0,
          heroTag: nomeBtn,
          backgroundColor: Colors.white,
          onPressed: () {
            if (nomeBtn == Textos.btnSalvarAlteracoes) {
              if (ativarCampoUsuario &&
                  emailAuxiliarValidar == campoEmail.text) {
                if (_formKeyFormulario.currentState!.validate()) {
                  atualizarNomeUsuario();
                }
              } else if (ativarCampoEmail) {
                // Validacao quando for ALTERAR EMAIL
                if (_formKeyFormulario.currentState!.validate()) {
                  setState(() {
                    ocultarSenhaDigitada = false;
                    alerta(context, Textos.alertTitulo,
                        Textos.alertDescricaoAlterarEmail, Textos.campoSenha);
                  });
                }
              } else if (ativarCampoSenha) {
                // Validacao quando for ALTERAR SENHA
                if (_formKeyFormulario.currentState!.validate()) {
                  if (campoSenhaNova.text.length >= 6) {
                    setState(() {
                      ocultarSenhaDigitada = false;
                      alerta(
                          context,
                          Textos.alertTitulo,
                          Textos.alertDescricaoAlterarSenha,
                          Textos.campoSenhaAntiga);
                    });
                  } else {
                    chamarExibirMensagens(
                        Textos.erroSenhaCurta, Constantes.msgErro);
                  }
                }
              }
            } else if (nomeBtn == Textos.btnExcluirUsuario) {
              setState(() {
                ativarCampoSenha = false;
                ativarCampoEmail = false;
                alerta(context, Textos.alertTitulo,
                    Textos.alertDescricaoExclusaoUsuario, Textos.campoSenha);
              });
            } else if (nomeBtn == Textos.btnSair) {
              desconetarUsuario();
            }
          },
          shape: RoundedRectangleBorder(
              side: BorderSide(color: cor, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(40))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                height: 90,
                width: 90,
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

  Future<void> alerta(BuildContext context, String tituloAlerta,
      String decricaoAlerta, String labelSenha) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            textAlign: TextAlign.center,
            tituloAlerta,
            style: const TextStyle(color: Colors.black),
          ),
          content: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: kIsWeb
                    ? 500
                    :Platform.isIOS || Platform.isAndroid ? 300 : 500,
                height: 200,
                child: Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      decricaoAlerta,
                      style: const TextStyle(color: Colors.black),
                    ),
                    Form(
                      key: _formKeySenhaAlerta,
                      child: campos(campoSenhaConfirmacao, labelSenha, true,
                          CaminhosImagens.gestoSenha),
                    )
                  ],
                ),
              )),
          actions: <Widget>[
            TextButton(
              child: Column(
                children: [
                  Image(
                    height: 90,
                    width: 90,
                    image: AssetImage("${CaminhosImagens.gestoCancelar}.png"),
                  ),
                  Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              onPressed: () {
                setState(() {
                  campoSenhaConfirmacao.text = "";
                  ocultarSenhaDigitada = true;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Column(
                children: [
                  Image(
                    height: 90,
                    width: 90,
                    image: AssetImage("${CaminhosImagens.gestoSim}.png"),
                  ),
                  Text(
                    'Sim/Confirmar',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              onPressed: () {
                if (_formKeySenhaAlerta.currentState!.validate()) {
                  Navigator.of(context).pop();
                  setState(() {
                    exibirTelaCarregamento = true;
                  });
                  autenticarUsuario();
                }
              },
            ),
          ],
        );
      },
    );
  }

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
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                        Text(
                          Textos.telaUsuarioDescricao,
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        campos(campoUsuario, Textos.campoUsuario,
                            ativarCampoUsuario, CaminhosImagens.gestoNome),
                        campos(
                            campoEmail,
                            exibirAlertaVerificacaoEmail == true
                                ? Textos.campoEmailAntigo
                                : Textos.campoEmail,
                            ativarCampoEmail,
                            CaminhosImagens.gestoEmail),
                        campos(campoSenhaNova, Textos.campoSenhaNova,
                            ativarCampoSenha, CaminhosImagens.gestoSenha),
                        Visibility(
                            visible: ativarCampoUsuario ||
                                ativarCampoSenha ||
                                ativarCampoEmail,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                btnIcone(Icons.close, PaletaCores.corVermelha,
                                    Textos.btnCancelarEdicao),
                                cartaoBtn(
                                    CaminhosImagens.gestoSalvar,
                                    Textos.btnSalvarAlteracoes,
                                    PaletaCores.corAzul,
                                    120)
                              ],
                            ))
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
                            PaletaCores.corVermelha, 140),
                        cartaoBtn(
                          CaminhosImagens.gestoExcluir,
                          Textos.btnExcluirUsuario,
                          PaletaCores.corVermelha,
                          140,
                        )
                      ],
                    )
                  ],
                )),
          );
        }
      },
    );
  }
}
