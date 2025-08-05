import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Modelos/emblemas.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/passar_pegar_dados.dart.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Widgets/emblema_widget.dart';
import 'package:geoli/Widgets/estados/mapa_regioes_widget.dart';
import 'package:geoli/Widgets/sistema_solar/planetas_desbloqueados_widget.dart';

class WidgetExibirEmblemas extends StatefulWidget {
  const WidgetExibirEmblemas(
      {super.key,
      required this.listaEmblemas,
      required this.corBordas,
      required this.pontuacaoAtual,
      required this.nomeBtn});

  final List<Emblemas> listaEmblemas;
  final Color corBordas;
  final int pontuacaoAtual;
  final String nomeBtn;

  @override
  State<WidgetExibirEmblemas> createState() => _WidgetExibirEmblemasState();
}

class _WidgetExibirEmblemasState extends State<WidgetExibirEmblemas> {
  bool exibirTela = false;
  bool exibirAreaInternaTela = false;
  bool exibirMapaRegioes = false;
  bool exibirSistemaSolar = false;
  late int pontuacaoAtualTela = 0;

  // metodo para verficar e retornar o emblema correspondente
  // pontuacao
  exibirEmblemaAtual(int pontuacaoAtual) {
    late Emblemas emblemas;
    // percorrendo a lista de emblemas passado para a tela
    for (int i = 0; i < widget.listaEmblemas.length; i++) {
      // caso o elemento PONTOS for MENOR ou IGUAL a pontuacaoAtual
      // a variavel vai receber o emblema que satisfaz a condicao
      if (widget.listaEmblemas.elementAt(i).pontos <= pontuacaoAtual) {
        emblemas = widget.listaEmblemas.elementAt(i);
      }
    }
    return emblemas;
  }

  //metodo para exibir a imagem ao botao correto
  exibirImagemBtn(String nomeBtn) {
    String caminhoImagem = "";
    if (nomeBtn == Textos.btnRegioesMapa) {
      caminhoImagem = CaminhosImagens.gestoMapa;
    } else if (nomeBtn == Textos.btnSistemaSolar) {
      caminhoImagem = CaminhosImagens.btnGestoSistemaSolarImagem;
    } else if (nomeBtn == Textos.btnEmblemas) {
      caminhoImagem = CaminhosImagens.gestoEmblemas;
    }
    return caminhoImagem;
  }

