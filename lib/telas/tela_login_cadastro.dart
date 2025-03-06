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
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: campoEmail.text,
        password: campoSenha.text,
      );
      if (credential == 'email-already-in-use') {
        MetodosAuxiliares.exibirMensagens(
            Textos.erroEmailUso,
            Constantes.msgErro,
            Constantes.duracaoExibicaoToastLoginCadastro,
            Constantes.larguraToastLoginCadastro,
            context);
        setState(() {
          exibirTelaCarregamento = false;
        });
      } else {
        CriarDadosBanco.criarDadosUsuario(context, campoUsuario.text);
      }
    } on FirebaseAuthException catch (e) {
      validarErros(e);
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: campoEmail.text, password: campoSenha.text);
      MetodosAuxiliares.exibirMensagens(
          Textos.sucessoLogin,
          Constantes.msgAcerto,
          Constantes.duracaoExibicaoToastJogos,
          Constantes.larguraToastLoginCadastro,
          context);
      Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
    } on FirebaseAuthException catch (e) {
      validarErros(e);
    }
  }

  validarErros(erro) {
    setState(() {
      exibirTelaCarregamento = false;
    });
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

  Widget campos(TextEditingController controle, String nomeCampo) => Container(
        margin: EdgeInsets.all(10),
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
                                          child: campos(campoUsuario,
                                              Textos.campoUsuario)),
                                      campos(campoEmail, Textos.campoEmail),
                                      campos(campoSenha, Textos.campoSenha),
                                    ],
                                  )),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: btnAcao(Textos.btnEntrar),
                              )
                            ],
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          btnAcao(Textos.btnLogin),
                          btnAcao(Textos.btnCadastrar),
                        ],
                      ),
                    ],
                  )));
        }
      },
    );
  }
}
