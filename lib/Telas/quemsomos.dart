// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Para abrir links

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Quemsomos(), // Define a tela inicial
    );
  }
}

class Quemsomos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Mudado para center
            children: <Widget>[
              const Center(
                child: Text(
                  "LEAF",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                      width: 75,
                      height: 75,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "O seu aplicativo de organização pessoal. \n\nCom o LEAF além de notas você consegue armazenar suas melhores memórias no dia em que foram vividas para recordar no futuro.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center, // Centralizando o texto
              ),
              const SizedBox(height: 30),

              const Text(
                "Quem Somos:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // Centralizando o texto
              ),
              const SizedBox(height: 20),

              // Centralizando o Wrap
              Center(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    // Cards
                    _buildCard(
                        'assets/images/membros/Bruno.png', // bruno
                        'Bruno Braga Guimarães Alves',
                        'https://www.linkedin.com/in/bruno-braga-aab900266/',
                        'https://github.com/Bruno0926'),
                    _buildCard(
                        'assets/images/membros/Nagib.png', // nagib
                        'Nagib Alexandre Verly Borjaili',
                        'https://www.linkedin.com/in/nagibalexandre/',
                        'https://github.com/NagibAlexandre'),
                    _buildCard(
                        'assets/images/membros/VitorM.png', // vitorm
                        'Vitor Dias de Britto Militão',
                        'https://www.linkedin.com/in/vitor-militão-65b254252/',
                        'https://github.com/militaovitor01'),
                    _buildCard(
                        'assets/images/membros/VitorL.png', // vitorl
                        'Vitor Lucio de Oliveira',
                        'https://www.linkedin.com/in/vitor-lucio-oliveira/',
                        'https://github.com/VitorLucioOliveira'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para construir cada card
  Widget _buildCard(String imagePath, String name, String link1, String link2) {
    return Container(
      width: 150,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black, width: 1), // Borda 1px solid black
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Sombra
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12), // border radius
              child: Image.asset(
                imagePath,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Nome centralizado
          Center(
            child: Text(
              name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),

          // Botões para links com imagens
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  _launchURL(link1);
                },
                child: Image.asset(
                  'assets/images/Link1.png', // Imagem do botão 1
                  width: 30,
                  height: 30,
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  _launchURL(link2);
                },
                child: Image.asset(
                  'assets/images/Link2.png', // Imagem do botão 2
                  width: 30,
                  height: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Função para abrir URLs
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
