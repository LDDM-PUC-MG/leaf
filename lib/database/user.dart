class User {
  final int id;
  final String email;
  final String username;
  final String birthday;
  final String password;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.birthday,
    required this.password,
  });

  // Método copyWith para criar uma cópia do objeto User com alterações
  User copyWith({
    int? id,
    String? email,
    String? username,
    String? birthday,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      birthday: birthday ?? this.birthday,
      password: password ?? this.password,
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    // Verifica se algum dado essencial está ausente
    if (map['id'] == null || map['email'] == null || map['username'] == null || map['birthday'] == null || map['password'] == null) {
      throw Exception("Dados do usuário incompletos: valores nulos encontrados.");
    }

    return User(
      id: map['id'],
      email: map['email'],
      username: map['username'],
      birthday: map['birthday'],
      password: map['password'],
    );
  }
}
