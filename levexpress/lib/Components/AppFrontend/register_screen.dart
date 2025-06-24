import 'package:flutter/material.dart';
import '../AppBackend/register_form.dart';
import '../../core/app_cores.dart';

class Registerscreen extends StatelessWidget {
  const Registerscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppCores.appBarBackground,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          icon: const Icon(Icons.arrow_back, color: AppCores.backButton),
        ),
        title: const Center(
          child: Text('LevExpress',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppCores.appBarTitle,
              fontFamily: 'Montserrat',
            ),
          ),
        )
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RegisterForm(),
            ],
          ),
        ),
      ),
    );
  }
}