import 'package:calendario/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendario/database/user_provider.dart';
import 'package:calendario/database/sql_helper.dart';

class EditUsernameScreen extends StatefulWidget {
  const EditUsernameScreen({super.key});

  @override
  _EditUsernameScreenState createState() => _EditUsernameScreenState();
}

class _EditUsernameScreenState extends State<EditUsernameScreen> {
  final _usernameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _usernameController.text = userProvider.user?.username ?? ''; // Preenche com o nome atual
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _saveUsername() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final newUsername = _usernameController.text.trim();

    if (newUsername.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O nome de usuário não pode estar vazio')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Chamando o método updateUsername com o ID do usuário e o novo nome
      await userProvider.updateUsername(userProvider.user!.id, newUsername);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome de usuário atualizado com sucesso!')),
      );
      Navigator.of(context).pop(); // Fecha a tela após salvar
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar o nome de usuário')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alterar nome de usuário',
          style: TextStyle(color: AppColors.terciary, fontSize:24, fontWeight: FontWeight.bold), // Definindo a cor do texto
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Novo Nome de Usuário'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveUsername,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary, // Cor de fundo do botão
                foregroundColor: AppColors.terciary
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
