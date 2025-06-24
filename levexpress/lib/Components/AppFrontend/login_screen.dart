import 'package:flutter/material.dart';
import '../AppBackend/login_form.dart';
import '../../core/app_cores.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppCores.appBarBackground,
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
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              const LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
