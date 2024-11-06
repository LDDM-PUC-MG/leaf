import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendario/database/user_provider.dart';
import 'package:calendario/styles/colors.dart';
import 'package:intl/intl.dart'; // Para formatar a data

class EditBirthdayScreen extends StatefulWidget {
  const EditBirthdayScreen({super.key});

  @override
  _EditBirthdayScreenState createState() => _EditBirthdayScreenState();
}

class _EditBirthdayScreenState extends State<EditBirthdayScreen> {
  final _birthdayController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _birthdayController.text = userProvider.user?.birthday ?? ''; // Preenche com a data atual
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    super.dispose();
  }

  // Método para mostrar o seletor de data
  Future<void> _selectDate(BuildContext context) async {
    final currentDate = DateTime.now();
    final initialDate = DateTime.tryParse(_birthdayController.text) ?? currentDate;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900), // Definindo a primeira data válida
      lastDate: currentDate,
    );

    if (pickedDate != null && pickedDate != initialDate) {
      final formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      setState(() {
        _birthdayController.text = formattedDate;
      });
    }
  }

  Future<void> _saveBirthday() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final newBirthday = _birthdayController.text.trim();

    if (newBirthday.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A data de nascimento não pode estar vazia')),
      );
      return;
    }

    // Validação simples de formato de data
    if (!RegExp(r"^\d{2}/\d{2}/\d{4}$").hasMatch(newBirthday)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira uma data válida no formato dd/MM/yyyy')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Chama o método updateBirthday
      await userProvider.updateBirthday(userProvider.user!.id, newBirthday);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data de nascimento atualizada com sucesso!')),
      );
      Navigator.of(context).pop(); // Fecha a tela após salvar
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar a data de nascimento')),
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
          'Alterar Data de Nascimento',
          style: TextStyle(color: AppColors.terciary, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () => _selectDate(context), // Ao tocar no campo, abre o DatePicker
              child: AbsorbPointer(  // Absorve o toque para que o TextField não seja editável diretamente
                child: TextField(
                  controller: _birthdayController,
                  decoration: const InputDecoration(
                    labelText: 'Nova Data de Nascimento (dd/MM/yyyy)',
                  ),
                  keyboardType: TextInputType.none,  // Impede a digitação manual
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveBirthday,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary, // Cor de fundo do botão
                foregroundColor: AppColors.terciary,
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
