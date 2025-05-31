// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import '../AppBackend/api_map.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
        Navigator.pushReplacementNamed(context, '/login');
          },
        ),
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
              child: Center(
                child: api_map(), // Chama a função api_map para exibir o mapa
              ),
              ),
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