import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Modelos/emblemas.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Widgets/tela_carregamento_widget.dart';
import 'package:geoli/Widgets/widget_exibir_emblemas.dart';
import 'package:geoli/Widgets/widget_tela_resetar_dados.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial>
    with TickerProviderStateMixin {
  int pontuacaoEstados = 0;
  int pontuacaoSistemaSolar = 0;
  int pontuacaoGeral = 0;
  List<Emblemas> emblemasGeral = [];
  bool exibirTelaCarregamento = true;
  bool exibirTelaResetarJogo = false;
  int contador = 0;
  String nomeUsuario = "";
  String caminhoImagemEstado = CaminhosImagens.btnGestoEstadosBrasileiroImagem;
  String caminhoImagemSistemaSolar = CaminhosImagens.btnGestoSistemaSolarImagem;
  Color corPadrao = PaletaCores.corVerde;

  @override
  void initState() {
    super.initState();
    recuperarUsuario();
    emblemasGeral.addAll([
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteSoldado,
          nomeEmblema: Textos.emblemaPatenteSoldado,
          pontos: 0),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteCabo,
          nomeEmblema: Textos.emblemaPatenteCabo,
          pontos: 15),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteSargento,
          nomeEmblema: Textos.emblemaPatenteSargento,
          pontos: 30),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteSubTenente,
          nomeEmblema: Textos.emblemaPatenteSubTenente,
          pontos: 45),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteAspirante,
          nomeEmblema: Textos.emblemaPatenteAspirante,
          pontos: 60),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteTenente,
          nomeEmblema: Textos.emblemaPatenteTenente,
          pontos: 75),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteCapitao,
          nomeEmblema: Textos.emblemaPatenteCapitao,
          pontos: 90),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteMajor,
          nomeEmblema: Textos.emblemaPatenteMajor,
          pontos: 105),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteTenenteCoronel,
          nomeEmblema: Textos.emblemaPatenteTenenteCoronel,
          pontos: 120),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteCoronel,
          nomeEmblema: Textos.emblemaPatenteCoronel,
          pontos: 135),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteGeneralBrigada,
          nomeEmblema: Textos.emblemaPatenteGeneralBrigada,
          pontos: 150),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteGeneralDivisao,
          nomeEmblema: Textos.emblemaPatenteGeneralDivisao,
          pontos: 170),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteGeneralExercito,
          nomeEmblema: Textos.emblemaPatenteGeneralExercito,
          pontos: 185),
      Emblemas(
          caminhoImagem: CaminhosImagens.emblemaPatenteMarechal,
          nomeEmblema: Textos.emblemaPatenteMarechal,
          pontos: 200),
    ]);
  }

  recuperarNomeUsuario(String uidUsuario) async {
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
            nomeUsuario = value;
          });
        });
      },
    );
  }

  recuperarUsuario() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      contador = contador + 1;
      if (user != null) {
        print(user.uid);
        MetodosAuxiliares.passarUidUsuario(user.uid);
        if (mounted) {
          print("fdsdfcxvxcvxc");
          recuperarPontuacao(Constantes.fireBaseColecaoRegioes,
              Constantes.fireBaseDocumentoPontosJogadaRegioes, user.uid);
          recuperarNomeUsuario(user.uid);
        }
      } else {
        print(contador);
        if (contador >= 2 && contador <= 3) {
          if (mounted) {
            print("fdfds");
            MetodosAuxiliares.passarUidUsuario("");
            Navigator.pushReplacementNamed(
                context, Constantes.rotaTelaLoginCadastro);
          }
        }
      }
    });
  }

  // metodo para recuperar a pontuacao
  recuperarPontuacao(
      String nomeColecao, String nomeDocumento, String uidUsuario) async {
    var db = FirebaseFirestore.instance;
    //instanciano variavel
    db
        .collection(Constantes.fireBaseColecaoUsuarios) // passando a colecao
        .doc(uidUsuario)
        .collection(nomeColecao) // passando a colecao
        .doc(nomeDocumento) // passando documento
        .get()
        .then(
      (querySnapshot) async {
        querySnapshot.data()!.forEach(
          (key, value) {
            setState(() {
              if (nomeColecao == Constantes.fireBaseColecaoRegioes) {
                pontuacaoEstados = value;
                recuperarPontuacao(
                    Constantes.fireBaseColecaoSistemaSolar,
                    Constantes.fireBaseDocumentoPontosJogadaSistemaSolar,
                    uidUsuario);
              } else {
                pontuacaoSistemaSolar = value;
                pontuacaoGeral = pontuacaoEstados + pontuacaoSistemaSolar;
                //Passando pontuacao para
                // a tela de emblemas sem esse metodo o
                // emblema nao e exibido corretamente
                MetodosAuxiliares.passarPontuacaoAtual(pontuacaoGeral);
              }
            });
          },
        );
        exibirTelaCarregamento = false;
      },
    );
  }

  Widget cartao(String nomeImagem, String nome) => Container(
        margin: EdgeInsets.only(bottom: 20),
        width: 170,
        height: 170,
        child: FloatingActionButton(
          elevation: 0,
          heroTag: nome,
          backgroundColor: Colors.white,
          onPressed: () {
            if (nome == Textos.btnSistemaSolar) {
              MetodosAuxiliares.passarPontuacaoAtual(0);
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaSistemaSolar);
            } else if (nome == Textos.btnEstadoBrasileiros) {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaInicialRegioes);
            }
          },
          shape: RoundedRectangleBorder(
              side: BorderSide(color: corPadrao, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(40))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                height: 110,
                width: 110,
                image: AssetImage("$nomeImagem.png"),
              ),
              Text(
                nome,
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
    double alturaBarraStatus = MediaQuery.of(context).padding.top;
    double alturaAppBar = AppBar().preferredSize.height;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (exibirTelaCarregamento) {
          return TelaCarregamentoWidget(
            corPadrao: corPadrao,
          );
        } else {
          return Scaffold(
              appBar: AppBar(
                leading: Container(),
                backgroundColor: PaletaCores.corVerde,
                title: Text(
                  Textos.nomeApp,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                actions: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        Text(
                          Textos.descricaoTelaInicialNomeUsuario,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          nomeUsuario,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              body: Container(
                color: Colors.white,
                width: larguraTela,
                height: alturaTela - alturaAppBar - alturaBarraStatus,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          width: larguraTela,
                          height: 40,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                width: 50,
                                height: 50,
                                child: FloatingActionButton(
                                  heroTag: Textos.btnExcluir,
                                  elevation: 0,
                                  backgroundColor: Colors.white,
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: PaletaCores.corVerde)),
                                  onPressed: () {
                                    setState(() {
                                      exibirTelaResetarJogo =
                                          !exibirTelaResetarJogo;
                                    });
                                  },
                                  child: Icon(
                                    exibirTelaResetarJogo
                                        ? Icons.close
                                        : Icons.settings,
                                    color: corPadrao,
                                    size: 30,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                width: 50,
                                height: 50,
                                child: FloatingActionButton(
                                  heroTag: Textos.campoUsuario,
                                  backgroundColor: Colors.white,
                                  elevation: 0,
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: PaletaCores.corVerde)),
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(context,
                                        Constantes.rotaTelaUsuarioDetalhado);
                                  },
                                  child: Icon(
                                    Icons.person,
                                    color: corPadrao,
                                    size: 30,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            width: larguraTela,
                            child: Text(
                              Textos.descricaoTelaInicial,
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            )),
                        SizedBox(
                          height: alturaTela * 0.6,
                          width: larguraTela,
                          child: SingleChildScrollView(
                            child: Wrap(
                              alignment: WrapAlignment.spaceEvenly,
                              children: [
                                cartao(caminhoImagemEstado,
                                    Textos.btnEstadoBrasileiros),
                                cartao(caminhoImagemSistemaSolar,
                                    Textos.btnSistemaSolar),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                        visible: exibirTelaResetarJogo,
                        child: WidgetTelaResetarDados(
                          corCard: corPadrao,
                          tipoAcao: Constantes.resetarAcaoExcluirTudo,
                        ))
                  ],
                ),
              ),
              bottomSheet: WidgetExibirEmblemas(
                  pontuacaoAtual: pontuacaoGeral,
                  listaEmblemas: emblemasGeral,
                  nomeBtn: "",
                  corBordas: corPadrao));
        }
      },
    );
  }
}
