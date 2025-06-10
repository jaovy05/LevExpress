// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import '../AppBackend/api_map.dart';
import '../Utils/plus_button.dart';

class home_screen extends StatelessWidget {
  const home_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
        Navigator.pushReplacementNamed(context, '/login');
          },
        ),
        title: const Text('LevExpress'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Expanded(
              child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Stack(
                children: [
                  Center(
                    child: api_map(), // Chama a função api_map para exibir o mapa
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: PlusButton(
                      onPressed: () {
                        // Exemplo: navegar para a tela de registro
                        Navigator.pushNamed(context, '/register');
                      },
                    ),
                  ) 
                ],
              )
              ),
            ),
          ],
        ),
      ),
    );
  }
}