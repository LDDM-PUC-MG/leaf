import 'package:flutter/material.dart';
import 'package:calendario/styles/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:calendario/database/user_provider.dart';
import 'package:calendario/screens/LoginCadastro/login.dart';

class PerfilUsuario extends StatefulWidget {
  const PerfilUsuario({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<PerfilUsuario> {
  File? _profileImage;

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
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Perfil',
          style: TextStyle(color: AppColors.terciary),
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
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : NetworkImage('https://via.placeholder.com/100')
                          as ImageProvider,
                  child: _profileImage == null
                      ? Icon(Icons.camera_alt, color: Colors.grey[700], size: 50)
                      : null,
                ),
              ),
              SizedBox(height: 16),
              Text(
                user!.username,
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
                  InfoCard(label: 'Memórias Registradas', value: '00'),
                  InfoCard(label: 'Sequência de memórias', value: '00'),
                ],
              ),
              SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    ProfileOption(icon: Icons.person, label: 'Nome de Usuário', value: user.username),
                    ProfileOption(icon: Icons.email, label: 'E-mail', value: user.email),
                    ProfileOption(icon: Icons.cake, label: 'Data de Nascimento', value: user.birthday),
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

  const InfoCard({super.key, required this.label, required this.value});

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

// Definição do widget ProfileOption com lógica de logout
class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final bool isLogout;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : AppColors.primary),
      title: Text(label),
      subtitle: value != null ? Text(value!) : null,
      trailing: isLogout ? null : Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        if (isLogout) {
          _logout(context);
        } else {
          // Lógica para navegação ou ação do item
        }
      },
    );
  }

  // Função para realizar o logout e redirecionar
  void _logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }
}
