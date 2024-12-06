import 'package:flutter/material.dart';
import 'package:calendario/database/sql_helper.dart';
import 'package:calendario/database/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:calendario/styles/colors.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class ListaRecentes extends StatefulWidget {
  const ListaRecentes({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListaRecentesState createState() => _ListaRecentesState();
}

class _ListaRecentesState extends State<ListaRecentes> {
  List<Map<String, dynamic>> _memorias = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadMemorias();
  }

  Future<void> _loadMemorias() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    if (user != null) {
      final memorias = await SQLHelper.getMemorias(user.id);
      setState(() {
        _memorias = List<Map<String, dynamic>>.from(memorias)
          ..sort((a, b) => b['data'].compareTo(a['data']));
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadMemorias() async {
    if (_memorias.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Nenhuma memória disponível para download')),
      );
      return;
    }

    try {
      // Obtém o usuário logado
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro: usuário não encontrado')),
        );
        return;
      }

      // Formata as memórias para texto legível
      final StringBuffer content = StringBuffer();
      content.writeln('Usuario: ${user.username}');
      content.writeln('');
      content.writeln('Memorias:');
      content.writeln('');
      for (var memoria in _memorias) {
        content.writeln('     Memoria ${memoria['id']}');
        content.writeln('     Data: ${memoria['data']}');
        content.writeln('     Mensagem: ${memoria['mensagem']}');
        content.writeln('-------------------------------------');
      }

      // Diretório para salvar o arquivo
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/memorias.txt';

      // Salva o arquivo
      final file = File(filePath);
      await file.writeAsString(content.toString());

      // Notifica o usuário e tenta abrir o arquivo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Memórias salvas em: $filePath')),
      );
      await OpenFile.open(filePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar as memórias')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Memórias recentes',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.primary,
          elevation: 4.0,
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(child: _createListView()),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: _downloadMemorias,
                      icon: const Icon(Icons.download, size: 24),
                      label: const Text(
                        'Baixar todas as memórias',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 4.0,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _createListView() {
    if (_memorias.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma memória encontrada',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      itemCount: _memorias.length,
      itemBuilder: (context, index) {
        final memoria = _memorias[index];
        return Card(
          elevation: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: const Icon(
              Icons.notes,
              color: AppColors.secondary,
            ),
            title: Text('Memória ${memoria['id']}'),
            subtitle: Text(memoria['data']),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => _showMemoriaDialog(context, memoria),
          ),
        );
      },
    );
  }

  void _showMemoriaDialog(BuildContext context, Map<String, dynamic> memoria) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Memória ${memoria['id']}'),
          content: Text(memoria['mensagem']),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
