import 'package:flutter/material.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes_sistema_solar.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Widgets/widget_tela_carregamento.dart';
import 'package:geoli/modelos/gestos.dart';
import 'package:geoli/modelos/planeta.dart';

class SistemaSolarWidget extends StatefulWidget {
  const SistemaSolarWidget({super.key, required this.corPadrao});

  final Color corPadrao;

  @override
  State<SistemaSolarWidget> createState() => _SistemaSolarWidgetState();
}

class _SistemaSolarWidgetState extends State<SistemaSolarWidget> {
  bool exibirTelaCarregamento = false;
  List<Gestos> gestoPlanetasSistemaSolar = [];
  List<Planeta> planetas = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    planetas = ConstantesSistemaSolar.adicinarPlanetas();
    gestoPlanetasSistemaSolar.addAll([
      Gestos(
          nomeGesto: Textos.nomePlanetaMercurio,
          nomeImagem: CaminhosImagens.gestoPlanetaMercurioImagem),
      Gestos(
          nomeGesto: Textos.nomePlanetaVenus,
          nomeImagem: CaminhosImagens.gestoPlanetaVenusImagem),
      Gestos(
          nomeGesto: Textos.nomePlanetaTerra,
          nomeImagem: CaminhosImagens.gestoPlanetaTerraImagem),
      Gestos(
          nomeGesto: Textos.nomePlanetaMarte,
          nomeImagem: CaminhosImagens.gestoPlanetaMarteImagem),
      Gestos(
          nomeGesto: Textos.nomePlanetaJupiter,
          nomeImagem: CaminhosImagens.gestoPlanetaJupiterImagem),
      Gestos(
          nomeGesto: Textos.nomePlanetaSaturno,
          nomeImagem: CaminhosImagens.gestoPlanetaSaturnoImagem),
      Gestos(
          nomeGesto: Textos.nomePlanetaUrano,
          nomeImagem: CaminhosImagens.gestoPlanetaUranoImagem),
      Gestos(
          nomeGesto: Textos.nomePlanetaNetuno,
          nomeImagem: CaminhosImagens.gestoPlanetaNetunoImagem),
    ]);
  }

  Widget planetaLiberados(Planeta planeta, Gestos gesto) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      SizedBox(
          width: 150,
          height: 100,
          child: Card(
            shape: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: widget.corPadrao),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image(
                  height: 60,
                  width: 60,
                  image: AssetImage('${planeta.caminhoImagem}.png'),
                ),
                Text(
                  planeta.nomePlaneta,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )),
      SizedBox(
          width: 150,
          height: 100,
          child: Card(
            shape: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: widget.corPadrao),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image(
                  height: 60,
                  width: 60,
                  image: AssetImage('${gesto.nomeImagem}.png'),
                ),
                Text(
                  gesto.nomeGesto,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )),
    ],
  );

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    return SizedBox(
        width: larguraTela,
        height: alturaTela,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (exibirTelaCarregamento) {
              return WidgetTelaCarregamento(corPadrao: widget.corPadrao);
            } else {
              return Column(
                children: [
                  Column(
                    children: [
                      Text(
                        Textos.telaTituloPlanetasDesbloqueados,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(Textos.telaDescricaoPlanetasDesbloqueados),
                    ],
                  ),
                  SizedBox(
                    width: larguraTela,
                    height: 350,
                    child: ListView.builder(
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return planetaLiberados(planetas.elementAt(index),
                            gestoPlanetasSistemaSolar.elementAt(index));
                      },
                    ),
                  )
                ],
              );
            }
          },
        ));
  }
}
