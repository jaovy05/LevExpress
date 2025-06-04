// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import '../AppBackend/api_map.dart';

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
              child: Center(
                child: api_map(), // Chama a função api_map para exibir o mapa
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}