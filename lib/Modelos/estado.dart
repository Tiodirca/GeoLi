import 'package:cloud_firestore/cloud_firestore.dart';
class Estado {
  String nome;
  String caminhoImagem;
  bool acerto;

  Estado(
      {required this.nome, required this.caminhoImagem, this.acerto = false});

  factory Estado.fromJson(Map<dynamic, dynamic> json) {
    return Estado(
        nome: json['nome'] as String,
        caminhoImagem: json['caminhoImagem'] as String,
        acerto: json['acerto'] as bool);
  }

  factory Estado.fromFirestore(
    DocumentSnapshot<Map<dynamic, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Estado(
      nome: data?['nome'],
      caminhoImagem: data?['caminhoImagem'],
      acerto: data?['acerto'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "nome": nome,
      "caminhoImagem": caminhoImagem,
      "acerto": acerto,
    };
  }
}
