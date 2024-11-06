class User {
  final int id;
  final String email;
  final String username; // Altere "name" para "username"
  final String birthday;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.birthday,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    if (map['id'] == null || map['email'] == null || map['username'] == null || map['birthday'] == null) {
      throw Exception("Dados do usuário incompletos: valores nulos encontrados.");
    }
  
    return User(
      id: map['id'],
      email: map['email'],
      username: map['username'], // Altere "name" para "username"
      birthday: map['birthday'],
    );
  }
}
