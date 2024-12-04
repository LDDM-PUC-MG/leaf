class Memory {
  final int id; // ID da memória
  final int userId; // ID do usuário associado
  final String text; // Mensagem da memória
  final String date; // Data da memória

  Memory({
    required this.id,
    required this.userId,
    required this.text,
    required this.date,
  });

  // Cria um objeto Memory a partir de um mapa do banco de dados
  factory Memory.fromMap(Map<String, dynamic> map) {
    return Memory(
      id: map['id'],
      userId: map['id_usuario'],
      text: map['mensagem'],
      date: map['data'],
    );
  }

  // Converte o objeto Memory em um mapa para o banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_usuario': userId,
      'mensagem': text,
      'data': date,
    };
  }
}
