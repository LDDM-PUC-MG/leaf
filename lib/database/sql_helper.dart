// sql_helper.dart
import 'package:sqflite/sqflite.dart' as sql;
import 'package:calendario/database/user.dart';

class SQLHelper {
  static Future<void> criaTabela(sql.Database database) async {
    await database.execute("""
          CREATE TABLE usuarios(
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            email TEXT NOT NULL,
            username TEXT NOT NULL,
            password TEXT NOT NULL,
            birthday TEXT NOT NULL
          )
        """);

    // Criação da tabela 'memoria'
    await database.execute("""
        CREATE TABLE memoria(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          id_usuario INTEGER NOT NULL,
          mensagem TEXT NOT NULL,
          data TEXT NOT NULL,
          FOREIGN KEY (id_usuario) REFERENCES usuarios (id)
        )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'leaf.db',
      version: 2,
      onCreate: (sql.Database database, int version) async {
        await criaTabela(database);
      },
    );
  }

  static Future<int> addUser(
      String email, String username, String password, String birthday) async {
    final db = await SQLHelper.db();
    final data = {
      'email': email,
      'username': username,
      'password': password,
      'birthday': birthday
    };
    return await db.insert('usuarios', data);
  }

  // Manipulaçção de Usuários
  Future<User?> getUser(String email, String password) async {
    final db = await SQLHelper.db();
    final result = await db.query(
      'usuarios',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    try {
      // Tenta criar um User a partir do resultado
      return result.isNotEmpty ? User.fromMap(result.first) : null;
    } catch (e) {
      // ignore: avoid_print
      print("Erro ao criar usuário: $e");
      return null; // Retorna null se houver erro ao criar o usuário
    }
  }

  static Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await SQLHelper.db();
    final result = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result
          .first; // Retorna o primeiro registro se o e-mail já existir.
    }
    return null; // Retorna null se o e-mail não for encontrado.
  }

  Future<void> deleteUser(int id) async {
    final db = await SQLHelper.db();
    await db.delete(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> updateUsername(int id, String newUsername) async {
    final db = await SQLHelper.db();
    await db.update(
      'usuarios',
      {'username': newUsername},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> updatePassword(int id, String newPassword) async {
    final db = await SQLHelper.db();
    await db.update(
      'usuarios',
      {'password': newPassword},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> updateBirthday(int id, String newBirthday) async {
    final db = await SQLHelper.db();
    await db.update(
      'usuarios',
      {'birthday': newBirthday},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> updateEmail(int id, String newEmail) async {
    final db = await SQLHelper.db();
    await db.update(
      'usuarios',
      {'email': newEmail},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<String?> getPasswordById(int id) async {
    final db = await SQLHelper.db();

    // Realiza uma query no banco de dados para obter a senha do usuário pelo ID
    final result = await db.query(
      'usuarios', // Nome da tabela
      columns: ['password'], // Coluna que queremos retornar
      where: 'id = ?', // Condição
      whereArgs: [id], // Argumento para a condição
    );

    // Se o resultado estiver vazio, retorna null
    if (result.isEmpty) {
      return null;
    }

    // Retorna a senha como uma string
    return result.first['password'] as String?;
  }

  // Manipulação de Memórias
  static Future<int> addMemoria(
      int idUsuario, String mensagem, String data) async {
    final db = await SQLHelper.db();
    final dataMap = {
      'id_usuario': idUsuario,
      'mensagem': mensagem,
      'data': data
    };
    return await db.insert('memoria', dataMap);
  }

  static Future<void> updateMemoria(
      int memoriaId, String mensagem, String data) async {
    final db = await SQLHelper.db();
    await db.update(
      'memoria',
      {'mensagem': mensagem, 'data': data},
      where: 'id = ?', // Certifique-se de usar o ID da memória
      whereArgs: [memoriaId],
    );
  }

  static Future<List<Map<String, dynamic>>> getMemorias(int idUsuario) async {
    final db = await SQLHelper.db();
    return await db.query(
      'memoria',
      columns: ['id', 'mensagem', 'data'], // Inclua o 'id' da memória
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
    );
  }

  
}
