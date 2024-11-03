import 'package:flutter/material.dart';
import 'package:calendario/styles/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Screen',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: perfilUsuario(),
    );
  }
}

class perfilUsuario extends StatefulWidget {
  const perfilUsuario({super.key});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<perfilUsuario> {
  int _currentIndex = 0; // Index inicial da navigation bar

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      // Adicione aqui a lógica para navegação entre telas
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://via.placeholder.com/100'),
              ),
              SizedBox(height: 16),
              Text(
                'Johan Smith',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'California, USA',
                style: TextStyle(color: Colors.grey[700]),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InfoCard(label: 'Balance', value: '00.00'),
                  InfoCard(label: 'Orders', value: '10'),
                  InfoCard(label: 'Total Spent', value: '000.0'),
                ],
              ),
              SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    ProfileOption(icon: Icons.person, label: 'Nome de Usuário', value: 'JohanSmith'),
                    ProfileOption(icon: Icons.email, label: 'E-mail', value: 'johansmith@example.com'),
                    ProfileOption(icon: Icons.cake, label: 'Data de Nascimento', value: '01/01/1990'),
                    Divider(),
                    ProfileOption(icon: Icons.info, label: 'Personal Information'),
                    ProfileOption(icon: Icons.shopping_bag, label: 'Your Order'),
                    ProfileOption(icon: Icons.favorite, label: 'Your Favourites'),
                    ProfileOption(icon: Icons.payment, label: 'Payment'),
                    ProfileOption(icon: Icons.store, label: 'Recommended Shops'),
                    ProfileOption(icon: Icons.location_on, label: 'Nearest Shop'),
                    ProfileOption(icon: Icons.logout, label: 'Logout', isLogout: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String label;
  final String value;

  InfoCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[700])),
      ],
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final bool isLogout;

  ProfileOption({required this.icon, required this.label, this.value, this.isLogout = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.teal),
      title: Text(label),
      subtitle: value != null ? Text(value!) : null,
      trailing: isLogout ? null : Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        if (isLogout) {
          // Lógica para logout
        } else {
          // Lógica para navegação ou ação do item
        }
      },
    );
  }
}
