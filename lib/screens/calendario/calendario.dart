import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'events_example.dart';  // Mantemos apenas a importação de events_example.dart
import 'package:calendario/styles/colors.dart';

class Calendario extends StatelessWidget {
  const Calendario({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TableCalendar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,

        // Tema específico para o AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary, // Cor de fundo do AppBar
          titleTextStyle: TextStyle(
            color: AppColors.white, // Cor do texto
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true, // Centraliza o título
        ),
      ),
      home: TableEventsExample(), // Definimos diretamente a tela de calendário de eventos
    );

  }

}