  Widget btnAcao(bool visibilidade, String nomeBtn, bool desativarBtn) =>
      Visibility(
          visible: visibilidade,
          child: SizedBox(
            width: 80,
            height: 120,
            child: FloatingActionButton(
                heroTag: nomeBtn,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  side: BorderSide(color: widget.corBordas),
                ),
                backgroundColor: Colors.white,
                onPressed: () {
                  setState(() {
                    exibirTela = true;
                    //definindo Delay para evitar dar erro de tamanho
                    Future.delayed(Duration(seconds: 1)).then(
                      (value) {
                        setState(() {
                          exibirAreaInternaTela = true;
                          if (nomeBtn == Textos.btnRegioesMapa) {
                            exibirMapaRegioes = true;
                          } else if (nomeBtn == Textos.btnSistemaSolar) {
                            exibirSistemaSolar = true;
                          } else {
                            exibirSistemaSolar = false;
                            exibirMapaRegioes = false;
                          }
                        });
                      },
                    );
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      height: 70,
                      width: 70,
                      image: AssetImage("${exibirImagemBtn(nomeBtn)}.png"),
                    ),
                    Text(
                      nomeBtn,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                )),
          ));

  validarTamanhoGestos(double largura) {
    if (largura <= 600) {
      return 70.0;
    } else if (largura > 600 && largura <= 1000) {
      return 90.0;
    } else if (largura > 1000) {
      return 100.0;
    }
  }

  validarTamanhoLarguraBotao(double largura) {
    if (largura <= 600) {
      return 130.0;
    } else if (largura > 600 && largura <= 1000) {
      return 150.0;
    } else if (largura > 1000) {
      return 140.0;
    }
  }

  validarTamanhoAlturaBotao(double largula) {
    if (largula <= 600) {
      return 140.0;
    } else if (largula > 600 && largula <= 1000) {
      return 150.0;
    } else if (largula > 1000) {
      return 170.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    return AnimatedContainer(
        color: Colors.white,
        width: larguraTela,
        height: exibirTela ? alturaTela * 0.8 : 130,
        duration: const Duration(seconds: 1),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: larguraTela,
                height: 130,
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: kIsWeb
                            ? validarTamanhoAlturaBotao(larguraTela)
                            : Platform.isAndroid || Platform.isIOS
                                ? larguraTela * 0.55
                                : larguraTela * 0.2,
                        height: 60,
                        child: ListView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            // recuperando a pontuacao atual da tela que esta sendo exibida
                            // para poder exibir o emblema correspondente a atual pontuacao
                            PassarPegarDados.recuperarPontuacaoAtual().then(
                              (value) {
                                setState(() {
                                  // definindo que a variavel
                                  // vai receber o seguinte valor
                                  pontuacaoAtualTela = value;
                                });
                              },
                            );
                            // retornando o widget passando a variavel para o metodo
                            return EmblemaWidget(
                                caminhoImagem:
                                    exibirEmblemaAtual(pontuacaoAtualTela)
                                        .caminhoImagem,
                                nomeEmblema:
                                    exibirEmblemaAtual(pontuacaoAtualTela)
                                        .nomeEmblema,
                                pontos: widget.pontuacaoAtual);
                          },
                        ),
                      ),
                      btnAcao(true, Textos.btnEmblemas, !exibirTela),
                      btnAcao(
                        widget.nomeBtn == Textos.btnRegioesMapa ||
                                widget.nomeBtn == Textos.btnSistemaSolar
                            ? true
                            : false,
                        widget.nomeBtn,
                        !exibirTela,
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: exibirAreaInternaTela,
                child: Column(
                  children: [
                    Visibility(
                      visible: widget.nomeBtn == Textos.btnRegioesMapa ||
                              widget.nomeBtn == Textos.btnSistemaSolar
                          ? false
                          : true,
                      child: Text(
                        Textos.telaEmblemasArrastar,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border(
                              top:
                                  BorderSide(width: 1, color: widget.corBordas),
                              left:
                                  BorderSide(width: 1, color: widget.corBordas),
                              right:
                                  BorderSide(width: 1, color: widget.corBordas),
                              bottom: BorderSide(
                                  width: 1, color: widget.corBordas)),
                        ),
                        width: larguraTela * 0.9,
                        height: alturaTela * 0.5,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            if (exibirMapaRegioes) {
                              return MapaRegioesWidget();
                            }
                            if (exibirSistemaSolar) {
                              return PlanetasDesbloqueadosWidget(
                                  corPadrao: widget.corBordas);
                            } else {
                              return ListView.builder(
                                itemCount: widget.listaEmblemas.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    shadowColor: widget.corBordas,
                                    color: Colors.white,
                                    child: EmblemaWidget(
                                        caminhoImagem: widget.listaEmblemas
                                            .elementAt(index)
                                            .caminhoImagem,
                                        nomeEmblema: widget.listaEmblemas
                                            .elementAt(index)
                                            .nomeEmblema,
                                        pontos: widget.listaEmblemas
                                            .elementAt(index)
                                            .pontos),
                                  );
                                },
                              );
                            }
                          },
                        )),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: 40,
                      height: 40,
                      child: FloatingActionButton(
                        heroTag: exibirAreaInternaTela.toString(),
                        backgroundColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            exibirTela = false;
                            exibirAreaInternaTela = false;
                          });
                        },
                        child: Icon(
                          Icons.close,
                          size: 30,
                          color: PaletaCores.corVermelha,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
