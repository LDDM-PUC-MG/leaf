import '../../styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:calendario/screens/LoginCadastro/cadastro.dart';

void main() {
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              SizedBox(
                width: 200, // Largura desejada
                height: 200, // Altura desejada
                child: Image.asset('assets/images/logo.jpg'),
              ),

              // Título de boas-vindas
              Text(
                "Seja bem vindo!",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3), // Cor da sombra
                      offset: Offset(2.0, 2.0), // Deslocamento da sombra
                      blurRadius: 4.0, // Desfoque da sombra
                    ),
                  ],
                ),
              ),

              // Subtítulo
              Text(
                "Efetue seu login:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3), // Cor da sombra
                      offset: Offset(2.0, 2.0), // Deslocamento da sombra
                      blurRadius: 4.0, // Desfoque da sombra
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Campo de e-mail/usuário
              const TextField(
                decoration: InputDecoration(
                  labelText: "E-mail ou usuário",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Campo de senha
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Senha",
                  border: OutlineInputBorder(),
                ),
              ),

              // Esqueceu a senha
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    // Ação de esquecer senha
                  },
                  child: const Text(
                    "Esqueceu a senha?",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),

              // Botão de login
              ElevatedButton(
                onPressed: () {
                  // Ação de login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50), // Largura total
                  elevation: 10, // Altura da sombra
                ),
                child: Text(
                "Acessar",
                style: TextStyle(
                  fontSize: 16, // Defina o tamanho da fonte aqui
                  fontWeight: FontWeight.bold, // Opcional: define o peso da fonte (negrito)
                  color: AppColors.background,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3), // Cor da sombra
                      offset: Offset(2.0, 2.0), // Deslocamento da sombra
                      blurRadius: 4.0, // Desfoque da sombra
                    ),
                  ],
                ),
              ),
              ),

              // Espaço entre os elementos
              const SizedBox(height: 20),

              // Link para criar uma conta
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                   Text(
                    "Não possui conta? ",
                      style: TextStyle(
                        fontSize:14,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3), // Cor da sombra
                            offset: Offset(2.0, 2.0), // Deslocamento da sombra
                            blurRadius: 4.0, // Desfoque da sombra
                          ),
                        ],
                      ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CadastroPage()),
                      );
                    },
                    child: Text(
                      "Crie agora",
                      style: TextStyle(
                        fontSize:14,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3), // Cor da sombra
                            offset: Offset(2.0, 2.0), // Deslocamento da sombra
                            blurRadius: 4.0, // Desfoque da sombra
                          ),
                        ],
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
