class User {
  final int id;
  final String email;
  final String username;
  final String birthday;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.birthday,
  });

  // Método copyWith para criar uma cópia do objeto User com alterações
  User copyWith({
    int? id,
    String? email,
    String? username,
    String? birthday,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      birthday: birthday ?? this.birthday,
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    if (map['id'] == null || map['email'] == null || map['username'] == null || map['birthday'] == null) {
      throw Exception("Dados do usuário incompletos: valores nulos encontrados.");
    }

    return User(
      id: map['id'],
      email: map['email'],
      username: map['username'],
      birthday: map['birthday'],
    );
  }
}
