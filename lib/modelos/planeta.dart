class Planeta {
  String nomePlaneta;
  String caminhoImagem;
  bool desbloqueado;

  Planeta(
      {required this.nomePlaneta,
      required this.caminhoImagem,
      this.desbloqueado = false});
}
