class ValidarTamanhoItensTela{

  static validarTamanhoLarguraBotaoTelaUsuario(double larguraTela) {
    double tamanhoCampo = 100.0;
    if (larguraTela <= 400) {
      tamanhoCampo = 130.0;
    } else if (larguraTela > 400 && larguraTela <= 1100) {
      tamanhoCampo = 140.0;
    } else if (larguraTela > 1100) {
      tamanhoCampo = 140.0;
    }
    return tamanhoCampo;
  }

  static validarTamanhoAlturaBotaoTelaUsuario(double larguraTela) {
    double tamanhoCampo = 100.0;
    if (larguraTela <= 400) {
      tamanhoCampo = 110.0;
    } else if (larguraTela > 400 && larguraTela <= 1100) {
      tamanhoCampo = 120.0;
    } else if (larguraTela > 1100) {
      tamanhoCampo = 130.0;
    }
    return tamanhoCampo;
  }

 static validarTamanhoGestos(double larguraTela) {
    double tamanhoCampo = 100.0;
    if (larguraTela <= 400) {
      tamanhoCampo = 70.0;
    } else if (larguraTela > 400 && larguraTela <= 800) {
      tamanhoCampo = 80.0;
    } else if (larguraTela > 800 && larguraTela <= 1100) {
      tamanhoCampo = 90.0;
    } else if (larguraTela > 1100) {
      tamanhoCampo = 100.0;
    }
    return tamanhoCampo;
  }

  static validarTamanhoCamposEditText(double larguraTela) {
    double tamanhoCampo = 200.0;
    //verificando qual o tamanho da tela
    if (larguraTela <= 400) {
      tamanhoCampo = 200.0;
    } else if (larguraTela > 400 && larguraTela <= 800) {
      tamanhoCampo = 250.0;
    } else if (larguraTela > 800 && larguraTela <= 1100) {
      tamanhoCampo = 280.0;
    } else if (larguraTela > 1100) {
      tamanhoCampo = 300.0;
    }
    return tamanhoCampo;
  }

  static validarTamanhoAlturaBotoesLoginCadastroTelaInicial(double larguraTela) {
    double tamanhoCampo = 100.0;
    if (larguraTela <= 400) {
      tamanhoCampo = 150.0;
    } else if (larguraTela > 400 && larguraTela <= 800) {
      tamanhoCampo = 160.0;
    } else if (larguraTela > 800 && larguraTela <= 1100) {
      tamanhoCampo = 160.0;
    } else if (larguraTela > 1100) {
      tamanhoCampo = 170.0;
    }
    return tamanhoCampo;
  }

  static validarTamanhoLarguraBotoesLoginCadastroTelaInicial(double larguraTela) {
    double tamanhoCampo = 100.0;
    if (larguraTela <= 400) {
      tamanhoCampo = 130.0;
    } else if (larguraTela > 400 && larguraTela <= 800) {
      tamanhoCampo = 140.0;
    } else if (larguraTela > 800 && larguraTela <= 1100) {
      tamanhoCampo = 150.0;
    } else if (larguraTela > 1100) {
      tamanhoCampo = 150.0;
    }
    return tamanhoCampo;
  }

  static  tamanhoAreaPlanetaSorteadoSistemaSolar(double larguraTela) {
    double tamanho = 200.0;
    //verificando qual o tamanho da tela
    if (larguraTela <= 400) {
      tamanho = 250.0;
    } else if (larguraTela > 400 && larguraTela <= 800) {
      tamanho = 250.0;
    } else if (larguraTela > 800 && larguraTela <= 1100) {
      tamanho = 300.0;
    } else if (larguraTela > 1100 && larguraTela <= 1300) {
      tamanho = 350.0;
    } else if (larguraTela > 1300) {
      tamanho = 400.0;
    }
    return tamanho;
  }

}