import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Modelos/emblemas.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Widgets/emblema_widget.dart';
import 'package:geoli/Widgets/exibir_emblemas.dart';
import 'package:geoli/Widgets/tela_carregamento.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  int pontuacaoEstados = 0;
  int pontuacaoSistemaSolar = 0;
  int pontuacaoGeral = 0;
  List<Emblemas> emblemasGeral = [];
  bool exibirTelaCarregamento = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recuperarPontuacao(Constantes.fireBaseColecaoRegioes,
        Constantes.fireBaseDocumentoPontosJogadaRegioes);
    recuperarPontuacao(Constantes.fireBaseColecaoSistemaSolar,
        Constantes.fireBaseDocumentoPontosJogadaSistemaSolar);

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

  somarPontuacoes() {
    print("dsf");
    pontuacaoGeral = pontuacaoEstados + pontuacaoSistemaSolar;
    MetodosAuxiliares.passarPontuacaoAtual(pontuacaoGeral);
  }

  // metodo para recuperar a pontuacao
  recuperarPontuacao(String nomeColecao, String nomeDocumento) async {
    var db = FirebaseFirestore.instance;
    //instanciano variavel
    db
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
              } else {
                pontuacaoSistemaSolar = value;
                somarPontuacoes();
                exibirTelaCarregamento = false;
              }
            });
          },
        );
      },
    );
  }

  String caminhoImagemEstado = CaminhosImagens.btnGestoEstadosBrasileiroImagem;
  String caminhoImagemSistemaSolar = CaminhosImagens.btnGestoSistemaSolarImagem;

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
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaSistemaSolar);
            } else if (nome == Textos.btnEstadoBrasileiros) {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaInicialRegioes);
            }
          },
          shape: RoundedRectangleBorder(
              side: BorderSide(color: PaletaCores.corOuro, width: 2),
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

    return LayoutBuilder(
      builder: (context, constraints) {
        if (exibirTelaCarregamento) {
          return TelaCarregamento();
        } else {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text(Textos.nomeApp),
              ),
              body: Container(
                color: Colors.white,
                width: larguraTela,
                height: alturaTela,
                child: Column(
                  children: [
                    SizedBox(
                        width: larguraTela,
                        child: Text(
                          Textos.descricaoTelaInicial,
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        )),
                    SizedBox(
                      height: alturaTela * 0.74,
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
                    )
                  ],
                ),
              ),
              bottomSheet: ExibirEmblemas(
                  pontuacaoAtual: pontuacaoGeral,
                  listaEmblemas: emblemasGeral,
                  corBordas: PaletaCores.corVerde));
        }
      },
    );
  }
}
