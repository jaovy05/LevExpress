// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_config.dart';

class api_map extends StatefulWidget {
  final DateTime? date;

  const api_map({super.key, this.date});

  @override
  api_map_state createState() => api_map_state();
}

class api_map_state extends State<api_map> {
  LatLng? _currentLocation;
  String? _error;

  final PopupController _popupLayerController = PopupController();
  final List<Marker> _pacoteMarkers = [];
  final List<Map<String, dynamic>> _pacotesComCoordenadas = [];
  List<LatLng> _rota = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void didUpdateWidget(covariant api_map oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.date != oldWidget.date && widget.date != null && _currentLocation != null) {
      _fetchPacotes();
    }
  }

  Future<LatLng?> _getLatLngFromAddress(String endereco) async {
    final baseUrl = 'https://nominatim.openstreetmap.org/search';
    final bounds = _currentLocation != null
        ? '&viewbox=${_currentLocation!.longitude - 0.5},${_currentLocation!.latitude + 0.5},${_currentLocation!.longitude + 0.5},${_currentLocation!.latitude - 0.5}&bounded=1'
        : '';
    final uri = Uri.parse('$baseUrl?q=$endereco&format=json&limit=1$bounds');
    try {
      final response = await http.get(uri, headers: {'User-Agent': 'flutter_app'});
      if (response.statusCode == 200) {
        final results = jsonDecode(response.body);
        if (results.isNotEmpty) {
          final lat = double.parse(results[0]['lat']);
          final lon = double.parse(results[0]['lon']);
          return LatLng(lat, lon);
        }
      }
    } catch (_) {}
    return null;
  }

  Future<void> _fetchPacotes() async {
    if (_currentLocation == null || widget.date == null) return;

    setState(() {
      _error = null;
      _pacoteMarkers.clear();
      _pacotesComCoordenadas.clear();
      _rota.clear();
    });

    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/pacotes'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> pacotes = data['pacotes'] ?? [];

        pacotes = pacotes.where((p) {
          final dataEntrega = p['data_entrega'];
          if (dataEntrega == null) return false;
          final date = DateTime.tryParse(dataEntrega);
          return date != null &&
              date.year == widget.date!.year &&
              date.month == widget.date!.month &&
              date.day == widget.date!.day;
        }).toList();

        final Distance distance = Distance();
        final List<Map<String, dynamic>> entregas = [];

        for (final pacote in pacotes) {
          final endereco = pacote['endereco_entrega'];
          if (endereco != null && endereco.toString().isNotEmpty) {
            final coord = await _getLatLngFromAddress(endereco);
            if (coord != null) {
              final dist = distance.as(LengthUnit.Kilometer, _currentLocation!, coord);
              entregas.add({
                'pacote': pacote,
                'coordenada': coord,
                'distancia': dist,
              });
            }
          }
        }

        entregas.sort((a, b) => (a['distancia'] as double).compareTo(b['distancia'] as double));

        final markers = entregas.map((e) {
          return Marker(
            point: e['coordenada'],
            width: 40,
            height: 40,
            key: ValueKey(e['coordenada']),
            child: const Icon(Icons.location_on, color: Colors.green, size: 36),
          );
        }).toList();

        setState(() {
          _pacotesComCoordenadas.addAll(entregas);
          _pacoteMarkers.addAll(markers);
        });

        await _calcularRotaComOSRM([_currentLocation!, ...entregas.map((e) => e['coordenada'] as LatLng)]);
      } else {
        setState(() => _error = 'Erro ao buscar pacotes');
      }
    } catch (e) {
      setState(() => _error = 'Erro ao conectar com o servidor');
    }
  }

  Future<void> _calcularRotaComOSRM(List<LatLng> pontos) async {
    if (pontos.length < 2) return;

    final coords = pontos.map((p) => '${p.longitude},${p.latitude}').join(';');
    final uri = Uri.parse('https://router.project-osrm.org/route/v1/driving/$coords?overview=full&geometries=geojson');

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final geometry = data['routes'][0]['geometry']['coordinates'] as List;

        final rota = geometry.map<LatLng>((coord) => LatLng(coord[1], coord[0])).toList();

        setState(() {
          _rota = rota;
        });
      } else {
        setState(() => _error = 'Erro ao calcular rota');
      }
    } catch (e) {
      setState(() => _error = 'Erro na rota: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _error = null);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _error = 'Por favor, ative a localização do dispositivo.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _error = 'Permissão de localização negada.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _error = 'Permissão negada permanentemente.');
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
      if (widget.date != null) {
        _fetchPacotes();
      }
    } catch (e) {
      setState(() => _error = 'Erro ao obter localização: $e');
    }
  }

  List<Marker> _buildCurrentLocationMarker() {
    if (_currentLocation == null) return [];
    return [
      Marker(
        point: _currentLocation!,
        width: 40,
        height: 40,
        child: const Icon(Icons.my_location, color: Colors.blue, size: 36),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (_error != null)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.red.withOpacity(0.2),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _currentLocation ?? LatLng(-27.0968, -52.6186),
                initialZoom: 13.0,
                onTap: (_, __) => _popupLayerController.hideAllPopups(),
              ),
              children: [
                TileLayer(urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png"),
                MarkerLayer(markers: _buildCurrentLocationMarker()),
                PopupMarkerLayer(
                  options: PopupMarkerLayerOptions(
                    markers: _pacoteMarkers,
                    popupController: _popupLayerController,
                    popupDisplayOptions: PopupDisplayOptions(
                      builder: (BuildContext context, Marker marker) {
                        final match = _pacotesComCoordenadas.firstWhere(
                          (p) => p['coordenada'] == marker.point,
                          orElse: () => {},
                        );

                        final pacote = match['pacote'];
                        final distancia = match['distancia'];

                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Endereço: ${pacote?['endereco_entrega'] ?? 'N/A'}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                if (distancia != null)
                                  Text(
                                    'Distância: ${distancia.toStringAsFixed(2)} km',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                PolylineLayer(
                  polylines: _rota.length >= 2
                      ? <Polyline>[
                          Polyline(
                            points: _rota,
                            strokeWidth: 4.0,
                            color: Colors.red,
                          )
                        ]
                      : <Polyline>[],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
