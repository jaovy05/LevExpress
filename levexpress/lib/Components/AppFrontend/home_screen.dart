import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateToCadastroPacote(BuildContext context) {
    Navigator.pushNamed(context, '/cadastrar-pacote');
  }

  void _navigateToListarPacotes(BuildContext context) {
    Navigator.pushNamed(context, '/listar-pacotes');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'LevExpress',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 186, 5, 5),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 3, 74, 131),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.menu, color: Colors.white, size: 40),
                  SizedBox(height: 12),
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add_box),
              title: const Text('Cadastrar Pacote'),
              onTap: () {
                Navigator.pop(context);
                _navigateToCadastroPacote(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('Listar Pacotes'),
              onTap: () {
                Navigator.pop(context);
                _navigateToListarPacotes(context);
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Bem-vindo ao LevExpress!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 3, 74, 131),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}