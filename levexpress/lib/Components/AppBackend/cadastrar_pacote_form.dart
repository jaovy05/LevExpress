import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_config.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

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

  // Adicionado para sugestões de endereço
  List<dynamic> _sugestoesEndereco = [];
  Timer? _debounceEndereco;

  @override
  void dispose() {
    _nrPacoteController.dispose();
    _empresaOrigemController.dispose();
    _enderecoEntregaController.dispose();
    _debounceEndereco?.cancel();
    super.dispose();
  }

  Future<bool> _validarEndereco(String endereco) async {
    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(endereco)}&format=json&limit=1',
    );
    try {
      final response = await http.get(uri, headers: {'User-Agent': 'flutter_app'});
      if (response.statusCode == 200) {
        final results = jsonDecode(response.body);
        return results != null && results is List && results.isNotEmpty;
      }
    } catch (_) {}
    return false;
  }

  Future<void> _registrarPacote() async {
    if (_formKey.currentState!.validate() && _dataEntrega != null) {
      setState(() {
        _loading = true;
        _error = null;
        _success = null;
      });

      // Validação do endereço
      final enderecoValido = await _validarEndereco(_enderecoEntregaController.text.trim());
      if (!enderecoValido) {
        setState(() {
          _loading = false;
          _error = 'Endereço inválido. Por favor, verifique e tente novamente.';
        });
        return;
      }

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

  // Novo método para abrir busca visual de endereço
  Future<void> _abrirBuscaEnderecoNoMapa(BuildContext context) async {
    final searchController = TextEditingController(text: _enderecoEntregaController.text);
    LatLng? selectedLatLng;
    String? selectedEndereco;
    List<dynamic> searchResults = [];
    Timer? debounce;

    // Tenta obter localização atual para ordenar por proximidade
    LatLng? userLocation;
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      userLocation = LatLng(position.latitude, position.longitude);
    } catch (_) {
      userLocation = null;
    }

    if (!context.mounted) return; // Use context.mounted para checagem correta

    await showDialog(
      context: context,
      builder: (context) {
        final mapController = MapController();
        LatLng mapCenter = userLocation ?? LatLng(-27.0968, -52.6186);

        return StatefulBuilder(
          builder: (context, setState) {
            String formatarEndereco(Map address, String? displayName) {
              // Usa apenas o nome do local (primeira informação do display_name), depois campos essenciais e CEP no final
              final List<String> partes = [];
              if (displayName != null && displayName.isNotEmpty) {
                final nomeLocal = displayName.split(',').first.trim();
                if (nomeLocal.isNotEmpty) partes.add(nomeLocal);
              }
              if (address['road'] != null) partes.add(address['road']);
              if (address['house_number'] != null) partes.add(address['house_number']);
              if (address['suburb'] != null) partes.add(address['suburb']);
              if (address['city'] != null) {
                partes.add(address['city']);
              } else if (address['town'] != null) {
                partes.add(address['town']);
              } else if (address['village'] != null) {
                partes.add(address['village']);
              }
              if (address['state'] != null) partes.add(address['state']);
              if (address['country'] != null) partes.add(address['country']);
              if (address['postcode'] != null) partes.add(address['postcode']);
              return partes.where((e) => e.toString().trim().isNotEmpty).join(', ');
            }

            double calcularDistancia(LatLng a, LatLng b) {
              final Distance distance = Distance();
              return distance.as(LengthUnit.Kilometer, a, b);
            }

            Future<void> buscarEndereco(String query) async {
              if (query.isEmpty) {
                setState(() => searchResults = []);
                return;
              }
              final uri = Uri.parse(
                  'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&addressdetails=1&limit=10');
              final response = await http.get(uri, headers: {'User-Agent': 'flutter_app'});
              if (response.statusCode == 200) {
                final results = jsonDecode(response.body);
                List<dynamic> lista = (results is List)
                    ? results.where((item) => item['address'] != null).toList()
                    : [];
                // Ordena por proximidade se localização disponível
                if (userLocation != null) {
                  lista.sort((a, b) {
                    final latA = double.tryParse(a['lat'] ?? '');
                    final lonA = double.tryParse(a['lon'] ?? '');
                    final latB = double.tryParse(b['lat'] ?? '');
                    final lonB = double.tryParse(b['lon'] ?? '');
                    if (latA == null || lonA == null || latB == null || lonB == null) return 0;
                    final distA = userLocation != null
                        ? calcularDistancia(userLocation, LatLng(latA, lonA))
                        : 0.0;
                    final distB = userLocation != null
                        ? calcularDistancia(userLocation, LatLng(latB, lonB))
                        : 0.0;
                    return distA.compareTo(distB);
                  });
                }
                setState(() {
                  searchResults = lista;
                });
              } else {
                setState(() => searchResults = []);
              }
            }

            Future<void> buscarEnderecoPorLatLng(LatLng latlng) async {
              final uri = Uri.parse(
                  'https://nominatim.openstreetmap.org/reverse?lat=${latlng.latitude}&lon=${latlng.longitude}&format=json&addressdetails=1');
              final response = await http.get(uri, headers: {'User-Agent': 'flutter_app'});
              if (response.statusCode == 200) {
                final data = jsonDecode(response.body);
                final address = data['address'] ?? {};
                final displayName = data['display_name'] as String?;
                final enderecoFormatado = formatarEndereco(address, displayName);
                setState(() {
                  selectedEndereco = enderecoFormatado;
                  searchController.text = enderecoFormatado;
                  _enderecoEntregaController.text = enderecoFormatado;
                });
              }
            }

            // Campo de busca com sugestões rápidas
            Widget campoBuscaComSugestoes() {
              return Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Digite o endereço',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      if (debounce?.isActive ?? false) debounce!.cancel();
                      debounce = Timer(const Duration(milliseconds: 500), () {
                        buscarEndereco(value);
                      });
                    },
                  ),
                  if (searchResults.isNotEmpty)
                    Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final item = searchResults[index];
                          final address = item['address'] ?? {};
                          final displayName = item['display_name'] as String?;
                          final enderecoFormatado = formatarEndereco(address, displayName);
                          return ListTile(
                            title: Text(enderecoFormatado),
                            onTap: () {
                              final lat = double.parse(item['lat']);
                              final lon = double.parse(item['lon']);
                              setState(() {
                                selectedLatLng = LatLng(lat, lon);
                                selectedEndereco = enderecoFormatado;
                                searchController.text = enderecoFormatado;
                                _enderecoEntregaController.text = enderecoFormatado;
                                mapController.move(selectedLatLng!, 17);
                                searchResults = [];
                              });
                            },
                          );
                        },
                      ),
                    ),
                ],
              );
            }

            return AlertDialog(
              title: const Text('Buscar Endereço'),
              content: SizedBox(
                width: 350,
                height: 400,
                child: Column(
                  children: [
                    campoBuscaComSugestoes(),
                    const SizedBox(height: 8),
                    Expanded(
                      child: FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          initialCenter: selectedLatLng ?? mapCenter,
                          initialZoom: 15,
                          onTap: (tapPosition, latlng) {
                            setState(() {
                              selectedLatLng = latlng;
                            });
                            buscarEnderecoPorLatLng(latlng);
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                          ),
                          if (selectedLatLng != null)
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: selectedLatLng!,
                                  width: 40,
                                  height: 40,
                                  child: const Icon(Icons.location_on, color: Colors.red, size: 36),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    if (selectedEndereco != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          selectedEndereco!,
                          style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    debounce?.cancel();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: selectedEndereco != null
                      ? () {
                          _enderecoEntregaController.text = selectedEndereco!;
                          debounce?.cancel();
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text('Confirmar'),
                ),
              ],
            );
          },
        );
      },
    );
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
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Endereço de Entrega',
                hintText: 'Digite o endereço de entrega',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.map),
                  tooltip: 'Buscar no mapa',
                  onPressed: () => _abrirBuscaEnderecoNoMapa(context),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o endereço de entrega';
                }
                return null;
              },
              onChanged: (value) {
                _debounceEndereco?.cancel();
                if (value.trim().isEmpty) {
                  setState(() => _sugestoesEndereco = []);
                  return;
                }
                _debounceEndereco = Timer(const Duration(milliseconds: 600), () {
                  _mostrarSugestoesEndereco(context, value);
                });
              },
            ),
            if (_sugestoesEndereco.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 2),
                constraints: const BoxConstraints(maxHeight: 220),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _sugestoesEndereco.length,
                  itemBuilder: (context, index) {
                    final item = _sugestoesEndereco[index];
                    final address = item['address'] ?? {};
                    final displayName = item['display_name'] as String?;
                    final enderecoFormatado = _formatarEnderecoSugestao(address, displayName);
                    return ListTile(
                      title: Text(enderecoFormatado),
                      onTap: () {
                        _enderecoEntregaController.text = enderecoFormatado;
                        setState(() {
                          _sugestoesEndereco.clear();
                        });
                      },
                    );
                  },
                ),
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

  // Sugestão de endereços diretamente no campo
  void _mostrarSugestoesEndereco(BuildContext context, String query) async {
    if (query.isEmpty) return;
    final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&addressdetails=1&limit=5');
    final response = await http.get(uri, headers: {'User-Agent': 'flutter_app'});
    if (response.statusCode == 200) {
      final results = jsonDecode(response.body);
      final List<dynamic> sugestoes = (results is List)
          ? results.where((item) => item['address'] != null).toList()
          : [];
      if (sugestoes.isNotEmpty && context.mounted) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: sugestoes.length,
              itemBuilder: (context, index) {
                final item = sugestoes[index];
                final address = item['address'] ?? {};
                final displayName = item['display_name'] as String?;
                final enderecoFormatado = _formatarEnderecoSugestao(address, displayName);
                return ListTile(
                  title: Text(enderecoFormatado),
                  onTap: () {
                    _enderecoEntregaController.text = enderecoFormatado;
                    Navigator.of(context).pop();
                  },
                );
              },
            );
          },
        );
      }
    }
  }

  String _formatarEnderecoSugestao(Map address, String? displayName) {
    // Mesmo padrão do formatarEndereco
    final List<String> partes = [];
    if (displayName != null && displayName.isNotEmpty) {
      final nomeLocal = displayName.split(',').first.trim();
      if (nomeLocal.isNotEmpty) partes.add(nomeLocal);
    }
    if (address['road'] != null) partes.add(address['road']);
    if (address['house_number'] != null) partes.add(address['house_number']);
    if (address['suburb'] != null) partes.add(address['suburb']);
    if (address['city'] != null) {
      partes.add(address['city']);
    } else if (address['town'] != null) {
      partes.add(address['town']);
    } else if (address['village'] != null) {
      partes.add(address['village']);
    }
    if (address['state'] != null) partes.add(address['state']);
    if (address['country'] != null) partes.add(address['country']);
    if (address['postcode'] != null) partes.add(address['postcode']);
    return partes.where((e) => e.toString().trim().isNotEmpty).join(', ');
  }
}
