import 'package:flutter/material.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/constantes_caminhos_imagens.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Uteis/paleta_cores.dart';

class TelaInicialRegioes extends StatefulWidget {
  const TelaInicialRegioes({super.key});

  @override
  State<TelaInicialRegioes> createState() => _TelaInicialRegioesState();
}

class _TelaInicialRegioesState extends State<TelaInicialRegioes> {
  Estado regiaoCentroOeste = Estado(
      nome: Constantes.nomeRegiaoCentroOeste,
      caminhoImagem: CaminhosImagens.gestoCentroOesteImagem,
      acerto: true);
  Estado regiaoSul = Estado(
      nome: Constantes.nomeRegiaoSul,
      caminhoImagem: CaminhosImagens.gestoSulImagem,
      acerto: true);
  Estado regiaoSudeste = Estado(
      nome: Constantes.nomeRegiaoSudeste,
      caminhoImagem: CaminhosImagens.gestoSudesteImagem,
      acerto: true);
  Estado regiaoNorte = Estado(
      nome: Constantes.nomeRegiaoNorte,
      caminhoImagem: CaminhosImagens.gestoNorteImagem,
      acerto: true);
  Estado regiaoNordeste = Estado(
      nome: Constantes.nomeRegiaoNordeste,
      caminhoImagem: CaminhosImagens.gestoNordesteImagem,
      acerto: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget cartaoRegiao(String nomeImagem, String nomeRegiao) => Container(
        margin: EdgeInsets.only(bottom: 20),
        width: 150,
        height: 170,
        child: FloatingActionButton(
          heroTag: nomeRegiao,
          backgroundColor: Colors.white,
          onPressed: () {
            if (nomeRegiao == regiaoCentroOeste.nome) {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaRegiaoCentroOeste);
            } else if (nomeRegiao == regiaoSul.nome) {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaRegiaoSul);
            } else if (nomeRegiao == regiaoSudeste.nome) {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaRegiaoSudeste);
            } else if (nomeRegiao == regiaoNorte.nome) {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaRegiaoNorte);
            } else if (nomeRegiao == regiaoNordeste.nome) {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaRegiaoNordeste);
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
                nomeRegiao,
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(Textos.tituloTelaRegioes),
        leading: IconButton(
            color: Colors.black,
            //setando tamanho do icone
            iconSize: 30,
            enableFeedback: false,
            onPressed: () {
              // Navigator.pushReplacementNamed(
              //     context, Constantes.rotaTelaInicialRegioes);
            },
            icon: const Icon(Icons.arrow_back_ios)),
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
                  Textos.descricaoTelaRegioes,
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                )),
            SizedBox(
              height: alturaTela * 0.74,
              width: larguraTela,
              child: SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  children: [
                    cartaoRegiao(regiaoCentroOeste.caminhoImagem,
                        regiaoCentroOeste.nome),
                    Visibility(
                        visible: regiaoSul.acerto,
                        child: cartaoRegiao(
                            regiaoSul.caminhoImagem, regiaoSul.nome)),
                    Visibility(
                        visible: regiaoSudeste.acerto,
                        child: cartaoRegiao(
                            regiaoSudeste.caminhoImagem, regiaoSudeste.nome)),
                    Visibility(
                        visible: regiaoNorte.acerto,
                        child: cartaoRegiao(
                            regiaoNorte.caminhoImagem, regiaoNorte.nome)),
                    Visibility(
                        visible: regiaoNordeste.acerto,
                        child: cartaoRegiao(
                            regiaoNordeste.caminhoImagem, regiaoNordeste.nome)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: larguraTela,
        color: Colors.grey,
        height: 60,
      ),
    );
  }
}
