import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_config.dart';
import 'package:flutter/material.dart';

class ListarDatasEntregas extends StatefulWidget {
  const ListarDatasEntregas({super.key});

  @override
  ListarDatasEntregasState createState() => ListarDatasEntregasState();
}

class ListarDatasEntregasState extends State<ListarDatasEntregas> {
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
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
          child: Text(_error!,
              style: const TextStyle(color: Colors.red, fontSize: 16)));
    }
    if (_pacotes.isEmpty) {
      return const Center(child: Text('Nenhum pacote encontrado.'));
    }

    // Agrupar pacotes por data_entrega (yyyy-MM-dd)
    final Map<String, List<dynamic>> pacotesPorData = {};
    for (var pacote in _pacotes) {
      final dataEntrega = pacote['data_entrega'];
      if (dataEntrega != null && dataEntrega.length >= 10) {
        final dataKey = dataEntrega.substring(0, 10); // yyyy-MM-dd
        pacotesPorData.putIfAbsent(dataKey, () => []).add(pacote);
      }
    }

    final datasOrdenadas = pacotesPorData.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // mais recentes primeiro

    return ListView.builder(
      itemCount: datasOrdenadas.length,
      itemBuilder: (context, index) {
        final dataStr = datasOrdenadas[index];
        final partes = dataStr.split('-');
        final DateTime? dataSelecionada = DateTime.tryParse(dataStr);
        final totalPacotes = pacotesPorData[dataStr]?.length ?? 0;

        return ListTile(
          title: ElevatedButton(
            onPressed: () {
              if (dataSelecionada != null) {
                Navigator.of(context).pop(dataSelecionada);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${partes[2]}/${partes[1]}/${partes[0]}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '($totalPacotes pacote${totalPacotes > 1 ? 's' : ''})',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
