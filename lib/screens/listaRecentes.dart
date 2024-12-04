import 'package:calendario/database/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:calendario/styles/colors.dart';
import 'package:calendario/database/sql_helper.dart';
import 'package:provider/provider.dart';

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

  // Função para carregar memórias do banco de dados
  Future<void> _loadMemorias() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    if (user != null) {
      final memorias = await SQLHelper.getMemorias(user.id);
      setState(() {
        // Faz uma cópia antes de ordenar
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
            : _createListView(),
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

  // Função para exibir o diálogo com o texto da memória
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
