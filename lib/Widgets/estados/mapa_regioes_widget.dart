import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/variaveis_constantes/constantes.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/passar_pegar_dados.dart.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Uteis/variaveis_constantes/constantes_estados_gestos.dart';
import 'package:geoli/Widgets/tela_carregamento_widget.dart';
import 'package:geoli/Modelos/gestos.dart';

class MapaRegioesWidget extends StatefulWidget {
  const MapaRegioesWidget({
    super.key,
  });

  @override
  State<MapaRegioesWidget> createState() => _MapaRegioesWidgetState();
}

class _MapaRegioesWidgetState extends State<MapaRegioesWidget> {
  bool liberarRegiaoSul = false;
  bool liberarRegiaoSudeste = false;
  bool liberarRegiaoNorte = false;
  bool liberarRegiaoNordeste = false;
  bool liberarTodosEstados = false;
  bool exibirTelaCarregamento = true;
  bool exibirRegiaoGestosDetalhada = false;
  int contador = 0;
  late String uidUsuario;
  List<Estado> regioesSelecionadas = [];
  List<Gestos> gestosSelecionados = [];
  String caminhoImagemRegiao = CaminhosImagens.mapaCompletoBranco;
  Map<Estado, Gestos> estadoGestoMap = {};
  String nomeRegiao = "";
  bool exibirMensagemSemConexao = false;

  Estado regiaoCentroOeste = Estado(
      nome: Textos.nomeRegiaoCentroOeste,
      caminhoImagem: CaminhosImagens.gestoCentroOesteImagem,
      acerto: true);
  Estado regiaoSul = Estado(
      nome: Textos.nomeRegiaoSul,
      caminhoImagem: CaminhosImagens.gestoSulImagem,
      acerto: false);
  Estado regiaoSudeste = Estado(
      nome: Textos.nomeRegiaoSudeste,
      caminhoImagem: CaminhosImagens.gestoSudesteImagem,
      acerto: false);
  Estado regiaoNorte = Estado(
      nome: Textos.nomeRegiaoNorte,
      caminhoImagem: CaminhosImagens.gestoNorteImagem,
      acerto: false);
  Estado regiaoNordeste = Estado(
      nome: Textos.nomeRegiaoNordeste,
      caminhoImagem: CaminhosImagens.gestoNordesteImagem,
      acerto: false);

  Estado todasRegioes = Estado(
      nome: Textos.btnTodosEstados,
      caminhoImagem: CaminhosImagens.gestoRegioesImagem,
      acerto: false);

