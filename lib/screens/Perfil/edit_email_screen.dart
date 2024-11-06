import 'package:calendario/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendario/database/user_provider.dart';

class EditEmailScreen extends StatefulWidget {
  const EditEmailScreen({super.key});

  @override
  _EditEmailScreenState createState() => _EditEmailScreenState();
}

class _EditEmailScreenState extends State<EditEmailScreen> {
  final _emailController = TextEditingController(); // Controlador para o email
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _emailController.text = userProvider.user?.email ?? ''; // Preenche com o email atual
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveEmail() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final newEmail = _emailController.text.trim();

    if (newEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O email não pode estar vazio')),
      );
      return;
    }

    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(newEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um email válido')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Chamando o método updateEmail com o ID do usuário e o novo email
      await userProvider.updateEmail(userProvider.user!.id, newEmail);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email atualizado com sucesso!')),
      );
      Navigator.of(context).pop(); // Fecha a tela após salvar
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar o email')),
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
          'Alterar Email',
          style: TextStyle(color: AppColors.terciary, fontSize:24, fontWeight: FontWeight.bold),
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
              controller: _emailController, // Usando o controlador de email
              decoration: const InputDecoration(labelText: 'Novo Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveEmail,
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
