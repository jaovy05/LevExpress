import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  String _cnh = '';
  // ignore: unused_field
  bool _loading = false;
  // ignore: unused_field
  String? _error;
  bool _obscureText = true;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final emailNormalizado = _email.trim().toLowerCase();
      setState(() {
        _loading = true;
        _error = null;
      });

      try {
        final response = await http.post(
          // Uri.parse('http://192.168.0.105:5000/entregadores'),//uso local
          Uri.parse('https://b71a-2804-1100-8bf4-3300-35ad-d8b7-6218-da93.ngrok-free.app/entregadores'),//uso ngrok
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'nome': _name, 'email': emailNormalizado, 'senha': _password, 'cnh': _cnh}),
        );
        if (response.statusCode == 201) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
              'Registro realizado com sucesso!',
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
            await Future.delayed(Duration(seconds: 2));
          _loginCadastro();
        } else {
          setState(() {
            _error = 'Dados incorretos.';
          });
        }
      } catch (e) {
        setState(() {
          _error = 'Erro ao conectar com o servidor.';
        });
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _loginCadastro() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text(
              'Registre-se',
              style: TextStyle(
              fontSize: 28,
              color: const Color.fromARGB(255, 0, 0, 0),
              ),
              textAlign: TextAlign.center,
            ),
                      const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
              'Nome',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite seu nome completo',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um nome válido';
                }
                return null;
              },
              onSaved: (value) => _name = value!,
              ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
              'Email',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
              decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Digite seu email',
              ),
              validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira um email válido';
              }
              return null;
              },
              onSaved: (value) => _email = value!,
              ),
              ],
            ),
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
            'Senha',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Senha',
              suffixIcon: IconButton(
              icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
              setState(() {
              _obscureText = !_obscureText;
              });
              },
              ),
            ),
            obscureText: _obscureText,
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 6) {
              return 'A senha deve ter pelo menos 6 caracteres';
              }
              return null;
            },
            onSaved: (value) => _password = value!,
            ),
            ],
            ),
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text('CNH',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Digite o número da sua CNH',
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length != 11) {
                return 'Por favor, insira um número de CNH válido';
              }
              return null;
            },
            onSaved: (value) => _cnh = value!,
            ),
            ],
            ),
            SizedBox(height: 18),
            OutlinedButton(
              onPressed: _login,
              style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: const Color.fromARGB(255, 3, 74, 131),
              minimumSize: const Size.fromHeight(50), // Faz o botão ocupar toda a largura disponível
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)
              ),
              child: Text('Registrar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}


