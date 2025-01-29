import 'package:flutter/material.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Uteis/constantes.dart';
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
      nomeImagem: Constantes.gestoCentroOesteImagem);
  Estado regiaoSul = Estado(
      nome: Constantes.nomeRegiaoSul, nomeImagem: Constantes.gestoSulImagem);
  Estado regiaoSudeste = Estado(
      nome: Constantes.nomeRegiaoCentroOeste,
      nomeImagem: Constantes.gestoCentroOesteImagem);
  Estado regiaoNordeste = Estado(
      nome: Constantes.nomeRegiaoCentroOeste,
      nomeImagem: Constantes.gestoCentroOesteImagem);
  Estado regiaoNorte = Estado(
      nome: Constantes.nomeRegiaoSul, nomeImagem: Constantes.gestoSulImagem);

  Widget cartaoRegiao(String nomeImagem, String nomeRegiao) => SizedBox(
        width: 130,
        height: 170,
        child: FloatingActionButton(
          heroTag: nomeRegiao,
          backgroundColor: Colors.white,
          onPressed: () {
            if (nomeRegiao == regiaoCentroOeste.nome) {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaRegiaoCentroOeste);
            } else if (nomeRegiao == regiaoSul.nome) {
              // Navigator.pushReplacementNamed(
              //     context, Constantes.rotaTelaRegiaoCentroOeste);
            }
          },
          shape: RoundedRectangleBorder(
              side: BorderSide(color: PaletaCores.corOuro, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
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
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          children: [
            cartaoRegiao(regiaoCentroOeste.nomeImagem, regiaoCentroOeste.nome),
            cartaoRegiao(regiaoSul.nomeImagem, regiaoSul.nome),
            cartaoRegiao(regiaoCentroOeste.nomeImagem, regiaoCentroOeste.nome),
            cartaoRegiao(regiaoSul.nomeImagem, regiaoSul.nome)
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: larguraTela,
        color: Colors.grey,
        height: 100,
      ),
    );
  }
}
