import 'package:flutter/material.dart';
import 'package:calendario/styles/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Screen',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: perfilUsuario(),
    );
  }
}

class perfilUsuario extends StatefulWidget {
  const perfilUsuario({super.key});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<perfilUsuario> {
  int _currentIndex = 0;
  File? _profileImage;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Perfil',
          style: TextStyle(color: AppColors.background), // Definindo a cor do texto
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage, // Abre a galeria ao tocar na imagem
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!) // Exibe a imagem selecionada
                      : NetworkImage('https://via.placeholder.com/100') as ImageProvider,
                  child: _profileImage == null
                      ? Icon(Icons.camera_alt, color: Colors.grey[700], size: 50)
                      : null,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'LEAFteam',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Belo Horizonte',
                style: TextStyle(color: Colors.grey[700]),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: InfoCard(label: 'Memórias Registradas', value: '00'),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: InfoCard(label: 'Sequência de memórias', value: '00'),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    ProfileOption(icon: Icons.person, label: 'Nome de Usuário', value: 'JohanSmith'),
                    ProfileOption(icon: Icons.email, label: 'E-mail', value: 'johansmith@example.com'),
                    ProfileOption(icon: Icons.cake, label: 'Data de Nascimento', value: '01/01/1990'),
                    Divider(),
                    ProfileOption(icon: Icons.info, label: 'Informações pessoais'),
                    ProfileOption(icon: Icons.favorite, label: 'Seus favoritos'),
                    ProfileOption(icon: Icons.payment, label: 'Pagamento'),
                    ProfileOption(icon: Icons.logout, label: 'Sair', isLogout: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Definição do widget InfoCard
class InfoCard extends StatelessWidget {
  final String label;
  final String value;

  InfoCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[700])),
      ],
    );
  }
}

// Definição do widget ProfileOption
class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final bool isLogout;

  ProfileOption({required this.icon, required this.label, this.value, this.isLogout = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : AppColors.primary),
      title: Text(label),
      subtitle: value != null ? Text(value!) : null,
      trailing: isLogout ? null : Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        if (isLogout) {
          // Lógica para logout
        } else {
          // Lógica para navegação ou ação do item
        }
      },
    );
  }
}
