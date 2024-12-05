import 'package:flutter/material.dart';
import 'package:calendario/styles/colors.dart';
import 'package:calendario/database/sql_helper.dart';
import 'package:provider/provider.dart';
import 'package:calendario/database/user_provider.dart';
import 'package:calendario/screens/LoginCadastro/login.dart';

import 'edit_password_screen.dart';

class InfoPessoal extends StatelessWidget {
  const InfoPessoal({super.key});

  // Função para confirmar e deletar o usuário
  void _confirmDeleteUser(BuildContext context, int userId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tem certeza?",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text("Esta ação não pode ser desfeita."),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Deletar", style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await SQLHelper().deleteUser(userId);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Informações Pessoais'),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditPasswordScreen()),
                );
              },
              child: _buildInfoCard(
                context,
                icon: Icons.person,
                label: "Nome",
                value: user.username,
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditPasswordScreen()),
                );
              },
              child: _buildInfoCard(
                context,
                icon: Icons.email,
                label: "Email",
                value: user.email,
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditPasswordScreen()),
                );
              },
              child: _buildInfoCard(
                context,
                icon: Icons.cake,
                label: "Data de Nascimento",
                value: user.birthday,
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditPasswordScreen()),
                );
              },
              child: _buildInfoCard(
                context,
                icon: Icons.password,
                label: "Senha",
                value: '•' * (user.password.length),
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => _confirmDeleteUser(context, user.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Deletar Usuário",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para criar cards com ícones e informações do usuário
  Widget _buildInfoCard(BuildContext context,
      {required IconData icon, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 30),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
