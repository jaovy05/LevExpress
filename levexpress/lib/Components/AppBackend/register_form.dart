import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_config.dart';
import '../../core/app_cores.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  RegisterFormState createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _cnhController = TextEditingController();

  bool _loading = false;
  String? _error;
  String? _success;
  bool _obscureText = true;
  bool _obscureConfirmText = true;

  // Constantes para strings
  static const _registerTitle = 'Registre-se';
  static const _nameLabel = 'Nome';
  static const _nameHint = 'Digite seu nome completo';
  static const _emailLabel = 'Email';
  static const _emailHint = 'Digite seu email';
  static const _passwordLabel = 'Senha';
  static const _passwordHint = 'Senha';
  static const _confirmPasswordLabel = 'Confirmar Senha';
  static const _confirmPasswordHint = 'Confirme sua senha';
  static const _cnhLabel = 'CNH';
  static const _cnhHint = 'Digite o número da sua CNH';
  static const _registerButton = 'Registrar';
  static const _loginText = 'Já tem uma conta? Faça login';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cnhController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/entregadores'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome': _nameController.text.trim(),
          'email': _emailController.text.trim().toLowerCase(),
          'senha': _passwordController.text,
          'cnh': _cnhController.text
        }),
      );

      if (response.statusCode == 201) {
        if (!mounted) return;
        _showSuccessDialog();
      } else {
        final errorData = json.decode(response.body);
        String errorMessage = 'Erro ao realizar o registro';
        
        // Tratamento específico para CNH duplicada
        if (response.statusCode == 400 || response.statusCode == 409) {
          if (errorData['message']?.contains('CNH') ?? false) {
            errorMessage = 'CNH já cadastrada. Por favor, verifique o número ou recupere sua conta.';
          } else if (errorData['message']?.contains('email') ?? false) {
            errorMessage = 'Email já cadastrado. Por favor, use outro email ou faça login.';
          }
        }

        setState(() {
          _error = errorMessage;
        });
        
        // Mostra um SnackBar com a mensagem de erro
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
      String errorMessage = 'Erro ao conectar com o servidor';

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
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }
}

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Sucesso'),
        content: const Text('Registro realizado com sucesso!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToLogin();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _nameLabel,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppCores.inputLabel, fontFamily: 'Montserrat'),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: _nameHint,
            hintStyle: TextStyle(color: AppCores.inputHint, fontFamily: 'Montserrat'),
          ),
          style: const TextStyle(color: AppCores.inputLabel, fontFamily: 'Montserrat'),
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira um nome válido';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _emailLabel,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppCores.inputLabel, fontFamily: 'Montserrat'),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: _emailHint,
            hintStyle: TextStyle(color: AppCores.inputHint, fontFamily: 'Montserrat'),
          ),
          style: const TextStyle(color: AppCores.inputLabel, fontFamily: 'Montserrat'),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira um email válido';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
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
        Text(
          _passwordLabel,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppCores.inputLabel, fontFamily: 'Montserrat'),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: _passwordHint,
            hintStyle: const TextStyle(color: AppCores.inputHint, fontFamily: 'Montserrat'),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: AppCores.inputLabel,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
          style: const TextStyle(color: AppCores.inputLabel, fontFamily: 'Montserrat'),
          obscureText: _obscureText,
          validator: (value) {
            if (value == null || value.isEmpty || value.length < 6) {
              return 'A senha deve ter pelo menos 6 caracteres';
            }
            if (!RegExp(r'[A-Z]').hasMatch(value)) {
              return 'A senha deve conter pelo menos uma letra maiúscula';
            }
            if (!RegExp(r'[0-9]').hasMatch(value)) {
              return 'A senha deve conter pelo menos um número';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _confirmPasswordLabel,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppCores.inputLabel, fontFamily: 'Montserrat'),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: _confirmPasswordHint,
            hintStyle: const TextStyle(color: AppCores.inputHint, fontFamily: 'Montserrat'),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmText ? Icons.visibility_off : Icons.visibility,
                color: AppCores.inputLabel,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmText = !_obscureConfirmText;
                });
              },
            ),
          ),
          style: const TextStyle(color: AppCores.inputLabel, fontFamily: 'Montserrat'),
          obscureText: _obscureConfirmText,
          validator: (value) {
            if (value != _passwordController.text) {
              return 'As senhas não coincidem';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCnhField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _cnhLabel,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppCores.inputLabel, fontFamily: 'Montserrat'),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _cnhController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: _cnhHint,
            hintStyle: TextStyle(color: AppCores.inputHint, fontFamily: 'Montserrat'),
          ),
          style: const TextStyle(color: AppCores.inputLabel, fontFamily: 'Montserrat'),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty || value.length != 11) {
              return 'Por favor, insira um número de CNH válido';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return OutlinedButton(
      onPressed: _loading ? null : _register,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: AppCores.buttonBackground,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: _loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: AppCores.buttonText,
                strokeWidth: 2,
              ),
            )
          : Text(
              _registerButton,
              style: const TextStyle(color: AppCores.buttonText, fontFamily: 'Montserrat'),
            ),
    );
  }

  Widget _buildLoginLink() {
    return TextButton(
      onPressed: _navigateToLogin,
      child: const Text(
        _loginText,
        style: TextStyle(color: AppCores.buttonBackground, fontFamily: 'Montserrat'),
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
              Text(
                _registerTitle,
                style: const TextStyle(
                  fontSize: 28,
                  color: AppCores.title,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildNameField(),
              const SizedBox(height: 16),
              _buildEmailField(),
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 16),
              _buildConfirmPasswordField(),
              const SizedBox(height: 16),
              _buildCnhField(),
              const SizedBox(height: 18),
              _buildRegisterButton(),
              const SizedBox(height: 8),
              _buildLoginLink(),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _error!,
                    style: TextStyle(color: AppCores.error, fontSize: 16, fontFamily: 'Montserrat'),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (_success != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _success!,
                    style: TextStyle(color: AppCores.success, fontSize: 16, fontFamily: 'Montserrat'),
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