import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
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
          Uri.parse('http://192.168.0.105:3000/login'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'nome': emailNormalizado, 'senha': _password}),
        );
        if (response.statusCode == 200) {
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          setState(() {
            _error = 'Email ou senha incorretos.';
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

  void _cadastro() {
    Navigator.pushReplacementNamed(context, '/register');
  }

  // TO DO
  void _toBeDone() {
    Navigator.pushReplacementNamed(context, '/passwordReset');
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
              'Entrar',
              style: TextStyle(
              fontSize: 28,
              color: const Color.fromARGB(255, 0, 0, 0),
              ),
              textAlign: TextAlign.center,
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
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
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
              SizedBox(height: 8),
              TextButton(
              onPressed: _toBeDone,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                'Esqueci minha senha',
                style: TextStyle(color: const Color.fromARGB(255, 3, 74, 131)),
                ),
              ),
              ),
              ],
              ),
            ),
            OutlinedButton(
              onPressed: _login,
              style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: const Color.fromARGB(255, 3, 74, 131),
              minimumSize: const Size.fromHeight(50), // Faz o botão ocupar toda a largura disponível
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)
              ),
              child: Text('Entrar', style: TextStyle(color: Colors.white)),
            ),
            Center(
              child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                'Não tem conta ainda ?',
                style: TextStyle(color: Colors.black),
                ),
                TextButton(
                onPressed: _cadastro,
                child: Text(
                  'Criar conta',
                  style: TextStyle(color: const Color.fromARGB(255, 3, 74, 131)),
                ),
                ),
              ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}