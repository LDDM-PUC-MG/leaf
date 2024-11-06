import 'dart:io'; // Para usar File
import 'package:flutter/material.dart';
import 'package:calendario/styles/colors.dart';
import 'package:calendario/screens/Perfil/edit_username_screen.dart';
import 'package:calendario/screens/Perfil/edit_email_screen.dart';
import 'package:calendario/screens/Perfil/edit_birthday_screen.dart';
import 'package:image_picker/image_picker.dart'; // Para usar ImagePicker e ImageSource
import 'package:provider/provider.dart';
import 'package:calendario/database/user_provider.dart';
import 'package:calendario/screens/LoginCadastro/login.dart';

// Defina as classes InfoCard e ProfileOption dentro do arquivo ou as importe de outros arquivos

class PerfilUsuario extends StatefulWidget {
  const PerfilUsuario({super.key});

  @override
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
          style: TextStyle(color: AppColors.terciary, fontSize:24, fontWeight: FontWeight.bold),
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
                      : NetworkImage('https://via.placeholder.com/100') as ImageProvider,
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
              // Adicionando os quadrados verdes para "Memórias Registradas" e "Sequência de Memórias"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '00', // Pode ser substituído com a quantidade real
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Memórias Registradas',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '00', // Pode ser substituído com a quantidade real
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sequência de memórias',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    ProfileOption(
                      icon: Icons.person,
                      label: 'Nome de Usuário',
                      value: user.username,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditUsernameScreen()),
                        );
                      },
                    ),
                    ProfileOption(
                      icon: Icons.email,
                      label: 'E-mail',
                      value: user.email,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditEmailScreen()),
                        );
                      },
                    ),
                    ProfileOption(
                      icon: Icons.cake,
                      label: 'Data de Nascimento',
                      value: user.birthday,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditBirthdayScreen()),
                        );
                      },
                    ),
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

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final bool isLogout;
  final VoidCallback? onPressed;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.isLogout = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : AppColors.primary),
      title: Text(label),
      subtitle: value != null ? Text(value!) : null,
      trailing: isLogout ? null : Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onPressed ?? () {
        if (isLogout) {
          _logout(context);
        } else {
          // Lógica padrão para ações
        }
      },
    );
  }

  void _logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
    );
  }
}
