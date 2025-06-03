import 'package:flutter/material.dart';
import 'package:levexpress/Components/AppFrontend/Plus_button.dart';
import '../AppBackend/LoginForm.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('LevExpress',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 186, 5, 5),
            ),
          ),
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LoginForm(),
          ],
        ),
      ),
      floatingActionButton: PlusButton(
        onPressed: () {
          // Exemplo: navegar para a tela de registro
          Navigator.pushNamed(context, '/register');
        },
      ),
    );
  }
}
