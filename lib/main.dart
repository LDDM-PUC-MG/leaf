import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'screens/calendario.dart';
import 'screens/perfil.dart';
import 'screens/LoginCadastro/login.dart';
import 'screens/LoginCadastro/cadastro.dart';
import 'package:calendario/screens/quemsomos.dart';
import 'styles/colors.dart';

void main() => runApp(const MaterialApp(home: BottomNavBar()));

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  int _page = 1;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Simulação do estado de login
  bool isLoggedIn = false; // Alterar conforme o estado do login do usuário

  final List<Widget> _pages = [
    LoginScreen(), // Indice 0
    Quemsomos(), // Indice 1
    Calendario(), // Indice 2
    CadastroPage(), // Indice 3
    perfilUsuario(), // Indice 4
  ];

  void _onTap(int index) {
    setState(() {
      _page = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        items: const <Widget>[
          Icon(Icons.list, size: 30, color: AppColors.background), // Lista de Memórias
          Icon(Icons.home, size: 30, color: AppColors.background), // Quem somos
          Icon(Icons.add, size: 30, color: AppColors.background), // Adicionar recordações
          Icon(Icons.calendar_month, size: 30, color: AppColors.background), // Calendário
          Icon(Icons.account_box, size: 30, color: AppColors.background), // Perfil de Usuário
        ],
        color: AppColors.primary,
        buttonBackgroundColor: AppColors.primary,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: _onTap, // Use the method for tap handling
        letIndexChange: (index) => true,
      ),
      body: _pages[_page], // Atualiza o body com a tela correspondente
    );
  }
}

class PageWidget extends StatelessWidget {
  final Color color;
  final String text;

  const PageWidget({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(text, style: const TextStyle(fontSize: 40, color: Colors.white)),
      ),
    );
  }
}
