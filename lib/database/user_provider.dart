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

  // Método para atualizar o email do usuário no banco e no estado
  Future<void> updateEmail(int id, String newEmail) async {
    await SQLHelper.updateEmail(id, newEmail); // Chama a função de atualização do banco de dados

    if (_user != null) {
      _user = _user!.copyWith(email: newEmail); // Atualiza o estado local
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
}
