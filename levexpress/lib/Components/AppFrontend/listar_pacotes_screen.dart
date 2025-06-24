import 'package:flutter/material.dart';
import '../AppBackend/listar_pacotes_list.dart';
import '../../core/app_cores.dart';

class ListarPacotesScreen extends StatelessWidget {
  const ListarPacotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppCores.appBarBackground,
        title: const Text('Listar Pacotes',
            style: TextStyle(color: AppCores.appBarTitle, fontFamily: 'Montserrat')),
      ),
      body: const ListarPacotesList(),
    );
  }
}
