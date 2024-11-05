import 'package:grouped_list/grouped_list.dart';
import 'package:flutter/material.dart';
import 'package:calendario/styles/colors.dart';

List _elements = [
  {'name': 'Memória X', 'day': 'Dia 1'},
  {'name': 'Memória Y', 'day': 'Dia 2'},
  {'name': 'Memória Z', 'day': 'Dia 1'},
  {'name': 'Memória X', 'day': 'Dia 3'},
  {'name': 'Memória X', 'day': 'Dia 2'},
  {'name': 'Memória Z', 'day': 'Dia 3'},
];

class ListaRecentes extends StatelessWidget {
  const ListaRecentes({super.key});

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
              color: AppColors.white, // Cor do texto
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.primary, // Cor de fundo do AppBar
          elevation: 4.0,
          centerTitle: true,
        ),
        body: _createGroupedListView(),
      ),
    );
  }

  Widget _createGroupedListView() {
    return GroupedListView<dynamic, String>(
      elements: _elements,
      groupBy: (element) => element['day'],
      groupComparator: (value1, value2) => value2.compareTo(value1),
      itemComparator: (item1, item2) => item1['name'].compareTo(item2['name']),
      order: GroupedListOrder.DESC,
      useStickyGroupSeparators: true,
      groupSeparatorBuilder: (String value) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      itemBuilder: (context, element) {
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
            title: Text(element['name']),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Você clicou em ${element['name']}'),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
