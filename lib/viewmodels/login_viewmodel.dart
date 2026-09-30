
import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/banco_service.dart';

class LoginViewModel extends ChangeNotifier {
  final BancoService bancoService = BancoService();

  bool carregando = false;
  String? erro;
  Usuario? usuario;

  Future<bool> entrar(String email, String senha) async {
    carregando = true;
    erro = null;
    notifyListeners();

    final resultado = await bancoService.login(email, senha);

    carregando = false;

    if (resultado == null) {
      erro = 'E-mail ou senha inválidos.';
      notifyListeners();
      return false;
    }

    usuario = resultado;
    notifyListeners();
    return true;
  }

  Future<bool> cadastrar(String nome, String email, String senha) async {
    try {
      await bancoService.inserirUsuario(
        Usuario(
          nome: nome,
          email: email,
          senha: senha,
        ),
      );

      return true;
    } catch (e) {
      erro = 'Não foi possível cadastrar este usuário.';
      notifyListeners();
      return false;
    }
  }
}
