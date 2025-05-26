import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_config.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _loading = false;
  String? _error;
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
        _error = null;
      });

      try {
        final response = await http.post(
          Uri.parse('$apiBaseUrl/login'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': _emailController.text.trim().toLowerCase(),
            'senha': _passwordController.text
          }),
        );

        if (response.statusCode == 200) {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          final errorData = json.decode(response.body);
          String errorMessage = 'Email ou senha incorretos';
          
          if (response.statusCode == 400 || response.statusCode == 401) {
            if (errorData['message']?.contains('bloqueado') ?? false) {
              errorMessage = 'Conta bloqueada. Entre em contato com o suporte.';
            } else if (errorData['message']?.contains('inativo') ?? false) {
              errorMessage = 'Conta inativa. Entre em contato com o suporte.';
            } else if (errorData['message']?.contains('senha') ?? false) {
              errorMessage = 'Senha incorreta. Por favor, tente novamente.';
            } else if (errorData['message']?.contains('email') ?? false) {
              errorMessage = 'Email não cadastrado. Verifique ou crie uma conta.';
            }
          }

          setState(() {
            _error = errorMessage;
          });
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        }
      } catch (e) {
        setState(() {
          _error = 'Erro ao conectar com o servidor';
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao conectar com o servidor'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      }
    }
  }

  void _navigateToRegister() {
    Navigator.pushReplacementNamed(context, '/register');
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Digite seu email',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira um email válido';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Senha',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Digite sua senha',
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
            if (value == null || value.isEmpty) {
              return 'Por favor, insira sua senha';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return OutlinedButton(
      onPressed: _loading ? null : _login,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: const Color.fromARGB(255, 3, 74, 131),
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      child: _loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Text(
              'Entrar',
              style: TextStyle(color: Colors.white),
            ),
    );
  }

  Widget _buildRegisterLink() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Não tem conta ainda?',
            style: TextStyle(color: Colors.black),
          ),
          TextButton(
            onPressed: _navigateToRegister,
            child: const Text(
              'Criar conta',
              style: TextStyle(color: Color.fromARGB(255, 3, 74, 131)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Entrar',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildEmailField(),
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 18),
              _buildLoginButton(),
              const SizedBox(height: 16),
              _buildRegisterLink(),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}