class PassarPegarDados {
  static Map informacoesUsuario = {};
  static bool ocultarTelaEmblemas = false;
  static String acertou = "";
  static String nomeGestoPlaneta = "";
  static int pontuacaoAtual = 0;
  static String status = "";
  static String uIDUsuario = "";
  static String telaAtualErroConexao = "";

  static Map passarInformacoesUsuario(Map infoUsuario) {
    informacoesUsuario = infoUsuario;
    return informacoesUsuario;
  }

  static Map recuperarInformacoesUsuario() {
    return informacoesUsuario;
  }

  //Metodo para passar se o usuario acertou ou nao
  static Future<String> confirmarAcerto(String acerto) async {
    acertou = acerto;
    return acerto;
  }

  //Metodo para recuperar acerto
  static Future<String> recuperarAcerto() async {
    return acertou;
  }

  static Future<String> passarTelaAtualErroConexao(String telaAtual) async {
    telaAtualErroConexao = telaAtual;
    return telaAtualErroConexao;
  }

  //Metodo para recuperar acerto
  static Future<String> recuperarTelaAtualErroConexao() async {
    return telaAtualErroConexao;
  }

  static Future<String> passarStatusTutorial(String statusAtual) async {
    status = statusAtual;
    return status;
  }

  static Future<String> recuperarStatusTutorial() async {
    return status;
  }

  static Future<int> passarPontuacaoAtual(int pontuacao) async {
    pontuacaoAtual = pontuacao;
    return pontuacaoAtual;
  }

  static Future<int> recuperarPontuacaoAtual() async {
    return pontuacaoAtual;
  }

  static Future<String> passarGestoSorteado(String nomeGesto) async {
    nomeGestoPlaneta = nomeGesto;
    return nomeGestoPlaneta;
  }

  static Future<String> recuperarGestoSorteado() async {
    return nomeGestoPlaneta;
  }

  static Future<bool> passarOcultarTelaEmblemas(bool ocultar) async {
    ocultarTelaEmblemas = ocultar;
    return ocultarTelaEmblemas;
  }

  static Future<bool> recuperarOcultarTelaEmblemas() async {
    return ocultarTelaEmblemas;
  }
}
