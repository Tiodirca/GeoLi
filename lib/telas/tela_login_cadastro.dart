import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/criar_dados_banco_firebase.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Widgets/tela_carregamento_widget.dart';

class TelaLoginCadastro extends StatefulWidget {
  const TelaLoginCadastro({super.key});

  @override
  State<TelaLoginCadastro> createState() => _TelaLoginCadastroState();
}

class _TelaLoginCadastroState extends State<TelaLoginCadastro> {
  bool exibirTelaCarregamento = false;
  bool exibirDadosCadastro = false;
  bool exibirCampos = false;
  final _formKeyFormulario = GlobalKey<FormState>();
  TextEditingController campoEmail = TextEditingController(text: "");
  TextEditingController campoSenha = TextEditingController(text: "");
  TextEditingController campoUsuario = TextEditingController(text: "");

  cadastrarUsuario() async {
    try {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: campoEmail.text,
        password: campoSenha.text,
      )
          .then((value) {
        CriarDadosBanco.criarDadosUsuario(context, campoUsuario.text);
      }, onError: (e) {
        validarErros(e.toString());
      });
    } on FirebaseAuthException catch (e) {
      validarErros(e.code);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  fazerLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: campoEmail.text, password: campoSenha.text)
          .then((value) {
        chamarExibirMensagem(Textos.sucessoLogin, Constantes.msgAcerto);
        redirecionarTelaInicial();
      }, onError: (e) {
        validarErros(e.toString());
      });
    } on FirebaseAuthException catch (e) {
      validarErros(e.code);
    }
  }

  redirecionarTelaInicial() {
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
  }

  chamarExibirMensagem(String mensagem, String tipoMensagem) {
    MetodosAuxiliares.exibirMensagens(
        mensagem,
        Constantes.msgAcerto,
        Constantes.duracaoExibicaoToastLoginCadastro,
        Constantes.larguraToastLoginCadastro,
        context);
  }

  validarErros(String erro) {
    setState(() {
      exibirTelaCarregamento = false;
    });
    if (erro.contains('invalid-email')) {
      chamarExibirMensagem(Textos.erroEmailInvalido, Constantes.msgErro);
    } else if (erro.contains('email-already-in-use')) {
      chamarExibirMensagem(Textos.erroEmailUso, Constantes.msgErro);
    } else if (erro.contains('Password should be at least 6 characters')) {
      chamarExibirMensagem(Textos.erroSenhaCurta, Constantes.msgErro);
    } else if (erro.contains(
        'The supplied auth credential is incorrect, malformed or has expired')) {
      chamarExibirMensagem(Textos.erroSenhaIncorreta, Constantes.msgErro);
    } else if (erro.contains('unknown-error')) {
      chamarExibirMensagem(
          Textos.erroEmailNaoCadastradoSenhaIncorreta, Constantes.msgErro);
    }
  }

  Widget campos(TextEditingController controle, String nomeCampo) => SizedBox(
        width: 300,
        child: TextFormField(
          controller: controle,
          validator: (value) {
            if (value!.isEmpty) {
              return Textos.erroCampoVazio;
            }
            return null;
          },
          decoration: InputDecoration(
              hintText: nomeCampo,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(width: 1, color: PaletaCores.corVerde)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(width: 1, color: PaletaCores.corVerde)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(width: 1, color: PaletaCores.corVermelha)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(width: 1, color: PaletaCores.corVermelha))),
        ),
      );

  Widget btnAcao(String nomeBtn) => Container(
        margin: EdgeInsets.all(10),
        width: 200,
        height: 40,
        child: FloatingActionButton(
          heroTag: nomeBtn,
          elevation: 0,
          backgroundColor: Colors.white,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: PaletaCores.corVerde,
                width: 1,
              )),
          onPressed: () {
            if (nomeBtn == Textos.btnLogin) {
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
                  cadastrarUsuario();
                  setState(() {
                    exibirTelaCarregamento = true;
                  });
                } else {
                  setState(() {
                    exibirTelaCarregamento = true;
                  });
                  fazerLogin();
                }
              }
            }
          },
          child: Text(
            nomeBtn,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      );

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
                leading: Container(),
                backgroundColor: PaletaCores.corVerde,
                title: Text(
                  Textos.telaLoginCadastroTitulo,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              body: Container(
                  padding: EdgeInsets.only(top: 20),
                  color: Colors.white,
                  width: larguraTela,
                  height: alturaTela,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Text(
                            Textos.telaLoginCadastroDescricao,
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Visibility(
                            visible: exibirCampos,
                            child: Column(
                              children: [
                                Form(
                                    key: _formKeyFormulario,
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Visibility(
                                            visible: exibirDadosCadastro,
                                            child: Container(
                                                margin: EdgeInsets.all(10),
                                                width: 400,
                                                height: 70,
                                                child: campos(campoUsuario,
                                                    Textos.campoUsuario))),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          width: 400,
                                          height: 70,
                                          child: campos(
                                              campoEmail, Textos.campoEmail),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          width: 400,
                                          height: 70,
                                          child: campos(
                                              campoSenha, Textos.campoSenha),
                                        )
                                      ],
                                    )),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: btnAcao(Textos.btnEntrar),
                                )
                              ],
                            )),
                        Wrap(
                          children: [
                            btnAcao(Textos.btnLogin),
                            btnAcao(Textos.btnCadastrar),
                          ],
                        ),
                      ],
                    ),
                  )));
        }
      },
    );
  }
}
