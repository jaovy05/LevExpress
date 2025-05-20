import 'package:flutter/material.dart';
import '../AppBackend/register_form.dart';

class Registerscreen extends StatelessWidget {
  const Registerscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          }, 
          icon: const Icon(Icons.arrow_back, color: Colors.black)
        ),
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
            RegisterForm(),
          ],
        ),
      ),
    );
  }
}