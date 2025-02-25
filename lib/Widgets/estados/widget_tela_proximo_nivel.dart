import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';

import '../../Uteis/paleta_cores.dart';
import '../../Uteis/textos.dart';

class WidgetTelaProximoNivel extends StatefulWidget {
  const WidgetTelaProximoNivel(
      {super.key, required this.estados, required this.nomeColecao});

  final List<MapEntry<Estado, Gestos>> estados;
  final String nomeColecao;

  @override
  State<WidgetTelaProximoNivel> createState() => _WidgetTelaProximoNivelState();
}

class _WidgetTelaProximoNivelState extends State<WidgetTelaProximoNivel> {
  Map<String, dynamic> dados = {};
  bool exibirBtnProximoNivel = true;
  bool liberarRegiaoSul = false;
  bool liberarRegiaoSudeste = false;
  bool liberarRegiaoNorte = false;
  bool liberarRegiaoNordeste = false;
  bool liberarTodosEstados = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carregarDados();
    if (widget.estados.length >= 10) {
      exibirBtnProximoNivel = false;
    }
    recuperarRegioesLiberadas();
  }

  // metodo para carregar os dados
  carregarDados() {
    for (var element in widget.estados) {
      // definindo que o estado vai receber o valor de falco
      dados[element.key.nome] = element.key.acerto = false;
    }
  }

  resetarDados() async {
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
          .doc(widget.nomeColecao) //passando o documento
          .set(dados);
    } catch (e) {
      print(e.toString());
    }
  }

  recuperarRegioesLiberadas() async {
    var db = FirebaseFirestore.instance;
    //instanciano variavel
    db
        .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
        .doc(Constantes.fireBaseDocumentoLiberarEstados) // passando documento
        .get()
        .then(
      (querySnapshot) async {
        // verificando cada item que esta gravado no banco de dados
        querySnapshot.data()!.forEach((key, value) {
          if (Textos.nomeRegiaoSul == key) {
            liberarRegiaoSul = value;
          } else if (Textos.nomeRegiaoSudeste == key) {
            liberarRegiaoSudeste = value;
          } else if (Textos.nomeRegiaoNorte == key) {
            liberarRegiaoNorte = value;
          } else if (Textos.nomeRegiaoNordeste == key) {
            liberarRegiaoNordeste = value;
          } else if (Constantes.nomeTodosEstados == key) {
            liberarTodosEstados = value;
          }
        });
      },
    );
  }

  // metodo para cadastrar item
  liberarProximoNivel() async {
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
          .doc(
              Constantes.fireBaseDocumentoLiberarEstados) //passando o documento
          .set({
        Textos.nomeRegiaoSul: liberarRegiaoSul,
        Textos.nomeRegiaoSudeste: liberarRegiaoSudeste,
        Textos.nomeRegiaoNorte: liberarRegiaoNorte,
        Textos.nomeRegiaoNordeste: liberarRegiaoNordeste,
        Constantes.nomeTodosEstados: liberarTodosEstados,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
   // print("dgdfg");
    // validarLiberarProximoNivel("");
    // liberarProximoNivel();
    super.dispose();
  }

  validarLiberarProximoNivel(String nomeBtn) {
    setState(() {
      if (widget.nomeColecao == Constantes.fireBaseDocumentoRegiaoCentroOeste) {
        liberarRegiaoSul = true;
        if (nomeBtn == Textos.btnProximoNivel) {
          Navigator.pushReplacementNamed(context, Constantes.rotaTelaRegiaoSul);
        }
      } else if (widget.nomeColecao == Constantes.fireBaseDocumentoRegiaoSul) {
        liberarRegiaoSudeste = true;
        if (nomeBtn == Textos.btnProximoNivel) {
          Navigator.pushReplacementNamed(
              context, Constantes.rotaTelaRegiaoSudeste);
        }
      } else if (widget.nomeColecao ==
          Constantes.fireBaseDocumentoRegiaoSudeste) {
        liberarRegiaoNorte = true;
        if (nomeBtn == Textos.btnProximoNivel) {
          Navigator.pushReplacementNamed(
              context, Constantes.rotaTelaRegiaoNorte);
        }
      } else if (widget.nomeColecao ==
          Constantes.fireBaseDocumentoRegiaoNorte) {
        liberarRegiaoNordeste = true;
        if (nomeBtn == Textos.btnProximoNivel) {
          Navigator.pushReplacementNamed(
              context, Constantes.rotaTelaRegiaoNordeste);
        }
      } else if (widget.nomeColecao ==
          Constantes.fireBaseDocumentoRegiaoNordeste) {
        liberarTodosEstados = true;
        if (nomeBtn == Textos.btnProximoNivel) {
          Navigator.pushReplacementNamed(
              context, Constantes.rotaTelaRegiaoTodosEstados);
        }
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
              if (widget.nomeColecao ==
                  Constantes.fireBaseDocumentoRegiaoCentroOeste) {
                resetarDados();
                Navigator.pushReplacementNamed(
                    context, Constantes.rotaTelaRegiaoCentroOeste);
              } else if (widget.nomeColecao ==
                  Constantes.fireBaseDocumentoRegiaoSul) {
                resetarDados();
                Navigator.pushReplacementNamed(
                    context, Constantes.rotaTelaRegiaoSul);
              } else if (widget.nomeColecao ==
                  Constantes.fireBaseDocumentoRegiaoSudeste) {
                resetarDados();
                Navigator.pushReplacementNamed(
                    context, Constantes.rotaTelaRegiaoSudeste);
              } else if (widget.nomeColecao ==
                  Constantes.fireBaseDocumentoRegiaoNorte) {
                resetarDados();
                Navigator.pushReplacementNamed(
                    context, Constantes.rotaTelaRegiaoNorte);
              } else if (widget.nomeColecao ==
                  Constantes.fireBaseDocumentoRegiaoNordeste) {
                resetarDados();
                Navigator.pushReplacementNamed(
                    context, Constantes.rotaTelaRegiaoNordeste);
              } else if (widget.nomeColecao ==
                  Constantes.fireBaseDocumentoRegiaoTodosEstados) {
                resetarDados();
                Navigator.pushReplacementNamed(
                    context, Constantes.rotaTelaRegiaoTodosEstados);
              }
            } else {
              validarLiberarProximoNivel(Textos.btnProximoNivel);
              liberarProximoNivel();
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
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        width: 400,
        height: 250,
        child: Card(
          color: Colors.white,
          shape:  RoundedRectangleBorder(
              side: BorderSide(color: Constantes.corPadraoRegioes),
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