  validarRegioesDesbloqueadas() {
    if (liberarRegiaoSul && liberarRegiaoSudeste == false) {
      caminhoImagemRegiao = CaminhosImagens.mapaCompletoCentroOeste;
    } else if (liberarRegiaoSudeste && liberarRegiaoNorte == false) {
      caminhoImagemRegiao = CaminhosImagens.mapaCompletoSul;
    } else if (liberarRegiaoNorte && liberarRegiaoNordeste == false) {
      caminhoImagemRegiao = CaminhosImagens.mapaCompletoSudeste;
    } else if (liberarRegiaoNordeste && liberarTodosEstados == false) {
      caminhoImagemRegiao = CaminhosImagens.mapaCompletoNorte;
    }
    if (liberarTodosEstados) {
      caminhoImagemRegiao = CaminhosImagens.mapaCompleto;
    }
    if (mounted) {
      setState(() {
        exibirTelaCarregamento = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    estadoGestoMap = ConstantesEstadosGestos.adicionarEstadosGestos();
    recuperarUIDUsuario();
  }

  recuperarUIDUsuario() async {
    uidUsuario = await PassarPegarDados.recuperarInformacoesUsuario()
        .values
        .elementAt(0);
    recuperarRegioesLiberadas();
  }

  recuperarRegioes(Estado regiao) {
    estadoGestoMap.forEach(
      (key, value) {
        contador = contador + 1;
        if (contador < 4 && regiao.nome == regiaoCentroOeste.nome) {
          setState(() {
            regioesSelecionadas.add(key);
            gestosSelecionados.add(value);
            nomeRegiao = regiao.nome;
          });
        } else if (contador > 3 &&
            contador < 7 &&
            regiao.nome == regiaoSul.nome) {
          setState(() {
            regioesSelecionadas.add(key);
            gestosSelecionados.add(value);
            nomeRegiao = regiao.nome;
          });
        } else if (contador > 6 &&
            contador < 11 &&
            regiao.nome == regiaoSudeste.nome) {
          setState(() {
            regioesSelecionadas.add(key);
            gestosSelecionados.add(value);
            nomeRegiao = regiao.nome;
          });
        } else if (contador > 10 &&
            contador < 18 &&
            regiao.nome == regiaoNorte.nome) {
          setState(() {
            regioesSelecionadas.add(key);
            gestosSelecionados.add(value);
            nomeRegiao = regiao.nome;
          });
        } else if (contador > 17 &&
            contador < 27 &&
            regiao.nome == regiaoNordeste.nome) {
          setState(() {
            regioesSelecionadas.add(key);
            gestosSelecionados.add(value);
            nomeRegiao = regiao.nome;
          });
        }
      },
    );
  }

  chamarValidarErro(String erro) {
    MetodosAuxiliares.validarErro(erro, context);
  }

  redirecionarTelaLoginCadastro() {
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaLoginCadastro);
  }

  recuperarRegioesLiberadas() async {
    var db = FirebaseFirestore.instance;
    //instanciano variavel
    db
        .collection(Constantes.fireBaseColecaoUsuarios) // passando a colecao
        .doc(uidUsuario)
        .collection(Constantes.fireBaseColecaoRegioes) // passando a colecao
        .doc(Constantes.fireBaseDocumentoLiberarEstados) // passando documento
        .get()
        .then(
      (querySnapshot) async {
        // verificando cada item que esta gravado no banco de dados
        if (mounted) {
          if (querySnapshot.data() != null) {
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
          } else {
            redirecionarTelaLoginCadastro();
          }
        }
        validarRegioesDesbloqueadas();
      },
    ).timeout(
      Duration(seconds: Constantes.fireBaseDuracaoTimeOut),
      onTimeout: () {
        chamarValidarErro(Textos.erroUsuarioSemInternet);
        redirecionarTelaInicial();
      },
    );
  }

  redirecionarTelaInicial() {
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
  }

// conforme o tamanho da tela e
  // xibir determinda quantidade de colunas
  tamanhoListaGestosEstadoDetalhado(double larguraTela) {
    double tamanho = 5.0;
    //verificando qual o tamanho da tela
    if (larguraTela <= 600) {
      tamanho = 180.0;
    } else if (larguraTela > 600 && larguraTela <= 800) {
      tamanho = 180.0;
    } else if (larguraTela > 800 && larguraTela <= 1100) {
      tamanho = 180.0;
    } else if (larguraTela > 1100 && larguraTela <= 1300) {
      tamanho = 190.0;
    } else if (larguraTela > 1300) {
      tamanho = 200.0;
    }
    return tamanho;
  }

  // conforme o tamanho da tela exibir determinda quantidade de colunas
  tamanhoImagemGestosEstados(double larguraTela) {
    double tamanho = 170.0;
    //verificando qual o tamanho da tela
    if (larguraTela <= 600) {
      tamanho = 60.0;
    } else if (larguraTela > 600 && larguraTela <= 800) {
      tamanho = 60.0;
    } else if (larguraTela > 800 && larguraTela <= 1100) {
      tamanho = 60.0;
    } else if (larguraTela > 1100 && larguraTela <= 1300) {
      tamanho = 70.0;
    } else if (larguraTela > 1300) {
      tamanho = 80.0;
    }
    return tamanho;
  }

  Widget exibirDetalhesRegiaoDesbloqueada(bool exibir, Estado estado) =>
      Visibility(
          visible: exibir,
          child: Container(
              margin: EdgeInsets.only(right: 10, bottom: 10),
              width: 140,
              height: 50,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  if (estado.nome == Textos.nomeRegiaoCentroOeste) {
                    recuperarRegioes(regiaoCentroOeste);
                  } else if (estado.nome == Textos.nomeRegiaoSul) {
                    recuperarRegioes(regiaoSul);
                  } else if (estado.nome == Textos.nomeRegiaoSudeste) {
                    recuperarRegioes(regiaoSudeste);
                  } else if (estado.nome == Textos.nomeRegiaoNorte) {
                    recuperarRegioes(regiaoNorte);
                  } else if (estado.nome == Textos.nomeRegiaoNordeste) {
                    recuperarRegioes(regiaoNordeste);
                  }
                  setState(() {
                    exibirRegiaoGestosDetalhada = true;
                  });
                },
                shape: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1,
                        color: ConstantesEstadosGestos.corPadraoRegioes),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Image(
                      height: 50,
                      width: 50,
                      image: AssetImage('${estado.caminhoImagem}.png'),
                    ),
                    SizedBox(
                      width: 90,
                      child: Text(
                        estado.nome,
                        maxLines: 2,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    )
                  ],
                ),
              )));

  Widget imagemRegiaoGesto(
          String nome, String caminhoImagem, double larguraTela) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            height: tamanhoImagemGestosEstados(larguraTela),
            width: tamanhoImagemGestosEstados(larguraTela),
            image: AssetImage('$caminhoImagem.png'),
          ),
          SizedBox(
            width: 100,
            child: Text(
              nome,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (exibirTelaCarregamento) {
          return Container(
            margin: EdgeInsets.all(10),
            child: TelaCarregamentoWidget(
                corPadrao: ConstantesEstadosGestos.corPadraoRegioes),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      Textos.telaTituloRegioesDesbloqueados,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      Textos.telaDescricaoRegioesDesbloqueados,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (exibirRegiaoGestosDetalhada) {
                      return SizedBox(
                          width: kIsWeb
                              ? larguraTela * 0.9
                              : Platform.isIOS || Platform.isAndroid
                                  ? larguraTela * 0.9
                                  : larguraTela * 0.4,
                          height: 300,
                          child: Card(
                            color: Colors.white,
                            shape: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: ConstantesEstadosGestos
                                        .corPadraoRegioes),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  nomeRegiao,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: larguraTela,
                                  height: tamanhoListaGestosEstadoDetalhado(
                                      larguraTela),
                                  child: ListView.builder(
                                    itemCount: regioesSelecionadas.length,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          imagemRegiaoGesto(
                                              regioesSelecionadas
                                                  .elementAt(index)
                                                  .nome,
                                              regioesSelecionadas
                                                  .elementAt(index)
                                                  .caminhoImagem,
                                              larguraTela),
                                          imagemRegiaoGesto(
                                              gestosSelecionados
                                                  .elementAt(index)
                                                  .nomeGesto,
                                              gestosSelecionados
                                                  .elementAt(index)
                                                  .nomeImagem,
                                              larguraTela),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  width: 40,
                                  height: 40,
                                  child: FloatingActionButton(
                                    backgroundColor: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        exibirRegiaoGestosDetalhada = false;
                                        regioesSelecionadas.clear();
                                        gestosSelecionados.clear();
                                        contador = 0;
                                      });
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: PaletaCores.corVermelha,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ));
                    } else {
                      return Column(
                        children: [
                          SizedBox(
                            width: larguraTela,
                            height: 200,
                            child: InteractiveViewer(
                              panEnabled: false,
                              minScale: 0.5,
                              maxScale: 4,
                              child: Image(
                                image: AssetImage("$caminhoImagemRegiao.png"),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: kIsWeb
                                ? larguraTela * 0.9
                                : Platform.isIOS || Platform.isAndroid
                                    ? larguraTela * 0.9
                                    : larguraTela * 0.4,
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                exibirDetalhesRegiaoDesbloqueada(
                                    liberarRegiaoSul, regiaoCentroOeste),
                                exibirDetalhesRegiaoDesbloqueada(
                                    liberarRegiaoSudeste, regiaoSul),
                                exibirDetalhesRegiaoDesbloqueada(
                                    liberarRegiaoNorte, regiaoSudeste),
                                exibirDetalhesRegiaoDesbloqueada(
                                    liberarRegiaoNordeste, regiaoNorte),
                                exibirDetalhesRegiaoDesbloqueada(
                                    liberarTodosEstados, regiaoNordeste),
                              ],
                            ),
                          )
                        ],
                      );
                    }
                  },
                )
              ],
            ),
          );
        }
      },
    );
  }
}
