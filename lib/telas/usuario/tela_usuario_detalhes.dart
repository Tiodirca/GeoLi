import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoli/Uteis/caminho_imagens.dart';
import 'package:geoli/Uteis/variaveis_constantes/constantes.dart';
import 'package:geoli/Uteis/estilo.dart';
import 'package:geoli/Uteis/exclusao_dados.dart';
import 'package:geoli/Uteis/metodos_auxiliares.dart';
import 'package:geoli/Uteis/paleta_cores.dart';
import 'package:geoli/Uteis/passar_pegar_dados.dart.dart';
import 'package:geoli/Uteis/textos.dart';
import 'package:geoli/Uteis/validar_tamanho_itens_tela.dart';
import 'package:geoli/Widgets/tela_carregamento_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaUsuarioDetalhes extends StatefulWidget {
  const TelaUsuarioDetalhes({super.key});

  @override
  State<TelaUsuarioDetalhes> createState() => _TelaUsuarioDetalhesState();
}

class _TelaUsuarioDetalhesState extends State<TelaUsuarioDetalhes> {
  bool exibirTelaCarregamento = true;
  bool ativarCampoUsuario = false;
  bool ativarCampoEmail = false;
  bool exibirTelaAutenticacao = false;
  bool ocultarSenhaDigitada = true;
  bool exibirAuteracaoSenha = false;
  bool exibirOcultarBtnSalvar = false;
  IconData iconeSenhaVisivel = Icons.visibility;
  String emailSemAlteracao = "";
  String emailAlterado = "";
  String nomeUsuarioSemAlteracao = "";
  late String uidUsuario;
  Estilo estilo = Estilo();
  final chaveFormularioUsuarioEmail = GlobalKey<FormState>();
  final chaveFormularioSenhaNova = GlobalKey<FormState>();
  final chaveFormularioSenhaAutenticacao = GlobalKey<FormState>();
  TextEditingController campoEmail = TextEditingController(text: "");
  TextEditingController campoSenhaAutenticacao =
      TextEditingController(text: "");
  TextEditingController campoSenhaNova = TextEditingController(text: "");
  TextEditingController campoUsuario = TextEditingController(text: "");
  String tipoAutenticacao = "";

  @override
  void initState() {
    super.initState();
    recuperarInformacoesUsuario();
  }

  recuperarInformacoesUsuario() async {
    uidUsuario = await PassarPegarDados.recuperarInformacoesUsuario()
        .values
        .elementAt(0);
    campoEmail.text = await PassarPegarDados.recuperarInformacoesUsuario()
        .values
        .elementAt(1);
    emailSemAlteracao = await PassarPegarDados.recuperarInformacoesUsuario()
        .values
        .elementAt(1);
    recuperarNomeUsuario();
  }

  recuperarNomeUsuario() async {
    var db = FirebaseFirestore.instance;
    //instanciano variavel
    try {
      db
          .collection(Constantes.fireBaseColecaoUsuarios) // passando a colecao
          .doc(
            uidUsuario,
          )
          .get()
          .then((querySnapshot) async {
        // verificando cada item que esta gravado no banco de dados
        if (querySnapshot.data() != null) {
          querySnapshot.data()!.forEach((key, value) async {
            if (key.toString() == Constantes.fireBaseCampoNomeUsuario) {
              setState(() {
                campoUsuario.text = value;
                nomeUsuarioSemAlteracao = value;
              });
            } else {
              if (value.toString().isNotEmpty) {
                setState(() {
                  emailAlterado = value;
                  validarConfirmacaoAlteracaoEmail(uidUsuario, emailAlterado);
                });
              } else {
                setState(() {
                  exibirTelaCarregamento = false;
                });
              }
            }
          });
        } else {
          redirecionarTelaLogin();
        }
      }, onError: (e) {
        debugPrint("RPON${e.toString()}");
        chamarValidarErro(e.toString());
      }).timeout(
        Duration(seconds: Constantes.fireBaseDuracaoTimeOutTelaProximoNivel),
        onTimeout: () {
          chamarValidarErro(Textos.erroUsuarioSemInternet);
          redirecionarTelaInicial();
        },
      );
    } catch (e) {
      debugPrint("Erro${e.toString()}");
      chamarValidarErro(e.toString());
    }
  }

  redirecionarTelaInicial() {
    Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
  }

