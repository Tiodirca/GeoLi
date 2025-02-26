import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/textos.dart';

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
    }if (liberarTodosEstados) {
      caminhoImagemRegiao = CaminhosImagens.mapaCompleto;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
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
          }else if (Constantes.nomeTodosEstados == key) {
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
          width: 200,
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
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    return Container(
        width: larguraTela,
        height: alturaTela,
        color: Colors.transparent,
        child: Stack(
          children: [
            SizedBox(
              width: larguraTela,
              height: alturaTela,
              child: InteractiveViewer(
                panEnabled: false,
                minScale: 0.5,
                maxScale: 4,
                child: Image(
                  image: AssetImage("$caminhoImagemRegiao.png"),
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  color: Colors.transparent,
                  width: larguraTela,
                  height: 150,
                  child: Wrap(
                    children: [
                      exibirEstrela(
                          liberarRegiaoSul, Textos.nomeRegiaoCentroOeste),
                      exibirEstrela(liberarRegiaoSudeste, Textos.nomeRegiaoSul),
                      exibirEstrela(
                          liberarRegiaoNorte, Textos.nomeRegiaoSudeste),
                      exibirEstrela(
                          liberarRegiaoNordeste, Textos.nomeRegiaoNorte),
                      exibirEstrela(
                          liberarTodosEstados, Textos.nomeRegiaoNordeste),
                    ],
                  ),
                )),
          ],
        ));
  }
}
