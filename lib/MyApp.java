import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Ícone de perfil
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person_outline,
                  size: 40,
                  color: Colors.purple,
                ),
              ),
              SizedBox(height: 20),

              // Título de boas-vindas
              Text(
                "Seja bem vindo!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),

              // Subtítulo
              Text(
                "Efetue seu login:",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 30),

              // Campo de e-mail/usuário
              TextField(
                decoration: InputDecoration(
                  labelText: "E-mail ou usuário",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Campo de senha
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Senha",
                  border: OutlineInputBorder(),
                ),
              ),

              // Esqueceu a senha
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Ação de esquecer senha
                  },
                  child: Text(
                    "Esqueceu a senha?",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ),

              // Botão de login
              ElevatedButton(
                onPressed: () {
                  // Ação de login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: Size(double.infinity, 50), // Largura total
                ),
                child: Text("Acessar"),
              ),

              // Espaço entre os elementos
              SizedBox(height: 30),

              // Link para criar uma conta
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Não possui conta? "),
                  GestureDetector(
                    onTap: () {
                      // Ação de criar conta
                    },
                    child: Text(
                      "Crie agora",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
