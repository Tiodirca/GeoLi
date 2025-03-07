import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Widgets/tela_carregamento_widget.dart';

class TelaUsuarioDetalhado extends StatefulWidget {
  const TelaUsuarioDetalhado({super.key});

  @override
  State<TelaUsuarioDetalhado> createState() => _TelaUsuarioDetalhadoState();
}

class _TelaUsuarioDetalhadoState extends State<TelaUsuarioDetalhado> {
  late String uidUsuario;
  bool ativarCampoUsuario = false;
  bool ativarCampoEmail = false;
  bool ativarCampoSenha = false;
  bool exibirBtnMudarSenha = true;
  bool exibirTelaCarregamento = true;
  bool exibirAutenticacao = false;
  bool exibirBtnAtualizar = false;
  final _formKeyFormulario = GlobalKey<FormState>();
  final _formKeyExcluirDados = GlobalKey<FormState>();
  String emailAuxiliarValidar = "";
  TextEditingController campoEmail = TextEditingController(text: "");
  TextEditingController campoSenha = TextEditingController(text: "");
  TextEditingController campoSenhaNova = TextEditingController(text: "");
  TextEditingController campoUsuario = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    recuperarUIDUsuario();
  }

  recuperarUIDUsuario() async {
    uidUsuario = await MetodosAuxiliares.recuperarUid();
    recuperarEmail();
  }

  recuperarEmail() async {
    if (FirebaseAuth.instance.currentUser != null) {
      String? emailRecuperado = FirebaseAuth.instance.currentUser?.email;
      campoEmail.text = emailRecuperado!;
      emailAuxiliarValidar = campoEmail.text;
      recuperarNomeUsuario();
    }
  }

  autenticarUsuario(String nomeCampoAcao) async {
    AuthCredential credential = EmailAuthProvider.credential(
        email: emailAuxiliarValidar, password: campoSenha.text);
    try {
      FirebaseAuth.instance.signInWithCredential(credential).then((value) {
        if (nomeCampoAcao == Textos.campoEmail && ativarCampoEmail) {
          atualizarEmail();
        } else if (!ativarCampoEmail && nomeCampoAcao == Textos.campoEmail) {
          atualizarSenha();
        } else {
          chamarDeletarDadosBancoDados();
        }
        setState(() {
          campoSenha.text = "";
        });
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

  atualizarEmail() async {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.currentUser
          ?.verifyBeforeUpdateEmail(campoEmail.text);
      chamarExibirMensagens(Textos.sucessoEnvioLink, Constantes.msgAcerto);
      Navigator.pushReplacementNamed(
          context, Constantes.rotaTelaUsuarioDetalhado);
    }
  }

  atualizarSenha() async {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.currentUser?.updatePassword(campoSenhaNova.text);
      chamarExibirMensagens(Textos.sucessoAtualizarSenha, Constantes.msgAcerto);
      Navigator.pushReplacementNamed(
          context, Constantes.rotaTelaUsuarioDetalhado);
    }
  }

  validarErros(erro) {
    if (erro.code.contains('invalid-email')) {
      chamarExibirMensagens(Textos.erroEmailInvalido, Constantes.msgErro);
    } else if (erro.code.contains('unknown-error')) {
      chamarExibirMensagens(
          Textos.erroEmailNaoCadastradoSenhaIncorreta, Constantes.msgErro);
    }
  }

  recuperarNomeUsuario() async {
    var db = FirebaseFirestore.instance;
    //instanciano variavel
    db
        .collection(Constantes.fireBaseColecaoUsuarios) // passando a colecao
        .doc(
          uidUsuario,
        )
        .get()
        .then(
      (querySnapshot) async {
        // verificando cada item que esta gravado no banco de dados
        querySnapshot.data()!.forEach((key, value) {
          setState(() {
            campoUsuario.text = value;
          });
        });
        setState(() {
          exibirTelaCarregamento = false;
        });
      },
    );
  }

  desconetarUsuario() async {
    await FirebaseAuth.instance.signOut();
    chamarExibirMensagens(Textos.sucessoDesconectar, Constantes.msgAcerto);
    MetodosAuxiliares.passarUidUsuario("");
    redirecionarTela();
  }

  redirecionarTela() {
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaLoginCadastro);
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

  chamarExibirMensagens(String tipoMensagem, String tipoExibicao) {
    MetodosAuxiliares.exibirMensagens(
        Textos.sucessoExcluirDados,
        Textos.msgAcertou,
        Constantes.duracaoExibicaoToastLoginCadastro,
        Constantes.larguraToastLoginCadastro,
        context);
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
      Constantes.fireBaseDocumentoNomeUsuario: campoUsuario.text
    };
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(Constantes.fireBaseColecaoUsuarios)
          .doc(
            uidUsuario,
          )
          .set(nomeUsuario);
      Navigator.pushReplacementNamed(
          context, Constantes.rotaTelaUsuarioDetalhado);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget campos(
          TextEditingController controle, String nomeCampo, bool ativarCampo) =>
      Container(
        margin: EdgeInsets.only(right: 10),
        width: 300,
        child: TextFormField(
          enabled: ativarCampo,
          controller: controle,
          validator: (value) {
            if (value!.isEmpty) {
              return Textos.erroCampoVazio;
            }
            return null;
          },
          decoration: InputDecoration(
              hintText: nomeCampo,
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(width: 1, color: PaletaCores.corVerde)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(width: 2, color: PaletaCores.corAzul)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(width: 1, color: PaletaCores.corAzul)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(width: 1, color: PaletaCores.corVermelha)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(width: 2, color: PaletaCores.corAzul))),
        ),
      );

  Widget btnAcao(String nomeBtn, Color corBtn, double larguraBtn) => Container(
        margin: EdgeInsets.all(10),
        width: larguraBtn,
        height: 50,
        child: FloatingActionButton(
          heroTag: nomeBtn,
          elevation: 0,
          backgroundColor: Colors.white,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: corBtn,
                width: 1,
              )),
          onPressed: () async {
            if (nomeBtn == Textos.btnCancelarEdicao) {
              setState(() {
                ativarCampoUsuario = false;
                ativarCampoEmail = false;
                ativarCampoSenha = false;
                exibirBtnMudarSenha = true;
                exibirBtnAtualizar = false;
              });
            } else if (nomeBtn == Textos.btnMudarSenha) {
              setState(() {
                ativarCampoSenha = true;
                ativarCampoUsuario = false;
                ativarCampoEmail = false;
                exibirBtnMudarSenha = false;
                exibirBtnAtualizar = true;
              });
            } else if (nomeBtn == Textos.btnAtualizar) {
              //Verificando se o usuario esta
              // alterando SOMENTE o nome de usuario
              if (ativarCampoUsuario &&
                  emailAuxiliarValidar == campoEmail.text) {
                if (_formKeyFormulario.currentState!.validate()) {
                  atualizarNomeUsuario();
                }
              } else {
                if (_formKeyFormulario.currentState!.validate()) {
                  setState(() {
                    exibirAutenticacao = true;
                  });
                }
              }
            } else if (nomeBtn == Textos.btnDesconectar) {
              desconetarUsuario();
            } else if (nomeBtn == Textos.btnSalvarAlteracoes) {
              if (_formKeyFormulario.currentState!.validate()) {
                autenticarUsuario(Textos.campoEmail);
              }
            } else if (nomeBtn == Textos.btnExcluirUsuario) {
              alertaExclusao(context);
            }
          },
          child: Text(
            textAlign: TextAlign.center,
            nomeBtn,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      );

  Widget btnIcone(IconData icone, Color cor, String nomeBtn) => SizedBox(
        width: 45,
        height: 45,
        child: FloatingActionButton(
          heroTag: nomeBtn,
          backgroundColor: Colors.white,
          shape: OutlineInputBorder(
              borderSide: BorderSide(color: cor, width: 1),
              borderRadius: BorderRadius.circular(15)),
          onPressed: () {
            if (icone == Icons.close) {
              setState(() {
                exibirAutenticacao = false;
                ativarCampoSenha = false;
                ativarCampoEmail = false;
                ativarCampoUsuario = false;
                exibirBtnAtualizar = false;
                exibirBtnMudarSenha = true;
              });
            } else if (nomeBtn == Textos.campoUsuario) {
              setState(() {
                ativarCampoUsuario = true;
                ativarCampoEmail = false;
                ativarCampoSenha = false;
                exibirBtnMudarSenha = false;
                exibirBtnAtualizar = true;
              });
            } else if (nomeBtn == Textos.campoEmail) {
              setState(() {
                ativarCampoUsuario = false;
                ativarCampoEmail = true;
                ativarCampoSenha = false;
                exibirBtnMudarSenha = false;
                exibirBtnAtualizar = true;
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

  Future<void> alertaExclusao(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            Textos.alertTituloExclusao,
            style: const TextStyle(color: Colors.black),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  Textos.alertDescricaoExclusaoUsuario,
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: [
                    Text(
                      Textos.telaUsuarioDescricaoDigiteSenha,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Form(
                      key: _formKeyExcluirDados,
                      child: campos(campoSenha, Textos.campoSenha, true),
                    )
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Confirmar Exclusão',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                if (_formKeyExcluirDados.currentState!.validate()) {
                  Navigator.of(context).pop();
                  setState(() {
                    exibirTelaCarregamento = true;
                  });
                  autenticarUsuario("");
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
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                  width: larguraTela,
                  height: alturaTela,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          Textos.telaUsuarioDescricao,
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 20),
                            width: larguraTela,
                            height: alturaTela * 0.4,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                if (exibirAutenticacao) {
                                  return Column(
                                    children: [
                                      Text(
                                        ativarCampoEmail == true
                                            ? Textos
                                                .telaUsuarioDescricaoAutenticacaoEmail
                                            : Textos
                                                .telaUsuarioDescricaoAutenticacaoSenha,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      Column(
                                        children: [
                                          Form(
                                            key: _formKeyFormulario,
                                            child: campos(
                                                campoSenha,
                                                ativarCampoEmail == true
                                                    ? Textos.campoSenha
                                                    : Textos.campoSenhaAntiga,
                                                true),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          btnIcone(Icons.close,
                                              PaletaCores.corVermelha, ""),
                                          btnAcao(Textos.btnSalvarAlteracoes,
                                              PaletaCores.corAzul, 100),
                                        ],
                                      )
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        width: 400,
                                        height: alturaTela * 0.3,
                                        child: Form(
                                          key: _formKeyFormulario,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: 400,
                                                height: 70,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    campos(
                                                        campoUsuario,
                                                        Textos.campoUsuario,
                                                        ativarCampoUsuario),
                                                    btnIcone(
                                                      Icons.edit,
                                                      PaletaCores.corOuro,
                                                      Textos.campoUsuario,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 400,
                                                height: 70,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    campos(
                                                        campoEmail,
                                                        Textos.campoEmail,
                                                        ativarCampoEmail),
                                                    btnIcone(
                                                      Icons.edit,
                                                      PaletaCores.corOuro,
                                                      Textos.campoEmail,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                  visible: ativarCampoSenha,
                                                  child: SizedBox(
                                                    width: 400,
                                                    height: 70,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        campos(
                                                            campoSenhaNova,
                                                            Textos
                                                                .campoSenhaNova,
                                                            ativarCampoSenha),
                                                      ],
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Visibility(
                                              visible: exibirBtnAtualizar,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  btnAcao(
                                                      Textos.btnCancelarEdicao,
                                                      PaletaCores.corVermelha,
                                                      100),
                                                  btnAcao(
                                                      Textos.btnAtualizar,
                                                      PaletaCores.corLaranja,
                                                      200),
                                                ],
                                              )),
                                          Visibility(
                                            visible: exibirBtnMudarSenha,
                                            child: btnAcao(Textos.btnMudarSenha,
                                                PaletaCores.corAzul, 100),
                                          )
                                        ],
                                      )
                                    ],
                                  );
                                }
                              },
                            )),
                      ],
                    ),
                  )),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
            bottomNavigationBar: Container(
                color: Colors.white,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    btnAcao(
                        Textos.btnDesconectar, PaletaCores.corVermelha, 200),
                    btnAcao(
                        Textos.btnExcluirUsuario, PaletaCores.corVermelha, 150),
                  ],
                )),
          );
        }
      },
    );
  }
}
