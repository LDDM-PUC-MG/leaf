import 'package:flutter/material.dart';
import 'memory.dart';
import 'sql_helper.dart';

class MemoryProvider with ChangeNotifier {
  List<Memory> _memories = [];

  List<Memory> get memories => _memories;

  /// Carrega todas as memórias de um usuário a partir do banco de dados
  Future<void> loadMemories(int userId) async {
    final data = await SQLHelper.getMemorias(userId);
    _memories = data.map((map) => Memory.fromMap(map)).toList();
    notifyListeners();
  }

  /// Adiciona uma nova memória ao banco de dados e atualiza a lista local
  Future<void> addMemory(int userId, String message, String date) async {
    final id = await SQLHelper.addMemoria(userId, message, date);
    final newMemory = Memory(
      id: id,
      userId: userId,
      text: message,
      date: date,
    );
    _memories.add(newMemory);
    notifyListeners();
  }

  /// Atualiza uma memória existente no banco de dados e na lista local
  Future<void> updateMemory(int memoryId, String message, String date) async {
    await SQLHelper.updateMemoria(memoryId, message, date);
    final index = _memories.indexWhere((memory) => memory.id == memoryId);
    if (index != -1) {
      _memories[index] = Memory(
        id: memoryId,
        userId: _memories[index].userId,
        text: message,
        date: date,
      );
      notifyListeners();
    }
  }

  




  /// Obtém uma memória específica pelo ID
  Memory? getMemoryById(int memoryId) {
    return _memories.firstWhere(
      (memory) => memory.id == memoryId
    );
  }
}
