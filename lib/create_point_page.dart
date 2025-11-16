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

  Future<void> _save() async {
    final name = nameCtrl.text;
    final address = addressCtrl.text;
    final lat = double.tryParse(latCtrl.text);
    final lng = double.tryParse(lngCtrl.text);

    if (name.isEmpty || address.isEmpty || lat == null || lng == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preencha tudo!")));
      return;
    }

    final resp = await ApiService.createPoint(
      name: name,
      address: address,
      lat: lat,
      lng: lng,
    );

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resp)));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Novo Ponto")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Nome")),
            const SizedBox(height: 12),
            TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: "Endereço")),
            const SizedBox(height: 12),
            TextField(controller: latCtrl, decoration: const InputDecoration(labelText: "Latitude")),
            const SizedBox(height: 12),
            TextField(controller: lngCtrl, decoration: const InputDecoration(labelText: "Longitude")),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text("Salvar"),
            )
          ],
        ),
      ),
    );
  }
}
