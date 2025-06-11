// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class api_map extends StatefulWidget {
  const api_map({super.key});

  @override
  api_map_state createState() => api_map_state();
}

class api_map_state extends State<api_map> {
  List<LatLng>? route_points;
  String? route_info;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(-27.0968, -52.6186), // Localização inicial (atualizado)
                initialZoom: 12.0, // Use initialZoom em vez de zoom
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png", // URL sem subdomínios
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}