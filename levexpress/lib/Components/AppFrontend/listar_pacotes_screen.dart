import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../AppBackend/api_config.dart';

class ListarPacotesScreen extends StatefulWidget {
  const ListarPacotesScreen({super.key});

  @override
  State<ListarPacotesScreen> createState() => _ListarPacotesScreenState();
}

class _ListarPacotesScreenState extends State<ListarPacotesScreen> {
  List<dynamic> _pacotes = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPacotes();
  }

  Future<void> _fetchPacotes() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/pacotes'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _pacotes = data['pacotes'] ?? [];
        });
      } else {
        setState(() {
          _error = 'Erro ao buscar pacotes';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erro ao conectar com o servidor';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listar Pacotes'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : _pacotes.isEmpty
                  ? const Center(child: Text('Nenhum pacote cadastrado.'))
                  : ListView.builder(
                      itemCount: _pacotes.length,
                      itemBuilder: (context, index) {
                        final pacote = _pacotes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text('Pacote #${pacote['nr_pacote']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Empresa: ${pacote['empresa_origem']}'),
                                Text('Endereço: ${pacote['endereco_entrega']}'),
                                Text('Entrega: ${pacote['data_entrega']?.substring(0, 10) ?? ''}'),
                                Text('Cadastro: ${pacote['data_cadastro']?.substring(0, 10) ?? ''}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
