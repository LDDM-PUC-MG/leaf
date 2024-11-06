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

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
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

  Future<void> updatePassword(int id, String newPassword) async {
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
}
