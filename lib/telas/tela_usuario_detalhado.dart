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
  bool exibirTelaCarregamento = true;
  bool exibirAutenticacao = false;
  final _formKeyFormulario = GlobalKey<FormState>();
  final _formKeyExcluirDados = GlobalKey<FormState>();
  String emailAuxiliarValidar = "";
  TextEditingController campoEmail = TextEditingController(text: "");
  TextEditingController campoSenha = TextEditingController(text: "");
  TextEditingController campoSenhaNova = TextEditingController(text: "");
  TextEditingController campoUsuario = TextEditingController(text: "");
  String tipoAutenticacaoTrocaEmail = "TrocaEmail";

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

  autenticarUsuario(String tipoAutenticacao) async {
    AuthCredential credential = EmailAuthProvider.credential(
        email: emailAuxiliarValidar, password: campoSenha.text);
    try {
      FirebaseAuth.instance.signInWithCredential(credential);
      if (tipoAutenticacao == tipoAutenticacaoTrocaEmail) {
        atualizarEmail();
      } else {
        excluirUsuarioInformacoes();
      }
    } on FirebaseAuthException catch (e) {
      validarErros(e);
    }
  }

  validarErros(erro) {
    if (erro.code.contains('invalid-email')) {
      MetodosAuxiliares.exibirMensagens(
          Textos.erroEmailInvalido,
          Constantes.msgErro,
          Constantes.duracaoExibicaoToastLoginCadastro,
          Constantes.larguraToastLoginCadastro,
          context);
    } else if (erro.code.contains('unknown-error')) {
      MetodosAuxiliares.exibirMensagens(
          Textos.erroEmailNaoCadastradoSenhaIncorreta,
          Constantes.msgErro,
          Constantes.duracaoExibicaoToastLoginCadastro,
          Constantes.larguraToastLoginCadastro,
          context);
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
    MetodosAuxiliares.exibirMensagens(
        Textos.sucessoDesconectar,
        Constantes.msgAcerto,
        Constantes.duracaoExibicaoToastJogos,
        Constantes.larguraToastLoginCadastro,
        context);
    MetodosAuxiliares.passarUidUsuario("");
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaLoginCadastro);
  }

  excluirUsuarioInformacoes() async {
    setState(() {
      exibirTelaCarregamento = true;
    });
    chamarDeletarDadosBancoDados();
  }

  // Metodo para chamar deletar tabela
  chamarDeletarDadosBancoDados() async {
    var db = FirebaseFirestore.instance;
    db
        .collection(Constantes.fireBaseColecaoUsuarios)
        .doc(uidUsuario)
        .delete()
        .then((doc) {
      setState(() {});
      MetodosAuxiliares.exibirMensagens(
          Textos.sucessoExcluirDados,
          Textos.msgAcertou,
          Constantes.duracaoExibicaoToastLoginCadastro,
          Constantes.larguraToastLoginCadastro,
          context);
      if (FirebaseAuth.instance.currentUser != null) {
        FirebaseAuth.instance.currentUser?.delete();
      }
      desconetarUsuario();
    }, onError: (e) {
      MetodosAuxiliares.exibirMensagens(
          Textos.erroExcluirDados,
          Textos.msgErrou,
          Constantes.duracaoExibicaoToastLoginCadastro,
          Constantes.larguraToastLoginCadastro,
          context);
      setState(() {
        exibirTelaCarregamento = false;
      });
    });
  }

  // excluirDadosColecaoDocumento(String idDocumentoFirebase) async {
  //   var db = FirebaseFirestore.instance;
  //   //consultando id do documento no firebase para posteriormente excluir
  //   await db
  //       .collection(Constantes.fireBaseColecaoUsuarios)
  //       .doc(uidUsuario)
  //       .collection(Constantes.fireBaseDadosCadastrados)
  //       .get()
  //       .then(
  //         (querySnapshot) {
  //       // para cada iteracao do FOR excluir o
  //       // item corresponde ao ID da iteracao
  //       for (var docSnapshot in querySnapshot.docs) {
  //         db
  //             .collection(Constantes.fireBaseColecaoEscala)
  //             .doc(idDocumentoFirebase)
  //             .collection(Constantes.fireBaseDadosCadastrados)
  //             .doc(docSnapshot.id)
  //             .delete();
  //       }
  //     },
  //   );
  // }

  atualizarEmail() async {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.currentUser
          ?.verifyBeforeUpdateEmail(campoEmail.text);
    }
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
        margin: EdgeInsets.all(10),
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
                  borderSide:
                      BorderSide(width: 2, color: PaletaCores.corAzul)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(width: 1, color: PaletaCores.corAzulMagenta)),
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
        height: 40,
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
          onPressed: () {
            if (nomeBtn == Textos.btnCancelarEdicao) {
              setState(() {
                ativarCampoUsuario = false;
                ativarCampoEmail = false;
                ativarCampoSenha = false;
              });
            } else if (nomeBtn == Textos.btnMudarSenha) {
              setState(() {
                ativarCampoSenha = true;
                ativarCampoUsuario = false;
                ativarCampoEmail = false;
              });
            } else if (nomeBtn == Textos.btnAtualizar) {
              if (ativarCampoUsuario &&
                  emailAuxiliarValidar == campoEmail.text) {
                if (_formKeyFormulario.currentState!.validate()) {
                  atualizarNomeUsuario();
                }
              } else {
                setState(() {
                  exibirAutenticacao = true;
                });
              }
            } else if (nomeBtn == Textos.btnDesconectar) {
              desconetarUsuario();
            } else if (nomeBtn == Textos.btnSalvarAlteracoes) {
              if (_formKeyFormulario.currentState!.validate()) {
                atualizarNomeUsuario();
                autenticarUsuario(tipoAutenticacaoTrocaEmail);
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
          backgroundColor: Colors.white,
          shape: OutlineInputBorder(
              borderSide: BorderSide(color: cor, width: 1),
              borderRadius: BorderRadius.circular(15)),
          onPressed: () {
            if (icone == Icons.close) {
              setState(() {
                exibirAutenticacao = false;
                ativarCampoSenha = false;
              });
            } else if (nomeBtn == Textos.campoUsuario) {
              setState(() {
                ativarCampoUsuario = true;
                ativarCampoEmail = false;
                ativarCampoSenha = false;
              });
            } else if (nomeBtn == Textos.campoEmail) {
              setState(() {
                ativarCampoUsuario = false;
                ativarCampoEmail = true;
                ativarCampoSenha = false;
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
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            body: Container(
                padding: EdgeInsets.all(10),
                color: Colors.white,
                width: larguraTela,
                height: alturaTela,
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
                                        child: campos(campoSenha,
                                            Textos.campoSenha, true),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                  Container(
                                    width: 400,
                                    height: alturaTela * 0.3,
                                    child: Form(
                                      key: _formKeyFormulario,
                                      child: Column(
                                        children: [
                                          Row(
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
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
                                          Visibility(
                                              visible: ativarCampoSenha,
                                              child: Row(
                                                children: [
                                                  campos(
                                                      campoSenhaNova,
                                                      Textos.campoSenha,
                                                      ativarCampoSenha),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Visibility(
                                          visible: ativarCampoUsuario ||
                                              ativarCampoEmail ||
                                              ativarCampoSenha,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              btnAcao(Textos.btnCancelarEdicao,
                                                  PaletaCores.corVermelha, 100),
                                              btnAcao(Textos.btnAtualizar,
                                                  PaletaCores.corLaranja, 200),
                                            ],
                                          )),
                                      Visibility(
                                        visible: !ativarCampoSenha,
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
                )),
            bottomSheet: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
