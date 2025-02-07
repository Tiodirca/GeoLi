import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/constantes_caminhos_imagens.dart';

import '../Uteis/paleta_cores.dart';
import '../Uteis/textos.dart';

class TelaProximoNivel extends StatefulWidget {
  const TelaProximoNivel({super.key, required this.estados});

  final List<MapEntry<Estado, Gestos>> estados;

  @override
  State<TelaProximoNivel> createState() => _TelaProximoNivelState();
}

class _TelaProximoNivelState extends State<TelaProximoNivel> {
  String nomeColecao = "";
  String nomeRegiao = "";
  Map<String, dynamic> dados = {};
  bool exibirBtnProximoNivel = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carregarDados();
    if (widget.estados.length >= 10) {
      exibirBtnProximoNivel = false;
    }
  }

  carregarDados() {
    for (var element in widget.estados) {
      dados[element.key.nome] = element.key.acerto = false;
      validarRegiao(element.key.nome);
    }
  }

  // metodo para fazer atualizacao no banco de dado
  // toda vez que o usuario acertar o estado correto
  resetarDados() async {
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
          .doc(nomeColecao) //passando o documento
          .set(dados);
    } catch (e) {
      print(e.toString());
    }
  }

  validarRegiao(String nome) {
    setState(() {
      if (nome.contains(Constantes.nomeRegiaoCentroMS)) {
        nomeColecao = Constantes.fireBaseDocumentoRegiaoCentroOeste;
        nomeRegiao = Constantes.nomeRegiaoCentroOeste;
      } else if (nome.contains(Constantes.nomeRegiaoSulPR)) {
        nomeColecao = Constantes.fireBaseDocumentoRegiaoSul;
        nomeRegiao = Constantes.nomeRegiaoSul;
      } else if (nome.contains(Constantes.nomeRegiaoSudesteSP)) {
        nomeColecao = Constantes.fireBaseDocumentoRegiaoSudeste;
        nomeRegiao = Constantes.nomeRegiaoSudeste;
      } else if (nome.contains(Constantes.nomeRegiaoNorteAM)) {
        nomeColecao = Constantes.fireBaseDocumentoRegiaoNorte;
        nomeRegiao = Constantes.nomeRegiaoNorte;
      } else if (nome.contains(Constantes.nomeRegiaoNordesteAL)) {
        nomeColecao = Constantes.fireBaseDocumentoRegiaoNordeste;
        nomeRegiao = Constantes.nomeRegiaoNordeste;
      }
    });
  }

  Widget cardOpcoes(
          String nomeImagem, String nomeOpcao, BuildContext context) =>
      SizedBox(
        width: 130,
        height: 170,
        child: FloatingActionButton(
          heroTag: nomeOpcao,
          backgroundColor: Colors.white,
          onPressed: () {
            if (nomeOpcao == Textos.btnJogarNovamente) {
              if (nomeRegiao == Constantes.nomeRegiaoCentroOeste) {
                resetarDados();
                Navigator.pushReplacementNamed(
                    context, Constantes.rotaTelaRegiaoCentroOeste);
              } else if (nomeRegiao == Constantes.nomeRegiaoSul) {
                resetarDados();
                Navigator.pushReplacementNamed(
                    context, Constantes.rotaTelaRegiaoSul);
              } else if (nomeRegiao == Constantes.nomeRegiaoSudeste) {
                resetarDados();
                Navigator.pushReplacementNamed(
                    context, Constantes.rotaTelaRegiaoSudeste);
              } else if (nomeRegiao == Constantes.nomeRegiaoNorte) {
                resetarDados();
                Navigator.pushReplacementNamed(
                    context, Constantes.rotaTelaRegiaoNorte);
              } else if (nomeRegiao == Constantes.nomeRegiaoNordeste) {
                resetarDados();
                Navigator.pushReplacementNamed(
                    context, Constantes.rotaTelaRegiaoNordeste);
              }
            } else {
              if (nomeRegiao == Constantes.nomeRegiaoCentroOeste) {
                Navigator.pushReplacementNamed(
                    context, Constantes.rotaTelaRegiaoSul);
              } else if (nomeRegiao == Constantes.nomeRegiaoSul) {
                Navigator.pushReplacementNamed(
                    context, Constantes.rotaTelaRegiaoSudeste);
              } else if (nomeRegiao == Constantes.nomeRegiaoSudeste) {
                Navigator.pushReplacementNamed(
                    context, Constantes.rotaTelaRegiaoNorte);
              } else if (nomeRegiao == Constantes.nomeRegiaoNorte) {
                Navigator.pushReplacementNamed(
                    context, Constantes.rotaTelaRegiaoNordeste);
              }
            }
          },
          elevation: 0,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: PaletaCores.corLaranja, width: 1),
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
                nomeOpcao,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black),
              )
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 400,
        height: 250,
        child: Card(
          color: Colors.white,
          shape: const RoundedRectangleBorder(
              side: BorderSide(color: PaletaCores.corAzulMagenta),
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                Textos.btnProximoNivel,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  cardOpcoes(CaminhosImagens.btnJogarNovamenteGesto,
                      Textos.btnJogarNovamente, context),
                  Visibility(
                      visible: exibirBtnProximoNivel,
                      child: cardOpcoes(CaminhosImagens.btnProximoNivelGesto,
                          Textos.btnProximoNivel, context))
                ],
              )
            ],
          ),
        ));
  }
}
