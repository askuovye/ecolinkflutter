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

  // mantenha user marker separado para não removê-lo ao atualizar
  Marker? _userMarker;
  final List<Marker> _otherMarkers = [];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('O serviço de localização está desativado')),
        );
      }
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition();

    setState(() {
      _center = LatLng(pos.latitude, pos.longitude);
      _userMarker = Marker(
        width: 50,
        height: 50,
        point: _center!,
        child: const Icon(Icons.my_location, size: 30, color: Colors.blue),
      );
    });
  }

  Future<void> _buscarLocais() async {
    setState(() => _loading = true);

    try {
      final results = await ApiService.getAllPoints();

      _otherMarkers.clear();

      for (var p in results) {
        final name = p["name"] ?? "Sem nome";
        final lat = double.tryParse(p["latitude"].toString());
        final lng = double.tryParse(p["longitude"].toString());

        if (lat == null || lng == null) continue;

        _otherMarkers.add(
          Marker(
            width: 80,
            height: 80,
            point: LatLng(lat, lng),
            child: Tooltip(
              message: name,
              child: const Icon(
                Icons.location_on,
                size: 32,
                color: Colors.green,
              ),
            ),
          ),
        );
    }

    setState(() {});
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erro ao carregar pontos: $e")),
    );
  }

  setState(() => _loading = false);
}


  @override
  Widget build(BuildContext context) {
    final allMarkers = <Marker>[];
    if (_userMarker != null) allMarkers.add(_userMarker!);
    allMarkers.addAll(_otherMarkers);

    return Scaffold(
      appBar: AppBar(
        title: const Text("EcoLink - Mapa"),
      ),
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
                      MarkerLayer(markers: allMarkers),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton.icon(
                    onPressed: _loading ? null : _buscarLocais,
                    icon: const Icon(Icons.search),
                    label: const Text("Buscar Locais Próximos"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, "/points-list");
                        },
                        icon: const Icon(Icons.list),
                        label: const Text("Ver Pontos Registrados"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, "/create-point");
                        },
                        icon: const Icon(Icons.add_location_alt),
                        label: const Text("Cadastrar Novo Ponto"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
