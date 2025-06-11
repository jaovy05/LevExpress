// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import '../AppBackend/api_map.dart';
import '../Utils/plus_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateToCadastroPacote(BuildContext context) {
    Navigator.pushNamed(context, '/cadastrar-pacote');
  }

  void _navigateToListarPacotes(BuildContext context) {
    Navigator.pushNamed(context, '/listar-pacotes');
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LevExpress'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Expanded(
              child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Stack(
                children: [
                  Center(
                    child: api_map(), // Chama a função api_map para exibir o mapa
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: PlusButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/cadastrar-pacote');
                      },
                    ),
                  ) 
                ],
              )
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
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
            // Botão Sair na parte inferior do Drawer
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: const Text('Sair', style: TextStyle(color: Colors.red)),
                onTap: () => _logout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}