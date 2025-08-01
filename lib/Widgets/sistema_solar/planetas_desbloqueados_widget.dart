import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Uteis/variaveis_constantes/constantes.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/passar_pegar_dados.dart.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Uteis/variaveis_constantes/constantes_sistema_solar.dart';
import 'package:geoli/Widgets/tela_carregamento_widget.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/modelos/planeta.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class PlanetasDesbloqueadosWidget extends StatefulWidget {
  const PlanetasDesbloqueadosWidget({super.key, required this.corPadrao});

  final Color corPadrao;

  @override
  State<PlanetasDesbloqueadosWidget> createState() => _PlanetasDesbloqueadosWidgetState();
}

class _PlanetasDesbloqueadosWidgetState extends State<PlanetasDesbloqueadosWidget> {
  bool exibirTelaCarregamento = true;
  bool exibirPlanetaGestoDetalhado = false;
  List<Gestos> gestoPlanetasSistemaSolar = [];
  List<Planeta> planetas = [];
  int quantPlanetaDesbloquear = 0;
  int quantPlanetaFaltaDesbloquear = 0;
  int indexPlaneta = 0;
  late String uidUsuario;

  @override
  void initState() {
    super.initState();
    //definindo que as variaveis vao receber os valores
    planetas = ConstantesSistemaSolar.adicinarPlanetas();
    gestoPlanetasSistemaSolar =
        ConstantesSistemaSolar.adicionarGestosPlanetas();
    //chamando metodo
    recuperarUIDUsuario();
  }

  recuperarUIDUsuario() async {
    uidUsuario = await PassarPegarDados.recuperarInformacoesUsuario()
        .values
        .elementAt(0);
    recuperarPlanetasDesbloqueados();
  }

  // metodo para consultar o banco de dados
  recuperarPlanetasDesbloqueados() async {
    bool retornoConexao = await InternetConnection().hasInternetAccess;
    var db = FirebaseFirestore.instance;
    if (retornoConexao) {
      try {
        db
            .collection(
                Constantes.fireBaseColecaoUsuarios) // passando a colecao
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
                  //verificando se o nome do elemento e
                  // igual ao nome do item na lista
                  if (element.nomePlaneta == key) {
                    // caso for o campo do elemento vai
                    // receber o valor que esta no banco
                    element.desbloqueado = value;
                    if (element.desbloqueado) {
                      quantPlanetaDesbloquear = quantPlanetaDesbloquear + 1;
                    } else {
                      quantPlanetaFaltaDesbloquear =
                          quantPlanetaFaltaDesbloquear + 1;
                    }
                  }
                }
              });
              exibirTelaCarregamento = false;
            },
          );
        }, onError: (e) {
          debugPrint("STWON${e.toString()}");
        });
      } catch (e) {
        debugPrint("STW${e.toString()}");
      }
    }
  }

  Widget planetaLiberados(Planeta planeta, Gestos gesto, int index) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Visibility(
            visible: planeta.desbloqueado,
            child: Container(
                margin: EdgeInsets.only(bottom: 10),
                width: 300,
                height: 100,
                child: FloatingActionButton(
                    enableFeedback: !exibirPlanetaGestoDetalhado,
                    backgroundColor: Colors.white,
                    shape: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: widget.corPadrao),
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      setState(() {
                        indexPlaneta = index;
                        exibirPlanetaGestoDetalhado = true;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        imagemPlanetaGesto(
                            planeta.nomePlaneta, planeta.caminhoImagem, 60),
                        imagemPlanetaGesto(
                            gesto.nomeGesto, gesto.nomeImagem, 60)
                      ],
                    ))),
          ),
        ],
      );

  Widget imagemPlanetaGesto(
          String nome, String caminhoImagem, double tamanhoImagem) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            height: tamanhoImagem,
            width: tamanhoImagem,
            image: AssetImage('$caminhoImagem.png'),
          ),
          Text(
            nome,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
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
              corPadrao: widget.corPadrao
            ),
          );
        } else {
          return SingleChildScrollView(
             child: Stack(
               children: [
                 Column(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     Column(
                       children: [
                         Text(
                           Textos.telaPlanetasDesbloqueadosTitulo,
                           textAlign: TextAlign.center,
                           style: TextStyle(
                             fontWeight: FontWeight.bold,
                             fontSize: 18,
                           ),
                         ),
                         Text(
                           Textos.telaPlanetasDesbloqueadosDescricao,
                           textAlign: TextAlign.center,
                         ),
                       ],
                     ),
                     SizedBox(
                         width: larguraTela,
                         height: 250,
                         child: LayoutBuilder(
                           builder: (context, constraints) {
                             if (quantPlanetaDesbloquear == 0) {
                               return Text(
                                 Textos.telaPlanetasSemDesbloquear,
                                 textAlign: TextAlign.center,
                                 style: TextStyle(
                                     fontWeight: FontWeight.bold, fontSize: 18),
                               );
                             } else {
                               return ListView.builder(
                                 itemCount: 8,
                                 itemBuilder: (context, index) {
                                   return planetaLiberados(
                                       planetas.elementAt(index),
                                       gestoPlanetasSistemaSolar.elementAt(index),
                                       index);
                                 },
                               );
                             }
                           },
                         )),
                     SizedBox(
                         width: larguraTela,
                         height: 50,
                         child: Column(
                           children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Text(
                                   Textos.telaPlanetasDesbloqueadosQuanti,
                                   style: TextStyle(
                                       fontWeight: FontWeight.bold,
                                       color: Colors.black),
                                 ),
                                 Text(quantPlanetaDesbloquear.toString())
                               ],
                             ),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Text(
                                   Textos.telaPlanetasDesbloqueadosFalta,
                                   style: TextStyle(
                                       fontWeight: FontWeight.bold,
                                       color: Colors.black),
                                 ),
                                 Text(quantPlanetaFaltaDesbloquear.toString())
                               ],
                             )
                           ],
                         ))
                   ],
                 ),
                 Visibility(
                     visible: exibirPlanetaGestoDetalhado,
                     child: Center(
                       child: SizedBox(
                           width: kIsWeb
                               ? 300
                               : Platform.isIOS || Platform.isAndroid
                               ? larguraTela * 0.9
                               : 300,
                           height: 300,
                           child: Card(
                             color: Colors.white,
                             shape: OutlineInputBorder(
                                 borderSide: BorderSide(
                                     width: 1, color: widget.corPadrao),
                                 borderRadius: BorderRadius.circular(10)),
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.spaceAround,
                               children: [
                                 Row(
                                   mainAxisAlignment:
                                   MainAxisAlignment.spaceEvenly,
                                   children: [
                                     imagemPlanetaGesto(
                                         planetas
                                             .elementAt(indexPlaneta)
                                             .nomePlaneta,
                                         planetas
                                             .elementAt(indexPlaneta)
                                             .caminhoImagem,
                                         120),
                                     imagemPlanetaGesto(
                                         gestoPlanetasSistemaSolar
                                             .elementAt(indexPlaneta)
                                             .nomeGesto,
                                         gestoPlanetasSistemaSolar
                                             .elementAt(indexPlaneta)
                                             .nomeImagem,
                                         120)
                                   ],
                                 ),
                                 SizedBox(
                                   width: 40,
                                   height: 40,
                                   child: FloatingActionButton(
                                     heroTag: "fecharSistemaSolar",
                                     backgroundColor: Colors.white,
                                     onPressed: () {
                                       setState(() {
                                         exibirPlanetaGestoDetalhado = false;
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
                           )),
                     ))
               ],
             ),
          );
        }
      },
    );
  }
}
