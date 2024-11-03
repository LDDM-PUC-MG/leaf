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
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Simulação do estado de login
  bool isLoggedIn = false; // Alterar conforme o estado do login do usuário

  final List<Widget> _pages = [
    const Calendario(),
    Quemsomos(),
    const LoginScreen(),
    CadastroPage(),
    perfilUsuario(),
  ];

  void _onTap(int index) {
    setState(() {
      _page = index;
      // Mostra um SnackBar com a página atual
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Você está na página: ${_getPageName(index)}'),
          duration: const Duration(seconds: 1),
        ),
      );
    });
  }

  String _getPageName(int index) {
    switch (index) {
      case 0:
        return "Calendário";
      case 1:
        return "Quem Somos";
      case 2:
        return "Login";
      case 3:
        return "Cadastro";
      case 4:
        return "perfilUsuario";
      default:
        return "Início";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        items: const <Widget>[
          Icon(Icons.list, size: 30, color: AppColors.background),
          Icon(Icons.home, size: 30, color: AppColors.background),
          Icon(Icons.add, size: 30, color: AppColors.background),
          Icon(Icons.call_split, size: 30, color: AppColors.background),
          Icon(Icons.account_box, size: 30, color: AppColors.background),
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
