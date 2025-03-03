import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/constantes_sistema_solar.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Widgets/tela_carregamento_widget.dart';
import 'package:geoli/modelos/planeta.dart';

class TelaLoginCadastro extends StatefulWidget {
  const TelaLoginCadastro({super.key});

  @override
  State<TelaLoginCadastro> createState() => _TelaLoginCadastroState();
}

class _TelaLoginCadastroState extends State<TelaLoginCadastro> {
  bool exibirTelaCarregamento = false;
  List<Planeta> planetas = ConstantesSistemaSolar.adicinarPlanetas();
  final _formKeyFormulario = GlobalKey<FormState>();
  TextEditingController email = TextEditingController(text: "");
  TextEditingController senha = TextEditingController(text: "");

  cadastrarUsuario() {
    try {
      FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text, password: senha.text);
      MetodosAuxiliares.exibirMensagens(
          Textos.sucessoCadastro, Constantes.msgAcerto, context);
      recuperarUsuario();
    } catch (e) {
      MetodosAuxiliares.exibirMensagens(
          Textos.erroCadastro, Constantes.msgErro, context);
      debugPrint(e.toString());
    }
  }

  recuperarUsuario() {
    print("Entrou");
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        print("fdsfs${user.uid}");
        criarPontuacaoSistemaSolar(user.uid);
        criarDesbloquearPlaneta(user.uid);
      }
    });
  }

  desconetar() async {
    await FirebaseAuth.instance.signOut();
  }

  criarPontuacaoSistemaSolar(String colecaoUIDUsuario) {
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(colecaoUIDUsuario) // passando a colecao
          .doc(Constantes.fireBaseColecaoSistemaSolar)
          .collection(
              Constantes.fireBaseColecaoSistemaSolar) // passando a colecao
          .doc(Constantes
              .fireBaseDocumentoPontosJogadaSistemaSolar) //passando o documento
          .set({Constantes.pontosJogada: "pontuacaoTotal"});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  criarDesbloquearPlaneta(String uidUsuario) {
    Map<String, bool> dados = {};
    // percorrendo a lista para poder jogar os dados dentro de um map
    for (var element in planetas) {
      //definindo que o map vai receber o nome do planeta e o valor boleano
      dados[element.nomePlaneta] = false;
    }
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(uidUsuario) // passando a colecao
          .doc(Constantes.fireBaseColecaoSistemaSolar)
          .collection(
              Constantes.fireBaseColecaoSistemaSolar) // passando a colecao
          .doc(Constantes
              .fireBaseDocumentoPlanetasDesbloqueados) //passando o documento
          .set(dados);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  fazerLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.text, password: senha.text);
      MetodosAuxiliares.exibirMensagens(
          Textos.sucessoLogin, Constantes.msgAcerto, context);
      Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
    } on FirebaseAuthException {
      MetodosAuxiliares.exibirMensagens(
          Textos.erroLogin, Constantes.msgErro, context);
    }
  }

//   // Disable persistence on web platforms. Must be called on initialization:
//   final auth = FirebaseAuth.instanceFor(app: Firebase.app(), persistence: Persistence.NONE);
// // To change it after initialization, use `setPersistence()`:
//   await auth.setPersistence(Persistence.LOCAL);

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
              borderRadius: BorderRadius.circular(20),
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
                leading: IconButton(
                    color: Colors.black,
                    //setando tamanho do icone
                    iconSize: 30,
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, Constantes.rotaTelaInicial);
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
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
                      Textos.descricaoTelaInicial,
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
