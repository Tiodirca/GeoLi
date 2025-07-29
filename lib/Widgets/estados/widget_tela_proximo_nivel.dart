import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/variaveis_constantes/constantes.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/passar_pegar_dados.dart.dart';
import 'package:geoli/Uteis/variaveis_constantes/constantes_estados_gestos.dart';

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
  late String uidUsuario;
  String nomeRota = "";

  @override
  void initState() {
    super.initState();
    recuperarUIDUsuario();
    carregarDados();
    //caso o tamnho seja maior que o passado nao exibir o btn
    if (widget.estados.length >= 10) {
      exibirBtnProximoNivel = false;
    }
  }

  recuperarUIDUsuario() async {
    uidUsuario = await PassarPegarDados.recuperarInformacoesUsuario()
        .values
        .elementAt(0);
    recuperarRegioesLiberadas();
  }

  // metodo para carregar os dados
  carregarDados() {
    for (var element in widget.estados) {
      // definindo que o estado vai receber o valor de falco
      dados[element.key.nome] = element.key.acerto = false;
    }
  }

  Future<bool> resetarDadosBancoDados() async {
    bool retorno = false;
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      await db
          .collection(Constantes.fireBaseColecaoUsuarios) // passando a colecao
          .doc(uidUsuario)
          .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
          .doc(widget.nomeColecao) //passando o documento
          .set(dados)
          .then((value) {
        retorno = true;
      }, onError: (e) {
        retorno = false;
        chamarValidarErro(e.toString());
        debugPrint("RDON${e.toString()}");
      });
    } catch (e) {
      retorno = false;
      chamarValidarErro(e.toString());
      debugPrint("RD${e.toString()}");
    }
    return retorno;
  }

  recuperarRegioesLiberadas() async {
    var db = FirebaseFirestore.instance;
    //instanciano variavel
    try {
      db
          .collection(Constantes.fireBaseColecaoUsuarios) // passando a colecao
          .doc(uidUsuario)
          .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
          .doc(Constantes.fireBaseDocumentoLiberarEstados) // passando documento
          .get()
          .then((querySnapshot) async {
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
        validarLiberarProximoNivel();
        liberarProximoNivelBancoDados();
      }, onError: (e) {
        chamarValidarErro(e.toString());
        debugPrint("RLON${e.toString()}");
      });
    } catch (e) {
      chamarValidarErro(e.toString());
      debugPrint("RL${e.toString()}");
    }
  }

  // metodo para cadastrar item
  Future<bool> liberarProximoNivelBancoDados() async {
    bool retorno = false;
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      await db
          .collection(Constantes.fireBaseColecaoUsuarios) // passando a colecao
          .doc(uidUsuario)
          .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
          .doc(
              Constantes.fireBaseDocumentoLiberarEstados) //passando o documento
          .set({
        Textos.nomeRegiaoSul: liberarRegiaoSul,
        Textos.nomeRegiaoSudeste: liberarRegiaoSudeste,
        Textos.nomeRegiaoNorte: liberarRegiaoNorte,
        Textos.nomeRegiaoNordeste: liberarRegiaoNordeste,
        Constantes.nomeTodosEstados: liberarTodosEstados,
      }).then((value) {
        retorno = true;
      }, onError: (e) {
        retorno = false;
        debugPrint("LPON ${e.toString()}");
      });
    } catch (e) {
      retorno = false;
      debugPrint("LP${e.toString()}");
    }
    return retorno;
  }

  validarLiberarProximoNivel() async {
    if (mounted) {
      setState(() {
        if (widget.nomeColecao ==
            Constantes.fireBaseDocumentoRegiaoCentroOeste) {
          liberarRegiaoSul = true;
        } else if (widget.nomeColecao ==
            Constantes.fireBaseDocumentoRegiaoSul) {
          liberarRegiaoSudeste = true;
        } else if (widget.nomeColecao ==
            Constantes.fireBaseDocumentoRegiaoSudeste) {
          liberarRegiaoNorte = true;
        } else if (widget.nomeColecao ==
            Constantes.fireBaseDocumentoRegiaoNorte) {
          liberarRegiaoNordeste = true;
        } else if (widget.nomeColecao ==
            Constantes.fireBaseDocumentoRegiaoNordeste) {
          liberarTodosEstados = true;
        }
      });
    }
  }

  redirecionarTelaParaProximoNivel() async {
    if (mounted) {
      setState(() {
        if (widget.nomeColecao ==
            Constantes.fireBaseDocumentoRegiaoCentroOeste) {
          Navigator.pushReplacementNamed(context, Constantes.rotaTelaRegiaoSul);
        } else if (widget.nomeColecao ==
            Constantes.fireBaseDocumentoRegiaoSul) {
          Navigator.pushReplacementNamed(
              context, Constantes.rotaTelaRegiaoSudeste);
        } else if (widget.nomeColecao ==
            Constantes.fireBaseDocumentoRegiaoSudeste) {
          Navigator.pushReplacementNamed(
              context, Constantes.rotaTelaRegiaoNorte);
        } else if (widget.nomeColecao ==
            Constantes.fireBaseDocumentoRegiaoNorte) {
          Navigator.pushReplacementNamed(
              context, Constantes.rotaTelaRegiaoNordeste);
        } else if (widget.nomeColecao ==
            Constantes.fireBaseDocumentoRegiaoNordeste) {
          Navigator.pushReplacementNamed(
              context, Constantes.rotaTelaRegiaoTodosEstados);
        }
      });
    }
  }

  redirecionarTelaJogarNovamente() {
    if (widget.nomeColecao == Constantes.fireBaseDocumentoRegiaoCentroOeste) {
      Navigator.pushReplacementNamed(
          context, Constantes.rotaTelaRegiaoCentroOeste);
    } else if (widget.nomeColecao == Constantes.fireBaseDocumentoRegiaoSul) {
      Navigator.pushReplacementNamed(context, Constantes.rotaTelaRegiaoSul);
    } else if (widget.nomeColecao ==
        Constantes.fireBaseDocumentoRegiaoSudeste) {
      Navigator.pushReplacementNamed(context, Constantes.rotaTelaRegiaoSudeste);
    } else if (widget.nomeColecao == Constantes.fireBaseDocumentoRegiaoNorte) {
      Navigator.pushReplacementNamed(context, Constantes.rotaTelaRegiaoNorte);
    } else if (widget.nomeColecao ==
        Constantes.fireBaseDocumentoRegiaoNordeste) {
      Navigator.pushReplacementNamed(
          context, Constantes.rotaTelaRegiaoNordeste);
    } else if (widget.nomeColecao ==
        Constantes.fireBaseDocumentoRegiaoTodosEstados) {
      Navigator.pushReplacementNamed(
          context, Constantes.rotaTelaRegiaoTodosEstados);
    }
  }

  redirecionarTelaInicial() {
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
  }

  Widget cardOpcoes(
          String nomeImagem, String nomeOpcao, BuildContext context) =>
      SizedBox(
        width: 130,
        height: 170,
        child: FloatingActionButton(
          heroTag: nomeOpcao,
          backgroundColor: Colors.white,
          onPressed: () async {
            if (nomeOpcao == Textos.btnJogarNovamente) {
              bool retorno = await resetarDadosBancoDados();
              if (retorno) {
                redirecionarTelaJogarNovamente();
              }
            } else {
              validarLiberarProximoNivel();
              bool retorno = await liberarProximoNivelBancoDados();
              if (retorno) {
                redirecionarTelaParaProximoNivel();
              } else {
                redirecionarTelaInicial();
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

  chamarValidarErro(String erro) {
    MetodosAuxiliares.validarErro(erro, context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        width: 400,
        height: 250,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: ConstantesEstadosGestos.corPadraoRegioes),
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
                mainAxisAlignment: exibirBtnProximoNivel == true
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.center,
                children: [
                  cardOpcoes(CaminhosImagens.btnNovamenteGesto,
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