  validarConfirmacaoAlteracaoEmail(String uid, String emailAlteracao) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //recuperando senha do usuario gravada ao
    // fazer login,cadastro ou alteracao da senha
    String senhaUsuario = prefs.getString(Constantes.infoUsuarioSenha) ?? '';
    //fazendo autenticacao do usuario usando o email puxado do banco de dados para verificar
    // se houve confirmacao de alteracao de email
    AuthCredential credencial = EmailAuthProvider.credential(
      email: emailAlteracao,
      password: senhaUsuario,
    );
    try {
      //vazendo login utilizando as informacoes passadas no credencial
      FirebaseAuth.instance.signInWithCredential(credencial).then(
        (value) {
          // caso a autenticacao seja VERDADEIRA sera feito
          // a atualizacao no banco de dados e redicionamento de tela
          if (mounted) {
            gravarEmailAlteradoBancoDados(uid, emailAlteracao);
          }
        },
        onError: (e) {
          setState(() {
            exibirTelaCarregamento = false;
          });
          debugPrint("Permanesse o mesmo");
        },
      );
    } on FirebaseAuthException {
      setState(() {
        exibirTelaCarregamento = false;
      });
      debugPrint("DF Permanesse o mesmo");
    }
  }

  //metodo para gravar no bando de dados caso o
  // usuario tenha confirmado a alteracao de email
  gravarEmailAlteradoBancoDados(String uid, String emailAlterar) async {
    Map<String, dynamic> nomeUsuario = {
      Constantes.fireBaseCampoNomeUsuario: campoUsuario.text,
      Constantes.fireBaseCampoEmailAlterado: ""
    };
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(Constantes.fireBaseColecaoUsuarios)
          .doc(
            uidUsuario,
          )
          .set(nomeUsuario)
          .then(
        (value) {
          //redirecionar tela passando as seguintes informacoes
          setState(() {
            campoEmail.text = emailAlterar;
            emailSemAlteracao = campoEmail.text;
            exibirTelaCarregamento = false;
            emailAlterado = "";
          });
          passarInformacoes(uid, emailAlterar);
        },
        onError: (e) {
          setState(() {
            exibirTelaCarregamento = false;
          });
          debugPrint(e.toString());
          chamarValidarErro(e.toString());
        },
      );
    } catch (e) {
      setState(() {
        exibirTelaCarregamento = false;
      });
      chamarValidarErro(e.toString());
      debugPrint(e.toString());
    }
  }

  passarInformacoes(String uid, String email) {
    Map dados = {};
    dados[Constantes.infoUsuarioUID] = uid;
    dados[Constantes.infoUsuarioEmail] = email;
    PassarPegarDados.passarInformacoesUsuario(dados);
  }

  desconectarUsuario() async {
    setState(() {
      exibirTelaCarregamento = true;
    });
    await FirebaseAuth.instance.signOut();
    chamarExibirMensagens(Textos.sucessoDesconectar, Constantes.msgAcerto);
    redirecionarTelaLogin();
  }

  chamarDeletarDadosUsuario() async {
    bool retornoRegioes = await ExclusaoDados.chamarDeletarItemAItem(
      Constantes.fireBaseColecaoRegioes,
      uidUsuario,
    );
    bool retornoSistemaSolar = await ExclusaoDados.chamarDeletarItemAItem(
      Constantes.fireBaseColecaoSistemaSolar,
      uidUsuario,
    );
    bool retornoExclusaoUsuario =
        await ExclusaoDados.excluirInformacoesUsuario(uidUsuario);
    if (retornoRegioes && retornoSistemaSolar && retornoExclusaoUsuario) {
      chamarDeletarUsuario();
    } else {}
  }

  chamarDeletarUsuario() {
    if (FirebaseAuth.instance.currentUser != null) {
      //chama deletar usuario
      FirebaseAuth.instance.currentUser?.delete().then(
        (value) {
          desconectarUsuario();
        },
        onError: (e) {
          setState(() {
            chamarValidarErro(e.toString());
            exibirTelaCarregamento = false;
          });
        },
      );
    }
  }

  chamarExibirMensagens(String mensagem, String tipoExibicao) {
    MetodosAuxiliares.exibirMensagens(
        mensagem,
        tipoExibicao,
        Constantes.duracaoExibicaoToastLoginCadastro,
        Constantes.larguraToastLoginCadastro,
        context);
  }

  redirecionarTelaLogin() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, Constantes.rotaTelaLoginCadastro);
    });
  }

  recarregarTela() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(
          context, Constantes.rotaTelaUsuarioDetalhado);
    });
  }

  atualizarNomeUsuario() {
    setState(() {
      exibirTelaCarregamento = true;
    });
    Map<String, dynamic> nomeUsuario = {
      Constantes.fireBaseCampoNomeUsuario: campoUsuario.text,
      Constantes.fireBaseCampoEmailAlterado: emailAlterado
    };
    try {
      // instanciando Firebase
      var db = FirebaseFirestore.instance;
      db
          .collection(Constantes.fireBaseColecaoUsuarios)
          .doc(
            uidUsuario,
          )
          .set(nomeUsuario)
          .then((value) {
        chamarExibirMensagens(Textos.sucessoAlterarNome, Constantes.msgAcerto);
        recarregarTela();
      }, onError: (e) {
        debugPrint("NOME${e.toString()}");
        chamarValidarErro(e.toString());
      });
    } catch (e) {
      chamarValidarErro(e.toString());
      debugPrint(e.toString());
    }
  }

  chamarValidarErro(String erro) {
    MetodosAuxiliares.validarErro(erro, context);
  }

  //metodo para reenviar o link de alteracao do email
  reenviarEmailAlteracao() {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.currentUser
          ?.verifyBeforeUpdateEmail(emailAlterado)
          .then(
        (value) {
          chamarExibirMensagens(Textos.sucessoEnvioLink, Constantes.msgAcerto);
          setState(() {
            exibirTelaCarregamento = false;
          });
        },
        onError: (e) {
          debugPrint("Reenvio de Email ${e.toString()}");
          chamarValidarErro("Reenvio de Email : ${e.toString()}");
        },
      );
    }
  }

  validarAcaoBotaoIcone(String nomeBotao) {
    if (nomeBotao == Textos.campoEmail) {
      setState(() {
        exibirOcultarBtnSalvar = true;
        ativarCampoEmail = true;
        ativarCampoUsuario = false;
      });
    } else if (nomeBotao == Textos.campoUsuario) {
      setState(() {
        exibirOcultarBtnSalvar = true;
        ativarCampoEmail = false;
        ativarCampoUsuario = true;
      });
    } else if (nomeBotao == Textos.btnCancelarEdicao) {
      setState(() {
        exibirOcultarBtnSalvar = false;
        ativarCampoEmail = false;
        exibirAuteracaoSenha = false;
        ativarCampoUsuario = false;
        exibirTelaAutenticacao = false;
        campoSenhaAutenticacao.text = "";
        campoSenhaNova.text = "";
        campoUsuario.text = nomeUsuarioSemAlteracao;
      });
    }
  }

  validarAcaoBotaoSalvarAlteracoes() {
    if (ativarCampoUsuario) {
      if (chaveFormularioUsuarioEmail.currentState!.validate()) {
        atualizarNomeUsuario();
      }
    } else if (ativarCampoEmail) {
      // Validacao quando for ALTERAR EMAIL
      if (chaveFormularioUsuarioEmail.currentState!.validate()) {
        alerta(
            Textos.tituloAlertaAlterarEmail,
            Textos.descricaoAlertaAlterarEmail,
            Constantes.acaoAutenticarAlterarEmail);
      }
    } else if (exibirAuteracaoSenha) {
      if (chaveFormularioSenhaNova.currentState!.validate()) {
        alerta(
            Textos.tituloAlertaAlterarSenha,
            Textos.descricaoAlertaAlterarSenha,
            Constantes.acaoAutenticarAlterarSenha);
      }
    }
  }

  chamarAutenticarUsuario() {
    setState(() {
      exibirTelaCarregamento = true;
    });
    AuthCredential credential = EmailAuthProvider.credential(
      email: emailSemAlteracao,
      password: campoSenhaAutenticacao.text,
    );
    FirebaseAuth.instance.signInWithCredential(credential).then(
      (value) {
        setState(() {
          exibirTelaAutenticacao = false;
          campoSenhaAutenticacao.clear();
          validarAcaoAutenticacao();
        });
      },
      onError: (e) {
        setState(() {
          chamarValidarErro(e.toString());
          debugPrint(e.toString());
          exibirTelaCarregamento = false;
        });
      },
    );
  }

  validarAcaoAutenticacao() {
    if (tipoAutenticacao == Constantes.acaoAutenticarExcluirConta) {
      chamarDeletarDadosUsuario();
    } else if (tipoAutenticacao == Constantes.acaoAutenticarAlterarSenha) {
      chamarAlterarSenha();
    } else if (tipoAutenticacao == Constantes.acaoAutenticarAlterarEmail) {
      chamarAlterarEmail();
    } else if (tipoAutenticacao == Constantes.acaoAutenticarReenviarEmail) {
      reenviarEmailAlteracao();
    }
  }

  //metodo para alterar o email da conta do usuario
  chamarAlterarEmail() {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.currentUser
          ?.verifyBeforeUpdateEmail(campoEmail.text)
          .then(
        (value) async {
          bool retorno = await gravarEmailAlteradoValidacao(uidUsuario);
          if (retorno) {
            chamarExibirMensagens(
                Textos.sucessoEnvioLink, Constantes.msgAcerto);
            recarregarTela();
          } else {
            setState(() {
              exibirTelaCarregamento = false;
            });
          }
        },
        onError: (e) {
          setState(() {
            exibirTelaCarregamento = false;
            chamarValidarErro(e.toString());
          });
          debugPrint("Email ${e.toString()}");
        },
      );
    }
  }

  Future<bool> gravarEmailAlteradoValidacao(String uid) async {
    bool retorno = false;
    try {
      Map<String, dynamic> dadosUsuario = {
        Constantes.fireBaseCampoNomeUsuario: nomeUsuarioSemAlteracao,
        Constantes.fireBaseCampoEmailAlterado: campoEmail.text
      };
      var db = FirebaseFirestore.instance;
      await db
          .collection(Constantes.fireBaseColecaoUsuarios)
          .doc(
            uidUsuario,
          )
          .set(dadosUsuario)
          .then(
        (value) {
          retorno = true;
        },
        onError: (e) {
          retorno = false;
          debugPrint(e.toString());
        },
      );
    } catch (e) {
      retorno = false;
      debugPrint(e.toString());
    }
    return retorno;
  }

  //metodo para alterar a senha da conta do usuario
  chamarAlterarSenha() {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.currentUser
          ?.updatePassword(campoSenhaNova.text)
          .then(
        (value) {
          gravarSenhaUsuario(campoSenhaNova.text);
          chamarExibirMensagens(
              Textos.sucessoAtualizarSenha, Constantes.msgAcerto);
          recarregarTela();
        },
        onError: (e) {
          setState(() {
            exibirTelaCarregamento = false;
            chamarValidarErro(e.toString());
          });
          debugPrint("SENHA ${e.toString()}");
        },
      );
    }
  }

  gravarSenhaUsuario(String senha) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constantes.infoUsuarioSenha, senha);
  }

  Widget camposInfoUsuario(
          String nomeImagem,
          String nomeCampo,
          double larguraTela,
          TextEditingController controle,
          bool ativarCampo) =>
      Container(
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              height: ValidarTamanhoItensTela.validarTamanhoGestos(larguraTela),
              width: ValidarTamanhoItensTela.validarTamanhoGestos(larguraTela),
              image: AssetImage("$nomeImagem.png"),
            ),
            SizedBox(
              width: ValidarTamanhoItensTela.validarTamanhoCamposEditText(
                  larguraTela),
              child: TextFormField(
                controller: controle,
                validator: (value) {
                  if (value!.isEmpty) {
                    return Textos.erroCampoVazio;
                  }
                  return null;
                },
                enabled: ativarCampo,
                decoration: InputDecoration(
                  labelText: nomeCampo,
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
            botaoIcone(
              Icons.edit,
              PaletaCores.corOuro,
              nomeCampo,
            )
          ],
        ),
      );

  Widget camposSenha(String nomeImagem, String nomeCampo, double larguraTela,
          TextEditingController controle) =>
      Container(
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              height: ValidarTamanhoItensTela.validarTamanhoGestos(larguraTela),
              width: ValidarTamanhoItensTela.validarTamanhoGestos(larguraTela),
              image: AssetImage("$nomeImagem.png"),
            ),
            SizedBox(
              width: ValidarTamanhoItensTela.validarTamanhoCamposEditText(
                  larguraTela),
              child: TextFormField(
                controller: controle,
                validator: (value) {
                  if (value!.isEmpty) {
                    return Textos.erroCampoVazio;
                  }
                  return null;
                },
                obscureText: ocultarSenhaDigitada,
                decoration: InputDecoration(
                  labelText: nomeCampo,
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          if (ocultarSenhaDigitada) {
                            setState(() {
                              ocultarSenhaDigitada = false;
                              iconeSenhaVisivel = Icons.visibility_off;
                            });
                          } else {
                            setState(() {
                              ocultarSenhaDigitada = true;
                              iconeSenhaVisivel = Icons.visibility;
                            });
                          }
                        });
                      },
                      icon: Icon(iconeSenhaVisivel)),
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      );

  Widget botaoIcone(IconData icone, Color cor, String nomeBotao) => Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        width: 45,
        height: 45,
        child: FloatingActionButton(
          heroTag: nomeBotao,
          elevation: 0,
          backgroundColor: Colors.white,
          shape: OutlineInputBorder(
              borderSide: BorderSide(color: cor, width: 1),
              borderRadius: BorderRadius.circular(15)),
          onPressed: () {
            validarAcaoBotaoIcone(nomeBotao);
          },
          child: Icon(
            icone,
            color: Colors.black,
            size: 30,
          ),
        ),
      );

  Widget cartaoBtn(
          String nomeImagem, String nomeBtn, Color cor, double larguraTela) =>
      Container(
        margin: EdgeInsets.all(5),
        height: ValidarTamanhoItensTela.validarTamanhoAlturaBotaoTelaUsuario(
            larguraTela),
        width: ValidarTamanhoItensTela.validarTamanhoLarguraBotaoTelaUsuario(
            larguraTela),
        child: FloatingActionButton(
          elevation: 0,
          heroTag: nomeBtn,
          backgroundColor: Colors.white,
          onPressed: () {
            if (nomeBtn == Textos.btnSalvarAlteracoes) {
              validarAcaoBotaoSalvarAlteracoes();
            } else if (nomeBtn == Textos.btnAutenticar) {
              if (chaveFormularioSenhaAutenticacao.currentState!.validate()) {
                chamarAutenticarUsuario();
              }
            } else if (nomeBtn == Textos.btnAlterarSenha) {
              setState(() {
                exibirAuteracaoSenha = true;
                exibirOcultarBtnSalvar = true;
              });
            } else if (nomeBtn == Textos.btnExcluirUsuario) {
              alerta(
                  Textos.tituloAlertaExclusaoUsuario,
                  Textos.descricaoAlertaExclusaoUsuario,
                  Constantes.acaoAutenticarExcluirConta);
            } else if (nomeBtn == Textos.btnSair) {
              desconectarUsuario();
            } else if (nomeBtn == Textos.btnReenviarEmail) {
              setState(() {
                tipoAutenticacao = Constantes.acaoAutenticarReenviarEmail;
                exibirTelaAutenticacao = true;
              });
            }
          },
          shape: RoundedRectangleBorder(
              side: BorderSide(color: cor, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                height:
                    ValidarTamanhoItensTela.validarTamanhoGestos(larguraTela),
                width:
                    ValidarTamanhoItensTela.validarTamanhoGestos(larguraTela),
                image: AssetImage("$nomeImagem.png"),
              ),
              Text(
                nomeBtn,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )
            ],
          ),
        ),
      );

  Future<void> alerta(
    String tituloAlerta,
    String descricaoAlerta,
    String autenticacao,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            tituloAlerta,
            style: const TextStyle(color: Colors.black),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  descricaoAlerta,
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 10),
                Wrap(
                  children: [
                    Text(
                      autenticacao == Constantes.acaoAutenticarAlterarSenha
                          ? emailSemAlteracao
                          : campoEmail.text,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Não', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sim', style: TextStyle(color: Colors.black)),
              onPressed: () {
                setState(() {
                  exibirTelaAutenticacao = true;
                  tipoAutenticacao = autenticacao;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    Timer(Duration(seconds: 2), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    });
    return Theme(
        data: estilo.estiloGeral,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (exibirTelaCarregamento) {
              return TelaCarregamentoWidget(
                corPadrao: PaletaCores.corVerde,
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                      color: Colors.white,
                      //setando tamanho do icone
                      iconSize: 30,
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, Constantes.rotaTelaInicial);
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                  backgroundColor: PaletaCores.corVerde,
                  title: Text(
                    Textos.telaUsuarioTitulo,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                body: GestureDetector(
                  child: Container(
                      color: Colors.white,
                      width: larguraTela,
                      height: alturaTela,
                      child: SingleChildScrollView(
                          child: Form(
                        key: chaveFormularioUsuarioEmail,
                        child: Column(
                          children: [
                            LayoutBuilder(
                              builder: (context, constraints) {
                                if (exibirTelaAutenticacao) {
                                  return Column(
                                    children: [
                                      Text(
                                        Textos.telaUsuarioAutenticacao,
                                        style: TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                      Form(
                                          key: chaveFormularioSenhaAutenticacao,
                                          child: camposSenha(
                                              CaminhosImagens.gestoSenha,
                                              Textos.campoSenha,
                                              larguraTela,
                                              campoSenhaAutenticacao)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          cartaoBtn(
                                              CaminhosImagens.gestoSalvar,
                                              Textos.btnAutenticar,
                                              PaletaCores.corAzulMagenta,
                                              larguraTela),
                                          botaoIcone(
                                              Icons.close,
                                              PaletaCores.corVermelha,
                                              Textos.btnCancelarEdicao),
                                        ],
                                      )
                                    ],
                                  );
                                } else if (exibirAuteracaoSenha) {
                                  return Column(
                                    children: [
                                      Text(
                                        Textos.telaUsuarioDescricaoSenhaNova,
                                        style: TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                      Form(
                                          key: chaveFormularioSenhaNova,
                                          child: camposSenha(
                                              CaminhosImagens.gestoSenha,
                                              Textos.campoSenhaNova,
                                              larguraTela,
                                              campoSenhaNova)),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      Text(
                                        Textos.telaUsuarioDescricao,
                                        style: TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                      camposInfoUsuario(
                                          CaminhosImagens.gestoNome,
                                          Textos.campoUsuario,
                                          larguraTela,
                                          campoUsuario,
                                          ativarCampoUsuario),
                                      camposInfoUsuario(
                                          CaminhosImagens.gestoEmail,
                                          Textos.campoEmail,
                                          larguraTela,
                                          campoEmail,
                                          ativarCampoEmail),
                                      LayoutBuilder(
                                        builder: (context, constraints) {
                                          if (emailAlterado.isNotEmpty) {
                                            return Column(
                                              children: [
                                                Text(Textos
                                                    .telaUsuarioConfirmarEmail),
                                                Text(
                                                  emailAlterado,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                            Visibility(
                                visible: !exibirTelaAutenticacao,
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    if (exibirOcultarBtnSalvar) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          cartaoBtn(
                                              CaminhosImagens.gestoSalvar,
                                              Textos.btnSalvarAlteracoes,
                                              PaletaCores.corAzul,
                                              larguraTela),
                                          botaoIcone(
                                              Icons.close,
                                              PaletaCores.corVermelha,
                                              Textos.btnCancelarEdicao),
                                        ],
                                      );
                                    } else {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          cartaoBtn(
                                              CaminhosImagens.gestoSenha,
                                              Textos.btnAlterarSenha,
                                              PaletaCores.corAzul,
                                              larguraTela),
                                          Visibility(
                                            visible: emailAlterado.isNotEmpty
                                                ? true
                                                : false,
                                            child: cartaoBtn(
                                                CaminhosImagens.gestoEmail,
                                                Textos.btnReenviarEmail,
                                                PaletaCores.corAzul,
                                                larguraTela),
                                          )
                                        ],
                                      );
                                    }
                                  },
                                ))
                          ],
                        ),
                      ))),
                  onTap: () {
                    if (Platform.isAndroid || Platform.isIOS) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  },
                ),
                bottomNavigationBar: Container(
                    color: Colors.white,
                    width: larguraTela,
                    height: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            cartaoBtn(CaminhosImagens.gestoSair, Textos.btnSair,
                                PaletaCores.corVermelha, larguraTela),
                            cartaoBtn(
                                CaminhosImagens.gestoExcluir,
                                Textos.btnExcluirUsuario,
                                PaletaCores.corVermelha,
                                larguraTela),
                          ],
                        )
                      ],
                    )),
              );
            }
          },
        ));
  }
}
