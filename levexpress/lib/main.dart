import 'package:flutter/material.dart';
import 'Components/AppFrontend/login_screen.dart';
import 'Components/AppFrontend/register_screen.dart';
import 'Components/AppFrontend/home_screen.dart';
import 'Components/AppFrontend/cadastrar_pacote_screen.dart';
import 'Components/AppFrontend/listar_pacotes_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LevExpress',
      theme: ThemeData(
      primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const Registerscreen(),
        '/home': (context) => const HomeScreen(),
        '/cadastrar-pacote': (context) => const CadastrarPacoteScreen(),
        '/listar-pacotes': (context) => const ListarPacotesScreen(),
      },
    );
  }
}
