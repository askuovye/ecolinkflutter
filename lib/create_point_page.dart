import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CreatePointPage extends StatefulWidget {
  const CreatePointPage({super.key});

  @override
  State<CreatePointPage> createState() => _CreatePointPageState();
}

class _CreatePointPageState extends State<CreatePointPage> {
  final nameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final latCtrl = TextEditingController();
  final lngCtrl = TextEditingController();

  Future<void> _savePoint() async {
    if (nameCtrl.text.isEmpty ||
        addressCtrl.text.isEmpty ||
        latCtrl.text.isEmpty ||
        lngCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos!")),
      );
      return;
    }

    final lat = double.tryParse(latCtrl.text);
    final lng = double.tryParse(lngCtrl.text);

    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Latitude e Longitude inválidas")),
      );
      return;
    }

    final resp = await ApiService.createPoint(
      name: nameCtrl.text,
      address: addressCtrl.text,
      lat: lat,
      lng: lng,
    );

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resp)));

    Navigator.pop(context); // volta para o mapa
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastrar Ponto")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: addressCtrl,
              decoration: const InputDecoration(labelText: "Endereço"),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: latCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Latitude"),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: lngCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Longitude"),
            ),

            const Spacer(),

            ElevatedButton.icon(
              onPressed: _savePoint,
              icon: const Icon(Icons.save),
              label: const Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}
