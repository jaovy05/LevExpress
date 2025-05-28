import 'package:flutter/material.dart';
import '../AppBackend/listar_pacotes_list.dart';

class ListarPacotesScreen extends StatelessWidget {
  const ListarPacotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listar Pacotes'),
      ),
      body: const ListarPacotesList(),
    );
  }
}
