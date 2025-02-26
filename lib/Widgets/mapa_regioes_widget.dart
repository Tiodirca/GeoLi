import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Widgets/widget_tela_carregamento.dart';

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
  String caminhoImagemRegiao = CaminhosImagens.mapaCompletoBranco;

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
    setState(() {
      exibirTelaCarregamento = false;
    });
  }

  @override
  void initState() {
    super.initState();
    recuperarRegioesLiberadas();
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
          validarRegioesDesbloqueadas();
        });
      },
    );
  }

  Widget exibirEstrela(bool exibirEstrela, String nomeRegiao) => Visibility(
      visible: exibirEstrela,
      child: SizedBox(
          width: 170,
          height: 20,
          child: Row(
            children: [
              Icon(
                Icons.star,
                color: PaletaCores.corOuro,
              ),
              Text(
                nomeRegiao,
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          )));

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    return Container(
        width: larguraTela,
        height: 420,
        color: Colors.transparent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (exibirTelaCarregamento) {
              return WidgetTelaCarregamento(
                  corPadrao: Constantes.corPadraoRegioes);
            } else {
              return Column(
                children: [
                  Text(
                    Textos.telaTituloRegioesDesbloqueados,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(Textos.telaDescricaoRegioesDesbloqueados),
                  SizedBox(
                    width: larguraTela,
                    height: 300,
                    child: InteractiveViewer(
                      panEnabled: false,
                      minScale: 0.5,
                      maxScale: 4,
                      child: Image(
                        image: AssetImage("$caminhoImagemRegiao.png"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Platform.isIOS || Platform.isAndroid
                        ? larguraTela * 0.9
                        : larguraTela * 0.4,
                    height: 60,
                    child: Wrap(
                      children: [
                        exibirEstrela(
                            liberarRegiaoSul, Textos.nomeRegiaoCentroOeste),
                        exibirEstrela(
                            liberarRegiaoSudeste, Textos.nomeRegiaoSul),
                        exibirEstrela(
                            liberarRegiaoNorte, Textos.nomeRegiaoSudeste),
                        exibirEstrela(
                            liberarRegiaoNordeste, Textos.nomeRegiaoNorte),
                        exibirEstrela(
                            liberarTodosEstados, Textos.nomeRegiaoNordeste),
                      ],
                    ),
                  )
                ],
              );
            }
          },
        ));
  }
}
