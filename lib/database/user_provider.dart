import 'package:flutter/material.dart';
import 'user.dart';
import 'package:calendario/database/sql_helper.dart'; // Certifique-se de que o caminho esteja correto

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  // Método para atualizar o nome de usuário no banco e no estado
  Future<void> updateUsername(int id, String newUsername) async {
    await SQLHelper.updateUsername(id, newUsername); // Chama a função de atualização do banco de dados

    if (_user != null) {
      _user = _user!.copyWith(username: newUsername); // Atualiza o estado local
      notifyListeners(); // Notifica ouvintes sobre a mudança
    }
  }

  // Método para atualizar a data de nascimento do usuário no banco e no estado
  Future<void> updateBirthday(int id, String newBirthday) async {
    await SQLHelper.updateBirthday(id, newBirthday); // Chama a função de atualização do banco de dados

    if (_user != null) {
      _user = _user!.copyWith(birthday: newBirthday); // Atualiza o estado local
      notifyListeners(); // Notifica ouvintes sobre a mudança
    }
  }

  // Método para validar a senha atual
  Future<bool> validatePassword(int id, String currentPassword) async {
    // Recupera a senha armazenada no banco e compara com a senha fornecida
    final storedPassword = await SQLHelper.getPasswordById(id);
    return storedPassword == currentPassword;
  }

  // Método para atualizar a senha do usuário no banco e no estado
  Future<void> updatePassword(int id, String newPassword) async {
    await SQLHelper.updatePassword(id, newPassword); // Chama a função de atualização do banco de dados

    if (_user != null) {
      _user = _user!.copyWith(password: newPassword); // Atualiza o estado local
      notifyListeners(); // Notifica ouvintes sobre a mudança
    }
  }

  // Função para verificar se o e-mail já existe
  Future<bool> emailExists(String email) async {
    final existingUser = await SQLHelper.getUserByEmail(email); // Chama a função do SQLHelper
    return existingUser != null; // Se o resultado não for nulo, o email já existe
  }

  // Função para atualizar o email
  Future<void> updateEmail(int userId, String newEmail) async {
    await SQLHelper.updateEmail(userId, newEmail); // Atualiza o e-mail no banco de dados

    if (_user != null) {
      _user = _user!.copyWith(email: newEmail); // Atualiza o e-mail no objeto User
      notifyListeners(); // Notifica os listeners para atualizar a interface
    }
  }
}
