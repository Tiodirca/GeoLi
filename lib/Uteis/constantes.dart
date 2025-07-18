class Constantes {
  //ROTAS
  static const rotaTelaSplashScreen = "telaSplashScreen";
  static const rotaTelaInicial = "telaIncial";
  static const rotaTelaLoginCadastro = "telaLoginCadastro";
  static const rotaTelaSistemaSolar = "telaSistemaSolar";
  static const rotaTelaUsuarioDetalhado = "telaUsuarioDetalhado";

  // ROTA REGIOES
  static const rotaTelaInicialRegioes = "telaIncialRegioes";
  static const rotaTelaRegiaoCentroOeste = "telaRegiaoCentroOeste";
  static const rotaTelaRegiaoSul = "telaRegiaoSul";
  static const rotaTelaRegiaoSudeste = "telaRegiaoSudeste";
  static const rotaTelaRegiaoNorte = "telaRegiaoNorte";
  static const rotaTelaRegiaoNordeste = "telaRegiaoNordeste";
  static const rotaTelaRegiaoTodosEstados = "telaRegiaoTodosEstados";

  //NOME DADOS FIBASE REGIOES
  static const fireBaseColecaoRegioes = "regioes";
  static const fireBaseDocumentoRegiaoCentroOeste = "regiaoCentroOeste";
  static const fireBaseDocumentoRegiaoSul = "regiaoSul";
  static const fireBaseDocumentoRegiaoSudeste = "regiaoSudeste";
  static const fireBaseDocumentoRegiaoNorte = "regiaoNorte";
  static const fireBaseDocumentoRegiaoNordeste = "regiaoNordeste";
  static const fireBaseDocumentoRegiaoTodosEstados = "regiaoTodosEstados";
  static const fireBaseDocumentoLiberarEstados = "liberarEstados";
  static const fireBaseDocumentoPontosJogadaRegioes = "postosJogadaRegioes";
  static const nomeTodosEstados = "todosEstados";

  static const fireBaseColecaoUsuarios = "Usuarios";
  static const fireBaseDocumentoDadosUsuario = "dadosUsuario";
  static const fireBaseCampoNomeUsuario = "nomeUsuario";
  static const fireBaseCampoEmailAlterado = "emailAlterado";

  static const sharedPreferencesEmail = "email";
  static const sharedPreferencesSenha = "senha";
  static const sharedPreferencesUID = "uidUsuario";

  // NOME DADOS SISTEMA SOLAR
  static const fireBaseColecaoSistemaSolar = "sistemaSolar";
  static const fireBaseDocumentoPontosJogadaSistemaSolar =
      "pontosJogadaSistemaSolar";
  static const fireBaseDocumentoPlanetasDesbloqueados = "planetasDesbloqueados";


  //INFORMACAO USUARIO
  static const infoUsuarioUID = "uid";
  static const infoUsuarioEmail = "email";
  static const infoUsuarioSenha = "senha";
  static const infoUsuarioNome = "nomeUsuario";
  static const fireBaseCampoUsuarioEmailAlterado = "emailAlterado";

  static double larguraToastNotificacaoJogos = 200;
  static int duracaoExibicaoToastJogos = 1;

  static double larguraToastLoginCadastro = 300;
  static int duracaoExibicaoToastLoginCadastro = 2;

  static int duracaoVerificarConexao = 10;

  // STATUS DE RESETAR PONTUACOES
  static const resetarAcaoExcluirTudo = "excluirTudo";
  static const resetarAcaoExcluirRegioes = "excluirRegioes";
  static const resetarAcaoExcluirSistemaSolar = "excluirSistemaSolar";

  //STATUS TUTORIAL
  static const statusTutorialAtivo = "Tutorial Ativo";

  static const erroConexaoSemIntenet = "sem internet";
  static const erroConexaoExpirada = "conexao expirada";

  //TIPO NOTIFICACAO
  static const tipoNotificacaoSucesso = "Sucesso";
  static const tipoNotificacaoErro = "Erro";

  static const pontosJogada = "pontosJogada";
  static const msgErro = "Errou";
  static const msgAcerto = "Acertou";
}
