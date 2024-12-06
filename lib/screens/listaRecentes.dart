import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:calendario/database/sql_helper.dart';
import 'package:calendario/database/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:calendario/styles/colors.dart';

class ListaRecentes extends StatefulWidget {
  const ListaRecentes({super.key});

  @override
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
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final user = userProvider.user;

  if (user == null || _memorias.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nenhuma memória para baixar!')),
    );
    return;
  }

  final buffer = StringBuffer();
  buffer.writeln('Memórias do Usuário: ${user.username}');
  for (var memoria in _memorias) {
    buffer.writeln('ID: ${memoria['id']}');
    buffer.writeln('Data: ${memoria['data']}');
    buffer.writeln('Texto: ${memoria['mensagem']}');
    buffer.writeln('-------------------');
  }

  try {
    // Solicita permissão para acessar o armazenamento
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final directory = Directory('/storage/emulated/0/Download');
      final filePath = '${directory.path}/memorias_${user.id}.txt';

      // Salva o arquivo na pasta de downloads
      final file = File(filePath);
      await file.writeAsString(buffer.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Arquivo salvo em: $filePath')),
      );
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permissão negada pelo usuário!')),
      );
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Permissão permanentemente negada! Habilite-a nas configurações.')),
      );
      await openAppSettings(); // Abre as configurações do app
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erro ao salvar o arquivo!')),
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
