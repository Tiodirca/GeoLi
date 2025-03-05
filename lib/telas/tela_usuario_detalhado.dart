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
  bool exibirTelaCarregamento = false;
  TextEditingController campoEmail = TextEditingController(text: "");
  TextEditingController campoSenha = TextEditingController(text: "");
  TextEditingController campoUsuario = TextEditingController(text: "");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recuperarUIDUsuario();
  }

  recuperarUIDUsuario() async {
    uidUsuario = await MetodosAuxiliares.recuperarUid();
    recuperarUsuario();
  }

  recuperarUsuario() async {
    if (FirebaseAuth.instance.currentUser != null) {
      String? emailRecuperado = FirebaseAuth.instance.currentUser?.email;
      campoEmail.text = emailRecuperado!;
      print(FirebaseAuth.instance.currentUser?.displayName);
    }
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

  Widget campos(TextEditingController controle, String nomeCampo) => Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
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
                        borderSide: BorderSide(
                            width: 1, color: PaletaCores.corAzulMagenta)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            width: 1, color: PaletaCores.corAzulMagenta)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            width: 1, color: PaletaCores.corAzulMagenta)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            width: 1, color: PaletaCores.corAzulMagenta))),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: 45,
              height: 45,
              child: FloatingActionButton(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(width: 1, color: PaletaCores.corOuro)),
                backgroundColor: Colors.white,
                onPressed: () {},
                child: Icon(
                  Icons.edit,
                  color: PaletaCores.corOuro,
                  size: 30,
                ),
              ),
            ),
            SizedBox(
              width: 45,
              height: 45,
              child: FloatingActionButton(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(width: 1, color: PaletaCores.corVermelha)),
                backgroundColor: Colors.white,
                onPressed: () {},
                child: Icon(
                  Icons.close,
                  color: PaletaCores.corVermelha,
                  size: 30,
                ),
              ),
            )
          ],
        ),
      );

  Widget btnAcao(String nomeBtn, Color corBtn) => Container(
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
                color: corBtn,
                width: 1,
              )),
          onPressed: () {},
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
              backgroundColor: PaletaCores.corOuro,
              title: Text(
                Textos.telaUsuarioTitulo,
                style: TextStyle(fontWeight: FontWeight.bold),
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
                    Column(
                      children: [
                        campos(campoUsuario, Textos.campoUsuario),
                        campos(campoEmail, Textos.campoEmail),
                      ],
                    ),
                  ],
                )),
            bottomSheet: Container(
              color: Colors.white,
              child: btnAcao(Textos.btnDesconectar, PaletaCores.corVermelha),
            ),
          );
        }
      },
    );
  }
}
