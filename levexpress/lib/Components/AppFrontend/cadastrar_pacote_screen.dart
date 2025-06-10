import 'package:flutter/material.dart';
import '../AppBackend/cadastrar_pacote_form.dart';

class CadastrarPacoteScreen extends StatelessWidget {
  const CadastrarPacoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Pacote'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: CadastrarPacoteForm(),
      ),
    );
  }
}
