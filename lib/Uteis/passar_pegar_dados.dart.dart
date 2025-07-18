class PassarPegarDados {
  static Map informacoesUsuario = {};

  static Map passarInformacoesUsuario(Map infoUsuario) {
    informacoesUsuario = infoUsuario;
    return informacoesUsuario;
  }

  static Map recuperarInformacoesUsuario() {
    return informacoesUsuario;
  }
}
