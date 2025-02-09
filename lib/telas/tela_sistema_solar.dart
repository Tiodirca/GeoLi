import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoli/Modelos/emblemas.dart';
import 'package:geoli/Modelos/estado.dart';
import 'package:geoli/Modelos/gestos.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Widgets/emblema_widget.dart';
import 'package:geoli/Widgets/gestos_widget.dart';
import 'package:geoli/Widgets/tela_carregamento.dart';

class TelaSistemaSolar extends StatefulWidget {
  const TelaSistemaSolar({super.key});

  @override
  State<TelaSistemaSolar> createState() => _TelaSistemaSolarState();
}

class _TelaSistemaSolarState extends State<TelaSistemaSolar> {
  bool exibirTelaCarregamento = false;
  List<Gestos> planetasSistemaSolar = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (exibirTelaCarregamento) {
          return TelaCarregamento();
        } else {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text(Textos.telaSistemaSolarTitulo),
                leading: IconButton(
                    color: Colors.black,
                    //setando tamanho do icone
                    iconSize: 30,
                    enableFeedback: false,
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, Constantes.rotaTelaInicial);
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
              ),
              body: Container(
                  color: Colors.white,
                  width: larguraTela,
                  height: alturaTela,
                  child: Text("data")),
              bottomSheet: Container(
                color: Colors.white,
                width: larguraTela,
                height: 150,
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: PaletaCores.corAzulMagenta, width: 1),
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40))),
                  child: Column(
                    children: [],
                  ),
                ),
              ));
        }
      },
    );
  }
}
