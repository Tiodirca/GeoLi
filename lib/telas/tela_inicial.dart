import 'package:flutter/material.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/constantes_caminhos_imagens.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Uteis/paleta_cores.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String caminhoImagemEstado = CaminhosImagens.btnGestoEstadosBrasileiroImagem;
  String caminhoImagemSistemaSolar = CaminhosImagens.btnGestoSistemaSolarImagem;

  Widget cartao(String nomeImagem, String nome) => Container(
        margin: EdgeInsets.only(bottom: 20),
        width: 170,
        height: 170,
        child: FloatingActionButton(
          heroTag: nome,
          backgroundColor: Colors.white,
          onPressed: () {
            if (nome == Textos.btnSistemaSolar) {
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
                    cartao(caminhoImagemEstado, Textos.btnEstadoBrasileiros),
                    cartao(caminhoImagemSistemaSolar, Textos.btnSistemaSolar),
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
        child: Row(
          children: [],
        ),
      ),
    );
  }
}
