import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_config.dart';

class CadastrarPacoteForm extends StatefulWidget {
  const CadastrarPacoteForm({super.key});

  @override
  CadastrarPacoteFormState createState() => CadastrarPacoteFormState();
}

class CadastrarPacoteFormState extends State<CadastrarPacoteForm> {
  final _formKey = GlobalKey<FormState>();
  final _nrPacoteController = TextEditingController();
  final _empresaOrigemController = TextEditingController();
  final _enderecoEntregaController = TextEditingController();
  DateTime? _dataEntrega;
  bool _loading = false;
  String? _error;
  String? _success;

  @override
  void dispose() {
    _nrPacoteController.dispose();
    _empresaOrigemController.dispose();
    _enderecoEntregaController.dispose();
    super.dispose();
  }

  Future<void> _registrarPacote() async {
    if (_formKey.currentState!.validate() && _dataEntrega != null) {
      setState(() {
        _loading = true;
        _error = null;
        _success = null;
      });

      try {
        final response = await http.post(
          Uri.parse('$apiBaseUrl/pacotes'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'nr_pacote': int.parse(_nrPacoteController.text),
            'empresa_origem': _empresaOrigemController.text.trim(),
            'endereco_entrega': _enderecoEntregaController.text.trim(),
            'data_entrega': _dataEntrega!.toIso8601String(),
          }),
        );

        if (response.statusCode == 201) {
          setState(() {
            _success = 'Pacote cadastrado com sucesso!';
          });
          _formKey.currentState!.reset();
          _nrPacoteController.clear();
          _empresaOrigemController.clear();
          _enderecoEntregaController.clear();
          _dataEntrega = null;
        } else {
          String errorMsg = 'Erro ao cadastrar pacote.';
          try {
            final data = json.decode(response.body);
            if (data is Map && data.containsKey('message')) {
              errorMsg = data['message'];
            }
          } catch (_) {}
          setState(() {
            _error = errorMsg;
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
    } else if (_dataEntrega == null) {
      setState(() {
        _error = 'Por favor, selecione a data de entrega.';
      });
    }
  }

  Future<void> _selecionarDataEntrega(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _dataEntrega = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Cadastro de Pacote',
              style: TextStyle(fontSize: 28, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nrPacoteController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Número do Pacote',
                hintText: 'Digite o número identificador do pacote',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o número do pacote';
                }
                if (int.tryParse(value) == null) {
                  return 'Número do pacote inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _empresaOrigemController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Empresa de Origem',
                hintText: 'Digite a empresa de origem',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe a empresa de origem';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _enderecoEntregaController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Endereço de Entrega',
                hintText: 'Digite o endereço de entrega',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o endereço de entrega';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _dataEntrega == null
                        ? 'Selecione a data de entrega'
                        : 'Data de entrega: ${_dataEntrega!.day}/${_dataEntrega!.month}/${_dataEntrega!.year}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: () => _selecionarDataEntrega(context),
                  child: const Text('Selecionar Data'),
                ),
              ],
            ),
            const SizedBox(height: 18),
            OutlinedButton(
              onPressed: _loading ? null : _registrarPacote,
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
                      'Cadastrar',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            if (_success != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _success!,
                  style: const TextStyle(color: Colors.green, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
