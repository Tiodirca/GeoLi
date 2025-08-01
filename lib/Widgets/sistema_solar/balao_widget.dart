import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/variaveis_constantes/constantes.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/passar_pegar_dados.dart.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Uteis/variaveis_constantes/constantes_sistema_solar.dart';
import 'package:geoli/modelos/planeta.dart';
import 'package:lottie/lottie.dart';

class BalaoWidget extends StatefulWidget {
  const BalaoWidget(
      {super.key, required this.planeta, required this.desativarBotao});

  final Planeta planeta;
  final bool desativarBotao;

  @override
  State<BalaoWidget> createState() => _BalaoWidgetState();
}

class _BalaoWidgetState extends State<BalaoWidget>
    with TickerProviderStateMixin {
  List<Color> listaCorBalao = [];
  Random random = Random();
  late Color corbalao;
  late String status;
  late String uidUsuario;
  bool exibirAnimacaoExplosao = false;
  List<Planeta> planetas = ConstantesSistemaSolar.adicinarPlanetas();

  @override
  void initState() {
    super.initState();
    listaCorBalao.addAll([
      Colors.redAccent,
      Colors.pinkAccent,
      Colors.blue,
      Colors.greenAccent,
      Colors.yellowAccent,
      Colors.cyan,
      Colors.purpleAccent,
      Colors.orange,
      Colors.deepOrangeAccent,
      Colors.deepPurpleAccent,
      Colors.lightGreen,
      Colors.grey,
    ]);
    corbalao = listaCorBalao.elementAt(sortearNumero(listaCorBalao.length));
    recuperarStatusTutorial();
    recuperarUIDUsuario();
  }

  recuperarUIDUsuario() async {
    uidUsuario = await PassarPegarDados.recuperarInformacoesUsuario()
        .values
        .elementAt(0);
  }

  tamanhoBalao(double larguraTela) {
    int tamanho = 200;
    //verificando qual o tamanho da tela
    if (larguraTela <= 400) {
      tamanho = 250;
    } else if (larguraTela > 400 && larguraTela <= 800) {
      tamanho = 250;
    } else if (larguraTela > 800 && larguraTela <= 1100) {
      tamanho = 300;
    } else if (larguraTela > 1100 && larguraTela <= 1300) {
      tamanho = 350;
    } else if (larguraTela > 1300) {
      tamanho = 400;
    }
    return tamanho;
  }

  recuperarStatusTutorial() async {
    status = await PassarPegarDados.recuperarStatusTutorial();
  }

  sortearNumero(int tamanhoLista) {
    int randomNumber = random.nextInt(tamanhoLista);
    return randomNumber;
  }

  confirmarAcertoTutorial() {
    MetodosAuxiliares.exibirMensagensDuranteJogo(
        Textos.tutorialConcluido, Constantes.msgAcerto, context);
    PassarPegarDados.passarStatusTutorial("");
    atualizarPontuacaoTutorial();
    setState(() {
      exibirAnimacaoExplosao = true;
    });
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, Constantes.rotaTelaSistemaSolar);
    });
  }

  validarAcerto() async {
    String gesto = "";
    gesto = await PassarPegarDados.recuperarGestoSorteado();
    // verificando se o status passado esta ativo
    if (status == Constantes.statusTutorialAtivo) {
      confirmarAcertoTutorial();
    } else {
      if (gesto.contains(widget.planeta.nomePlaneta)) {
        setState(() {
          exibirAnimacaoExplosao = true;
        });
        Timer(const Duration(seconds: 1), () {
          setState(() {
            exibirAnimacaoExplosao = false;
          });
        });
        PassarPegarDados.confirmarAcerto(Constantes.msgAcerto);
        recuperarPlanetasDesbloqueados();
      } else {
        PassarPegarDados.confirmarAcerto(Constantes.msgErro);
      }
    }
  }

  // metodo para gravar no banco de dados
  // que o planeta foi desbloqueado
  desbloquearPlaneta(String nomePlaneta) {
    Map<String, bool> dados = {};
    // percorrendo a lista para poder jogar os dados dentro de um map
    for (var element in planetas) {
      //definindo que o map vai receber o nome do planeta e o valor boleano
      dados[element.nomePlaneta] = element.desbloqueado;
      if (nomePlaneta == element.nomePlaneta) {
        // definindo que o map vai contendo o nome do planeta vai receber o valor boleano
        dados[element.nomePlaneta] = true;
      }
    }

    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(Constantes.fireBaseColecaoUsuarios) // passando a colecao
          .doc(uidUsuario)
          .collection(
              Constantes.fireBaseColecaoSistemaSolar) // passando a colecao
          .doc(Constantes
              .fireBaseDocumentoPlanetasDesbloqueados) //passando o documento
          .set(dados)
          .then((value) {}, onError: (e) {
        debugPrint("BDPON${e.toString()}");
      });
    } catch (e) {
      debugPrint("BDP${e.toString()}");
    }
  }

  // metodo para consultar o banco de dados
  recuperarPlanetasDesbloqueados() async {
    var db = FirebaseFirestore.instance;
    try {
      db
          .collection(Constantes.fireBaseColecaoUsuarios) // passando a colecao
          .doc(uidUsuario)
          .collection(
              Constantes.fireBaseColecaoSistemaSolar) // passando a colecao
          .doc(Constantes
              .fireBaseDocumentoPlanetasDesbloqueados) // passando documento
          .get()
          .then((querySnapshot) async {
        querySnapshot.data()!.forEach(
          (key, value) {
            setState(() {
              // percorendo a lista
              for (var element in planetas) {
                //verificando se o nome do elemento e igual ao nome do item na lista
                if (element.nomePlaneta == key) {
                  // caso for o campo do elemento vai receber o valor que esta no banco
                  element.desbloqueado = value;
                }
              }
            });
          },
        );
        // chamando metodo
        desbloquearPlaneta(widget.planeta.nomePlaneta);
      }, onError: (e) {
        debugPrint("RPON${e.toString()}");
      });
    } catch (e) {
      debugPrint("RP${e.toString()}");
    }
  }

  atualizarPontuacaoTutorial() async {
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(Constantes.fireBaseColecaoUsuarios) // passando a colecao
          .doc(uidUsuario)
          .collection(
              Constantes.fireBaseColecaoSistemaSolar) // passando a colecao
          .doc(Constantes
              .fireBaseDocumentoPontosJogadaSistemaSolar) //passando o documento
          .set({Constantes.pontosJogada: 1}).then((value) {}, onError: (e) {
        debugPrint("ATPONB${e.toString()}");
      });
    } catch (e) {
      debugPrint("ATPB${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 80,
        height: 170,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Image(
                      color: corbalao,
                      height: 80,
                      width: 80,
                      image: AssetImage(
                          '${CaminhosImagens.balaoCabelaImagem}.png'),
                    ),
                    Positioned(
                      child: SizedBox(
                          width: 80,
                          height: 80,
                          child: FloatingActionButton(
                            shape: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(50)),
                            foregroundColor: Colors.transparent,
                            elevation: 0,
                            hoverElevation: 0,
                            focusElevation: 0,
                            disabledElevation: 0,
                            enableFeedback: false,
                            hoverColor: Colors.transparent,
                            splashColor: corbalao,
                            focusColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Image(
                                height: 50,
                                width: 50,
                                image: AssetImage(
                                    '${widget.planeta.caminhoImagem}.png'),
                              ),
                            ),
                            onPressed: () {
                              if (!widget.desativarBotao) {
                                validarAcerto();
                              }
                            },
                          )),
                    ),
                    Visibility(
                      visible: exibirAnimacaoExplosao,
                      child: Lottie.asset(
                          reverse: true,
                          height: 80,
                          width: 80,
                          'assets/animacoes_lottie/explosao.json'),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Image(
                    height: 80,
                    width: 60,
                    image:
                        AssetImage('${CaminhosImagens.balaoCaldaImagem}.png'),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
