import 'dart:io'; // Para usar File
import 'package:calendario/screens/Perfil/edit_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:calendario/styles/colors.dart';
import 'package:calendario/screens/Perfil/edit_username_screen.dart';
import 'package:calendario/screens/Perfil/edit_email_screen.dart';
import 'package:calendario/screens/Perfil/edit_birthday_screen.dart';
import 'package:image_picker/image_picker.dart'; // Para usar ImagePicker e ImageSource
import 'package:provider/provider.dart';
import 'package:calendario/database/user_provider.dart';
import 'package:calendario/database/sql_helper.dart'; // Certifique-se de importar SQLHelper
import 'package:calendario/screens/LoginCadastro/login.dart';
import 'package:calendario/screens/Perfil/info_pessoal.dart';

class PerfilUsuario extends StatefulWidget {
  const PerfilUsuario({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<PerfilUsuario> {
  File? _profileImage;
  int _memoriaCount = 0;

  @override
  void initState() {
    super.initState();
    _loadMemorias();
  }

  Future<void> _loadMemorias() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    if (user != null) {
      final memorias = await SQLHelper.getMemorias(user.id);
      setState(() {
        _memoriaCount = memorias.length;
      });
    }
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
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Perfil',
          style: TextStyle(
              color: AppColors.terciary, fontSize: 24, fontWeight: FontWeight.bold),
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
              const SizedBox(height: 16),
              Text(
                user!.username,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Belo Horizonte',
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 24),
              // Quadrado com número de memórias registradas
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
                          '$_memoriaCount', // Número de memórias
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Memórias Registradas',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
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
                          MaterialPageRoute(
                              builder: (context) => EditUsernameScreen()),
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
                      icon: Icons.password,
                      label: 'Senha',
                      value: '•' * user.password.length, // Mostra a senha como pontinhos
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditPasswordScreen()),
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
                          MaterialPageRoute(
                              builder: (context) => EditBirthdayScreen()),
                        );
                      },
                    ),
                    const Divider(),
                    ProfileOption(
                      icon: Icons.info,
                      label: 'Informações pessoais',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InfoPessoal()),
                        );
                      },
                    ),
                    ProfileOption(
                      icon: Icons.logout,
                      label: 'Sair',
                      isLogout: true,
                    ),
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
      onTap: onPressed ??
          () {
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
