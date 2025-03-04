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
  bool ativarBtn = true;
  final _formKeyFormulario = GlobalKey<FormState>();
  TextEditingController email = TextEditingController(text: "");
  TextEditingController senha = TextEditingController(text: "");
  late String uidUsuario;

  cadastrarUsuario() {
    if (uidUsuario.isEmpty) {
      try {
        FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email.text, password: senha.text);
        print("vxcvxc");
        CriarDadosBanco.criarDadosUsuario(context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
        MetodosAuxiliares.exibirMensagens(
            Textos.erroCadastro, Constantes.msgErro, context);
      }catch (e) {
        debugPrint(e.toString());
      }
    } else {
      MetodosAuxiliares.exibirMensagens(
          Textos.erroLoginFeito, Constantes.msgErro, context);
    }
  }

  desconetar() async {
    await FirebaseAuth.instance.signOut();
    MetodosAuxiliares.exibirMensagens(
        Textos.sucessoDesconectar, Constantes.msgAcerto, context);
    MetodosAuxiliares.passarUidUsuario("");
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaLoginCadastro);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recuperarUIDUsuario();
  }

  recuperarUIDUsuario() async {
    uidUsuario = await MetodosAuxiliares.recuperarUid();
    if (uidUsuario.isEmpty) {
      setState(() {
        ativarBtn = false;
      });
    } else {
      recuperarUsuario();
    }
  }

  recuperarUsuario() async {
    if (FirebaseAuth.instance.currentUser != null) {
      String? emailRecuperado = FirebaseAuth.instance.currentUser?.email;
      email.text = emailRecuperado!;
    }
  }

  fazerLogin() async {
    if (uidUsuario.isEmpty) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.text, password: senha.text);

        MetodosAuxiliares.exibirMensagens(
            Textos.sucessoLogin, Constantes.msgAcerto, context);
        Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
      } on FirebaseAuthException {
        setState(() {
          exibirTelaCarregamento = false;
        });
        MetodosAuxiliares.exibirMensagens(
            Textos.erroLogin, Constantes.msgErro, context);
      }
    } else {
      MetodosAuxiliares.exibirMensagens(
          Textos.erroLoginFeito, Constantes.msgErro, context);
    }
  }

  Widget campos(TextEditingController controle, String nomeCampo) => Container(
        margin: EdgeInsets.all(10),
        width: 300,
        height: 70,
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
          backgroundColor: Colors.white,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: PaletaCores.corAzulMagenta,
                width: 1,
              )),
          onPressed: () {
            if (nomeBtn == Textos.btnLogin) {
              if (_formKeyFormulario.currentState!.validate()) {
                fazerLogin();
              }
            } else if (nomeBtn == Textos.btnCadastrar) {
              if (_formKeyFormulario.currentState!.validate()) {
                cadastrarUsuario();
              }
            } else {
              desconetar();
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
                leading: ativarBtn == true
                    ? IconButton(
                        color: Colors.black,
                        //setando tamanho do icone
                        iconSize: 30,
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, Constantes.rotaTelaInicial);
                        },
                        icon: const Icon(Icons.arrow_back_ios))
                    : Container(),
                backgroundColor: Colors.white,
                title: Text(
                  Textos.telaLoginTitulo,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              body: Container(
                color: Colors.white,
                width: larguraTela,
                height: alturaTela,
                child: Column(
                  children: [
                    Text(
                      Textos.telaLoginDescricao,
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    Form(
                        key: _formKeyFormulario,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            campos(email, Textos.email),
                            campos(senha, Textos.senha),
                          ],
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        btnAcao(Textos.btnLogin),
                        btnAcao(Textos.btnCadastrar),
                        btnAcao(Textos.btnDesconetar)
                      ],
                    ),
                  ],
                ),
              ));
        }
      },
    );
  }
}
