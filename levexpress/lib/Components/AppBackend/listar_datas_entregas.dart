import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_config.dart';
import 'package:flutter/material.dart';
import '../../core/app_cores.dart';

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
    _limparListaPacotes();
  }

  void _limparListaPacotes() {
    _pacotes.clear();
    _loading = true;
    _error = null;
    _pacotes = []; 
  }

  Future<void> _fetchPacotes() async {
    setState(() {
      _loading = true;
      _error = null;
      _pacotes = [];
    });
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/pacotes'));
      _limparListaPacotes();
      setState(() {
        _pacotes = [];
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _pacotes = [];
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
              style: TextStyle(color: AppCores.error, fontSize: 16, fontFamily: 'Montserrat')));
    }
    if (_pacotes.isEmpty) {
      return const Center(child: Text('Nenhum pacote encontrado.'));
    }

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

    // O redesign já está correto, mas para garantir que o AlertDialog não seja chamado recursivamente,
    // verifique se você está usando ListarDatasEntregas apenas como lista, e não chamando showDialog dentro dela.
    return ListView.builder(
      itemCount: datasOrdenadas.length,
      itemBuilder: (context, index) {
        final dataStr = datasOrdenadas[index];
        final partes = dataStr.split('-');
        final DateTime? dataSelecionada = DateTime.tryParse(dataStr);
        final totalPacotes = pacotesPorData[dataStr]?.length ?? 0;
        final empresas = <String>{};
        for (var pacote in pacotesPorData[dataStr] ?? []) {
          if (pacote['empresa_origem'] != null) {
            empresas.add(pacote['empresa_origem']);
          }
        }

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: AppCores.buttonBackground.withAlpha(40),
          highlightColor: AppCores.buttonBackground.withAlpha(20),
          onTap: () {
            if (dataSelecionada != null) {
              Navigator.of(context).pop(dataSelecionada);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppCores.cardBackground,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppCores.inputBorder.withAlpha(10),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: AppCores.inputBorder,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${partes[2]}/${partes[1]}/${partes[0]}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppCores.title,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: AppCores.buttonBackground, size: 20),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.inventory_2, size: 18, color: AppCores.subtitle),
                      const SizedBox(width: 6),
                      Text(
                        '$totalPacotes pacote${totalPacotes > 1 ? 's' : ''}',
                        style: const TextStyle(
                          color: AppCores.body,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  if (empresas.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.business, size: 18, color: AppCores.subtitle),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Empresas: ${empresas.join(', ')}',
                            style: const TextStyle(
                              color: AppCores.body,
                              fontFamily: 'Montserrat',
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.cardBackground,
      appBar: AppBar(
        backgroundColor: AppCores.appBarBackground,
        elevation: 0,
        title: const Text(
          'Datas de Entrega',
          style: TextStyle(
            color: AppCores.appBarTitle,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            fontSize: 24,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppCores.cardBackground,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppCores.inputBorder.withAlpha(30),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.calendar_today, color: AppCores.buttonBackground, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Veja as datas disponíveis para entrega dos seus pacotes!',
                style: TextStyle(
                  color: AppCores.body,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppCores.buttonBackground,
                  foregroundColor: AppCores.buttonText,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  textStyle: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: AppCores.cardBackground,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: const Text(
                          'Iniciar Rota',
                          style: TextStyle(
                            color: AppCores.title,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            fontSize: 22,
                          ),
                        ),
                        content: SizedBox(
                          width: double.maxFinite,
                          height: 400,
                          child: const ListarDatasEntregas(),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              foregroundColor: AppCores.buttonBackground,
                              textStyle: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppCores.buttonBackground,
                              textStyle: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Ver Datas de Entrega'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
