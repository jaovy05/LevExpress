// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import '../AppBackend/api_map.dart';
import '../Utils/plus_button.dart';
import '../AppBackend/listar_datas_entregas.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? selectedDate;

  void _navigateToCadastroPacote(BuildContext context) async {
    final selectedDate = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Iniciar Rota'),
          content: const ListarDatasEntregas(),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        this.selectedDate = selectedDate;
      });
    }
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
                      child: api_map(date: selectedDate), // Passe a data aqui
                    ),
                    Positioned(
                      bottom: 20,
                      left: 16,
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => _navigateToCadastroPacote(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 236, 237, 238),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            elevation: 6,
                          ),
                          child: const Text(
                            'Iniciar Rota',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
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
                ),
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
                      Navigator.pushNamed(context, '/cadastrar-pacote');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.list_alt),
                    title: const Text('Listar Pacotes'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/listar-pacotes');
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: const Text('Sair', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}