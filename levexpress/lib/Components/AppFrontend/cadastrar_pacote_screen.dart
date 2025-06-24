import 'package:flutter/material.dart';
import '../AppBackend/cadastrar_pacote_form.dart';
import '../../core/app_cores.dart';

class CadastrarPacoteScreen extends StatelessWidget {
  const CadastrarPacoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppCores.appBarBackground,
        title: const Text('Cadastrar Pacote',
            style: TextStyle(color: AppCores.appBarTitle, fontFamily: 'Montserrat')),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: CadastrarPacoteForm(),
      ),
    );
  }
}
