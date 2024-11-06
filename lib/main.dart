import 'package:calendario/screens/listaRecentes.dart';
import 'package:calendario/screens/memorias.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'screens/calendario/calendario.dart';
import 'screens/Perfil/perfil.dart';
import 'screens/LoginCadastro/login.dart';
import 'package:calendario/screens/quemsomos.dart';
import 'styles/colors.dart';
import 'package:provider/provider.dart';
import 'database/user_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MaterialApp(home: BottomNavBar()),
    ),
  );
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  int _page = 2;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _pages = [
    Quemsomos(), // Indice 0
    ListaRecentes(), // Indice 1
    Memorias(), // Indice 2
    Calendario(), // Indice 3
    PerfilUsuario(), // Indice 4
  ];

  void _onTap(int index) {
    setState(() {
      _page = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtém o estado do usuário pelo Provider
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    // Se o usuário não está logado, redireciona para a tela de login
    if (user == null) {
      return const LoginScreen();
    }

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        items: const <Widget>[
          Icon(Icons.info, size: 30, color: AppColors.terciary), // Quem somos 
          Icon(Icons.list, size: 30, color: AppColors.terciary), // Lista de Memórias
          Icon(Icons.add, size: 30, color: AppColors.terciary), // Adicionar recordações
          Icon(Icons.calendar_month, size: 30, color: AppColors.terciary), // Calendário
          Icon(Icons.account_box, size: 30, color: AppColors.terciary), // Perfil de Usuário
        ],
        color: AppColors.primary,
        buttonBackgroundColor: AppColors.primary,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: _onTap,
        letIndexChange: (index) => true,
      ),
      body: _pages[_page],
    );
  }
}
