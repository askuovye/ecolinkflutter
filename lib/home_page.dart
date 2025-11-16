import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng? _center;
  bool _loading = false;

  Marker? _userMarker;
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    final pos = await Geolocator.getCurrentPosition();

    setState(() {
      _center = LatLng(pos.latitude, pos.longitude);
      _userMarker = Marker(
        width: 50,
        height: 50,
        point: _center!,
        child: const Icon(Icons.my_location, color: Colors.blue, size: 30),
      );
    });
  }

  Future<void> _buscarTodos() async {
    setState(() => _loading = true);

    try {
      final list = await ApiService.getAllPoints();
      _markers.clear();

      for (var p in list) {
        final lat = double.tryParse(p["latitude"].toString());
        final lng = double.tryParse(p["longitude"].toString());
        if (lat == null || lng == null) continue;

        _markers.add(
          Marker(
            width: 60,
            height: 60,
            point: LatLng(lat, lng),
            child: Tooltip(
              message: p["name"],
              child: const Icon(Icons.location_on, color: Colors.green, size: 35),
            ),
          ),
        );
      }

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erro: $e")));
    }

    setState(() => _loading = false);
  }

  Future<void> _buscarProximos() async {
    if (_center == null) return;

    setState(() => _loading = true);

    try {
      final list = await ApiService.getNearbyPoints(
        _center!.latitude,
        _center!.longitude,
      );

      _markers.clear();

      for (var p in list) {
        final lat = p["lat"] is num ? p["lat"].toDouble() : double.tryParse(p["lat"].toString());
        final lng = p["lng"] is num ? p["lng"].toDouble() : double.tryParse(p["lng"].toString());
        if (lat == null || lng == null) continue;

        _markers.add(
          Marker(
            width: 60,
            height: 60,
            point: LatLng(lat, lng),
            child: Tooltip(
              message: p["name"],
              child: const Icon(Icons.place, color: Colors.orange, size: 35),
            ),
          ),
        );
      }

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erro: $e")));
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[];
    if (_userMarker != null) markers.add(_userMarker!);
    markers.addAll(_markers);

    return Scaffold(
      appBar: AppBar(title: const Text("EcoLink — Mapa")),
      body: _center == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: _center!,
                      initialZoom: 13,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      ),
                      MarkerLayer(markers: markers),
                    ],
                  ),
                ),

                // Botões
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _loading ? null : _buscarProximos,
                        icon: const Icon(Icons.location_searching),
                        label: const Text("Buscar Locais Próximos (Google + Banco)"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _loading ? null : _buscarTodos,
                        icon: const Icon(Icons.list),
                        label: const Text("Listar Todos os Pontos"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(context, "/points-list"),
                        icon: const Icon(Icons.map),
                        label: const Text("Ver Pontos Registrados"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(context, "/create-point"),
                        icon: const Icon(Icons.add_location_alt),
                        label: const Text("Cadastrar Novo Ponto"),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
