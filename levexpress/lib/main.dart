import 'package:flutter/material.dart';
import 'Components/AppFrontend/LoginScreen.dart';
import 'Components/AppFrontend/RegisterScreen.dart';
import 'Components/AppFrontend/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
        '/home': (context) => const home_screen(),
      },
    );
  }
}
