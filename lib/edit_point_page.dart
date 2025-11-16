import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EditPointPage extends StatefulWidget {
  const EditPointPage({super.key});

  @override
  State<EditPointPage> createState() => _EditPointPageState();
}

class _EditPointPageState extends State<EditPointPage> {
  final nameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  late int pointId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final data = ModalRoute.of(context)!.settings.arguments as Map;

    pointId = data["id"];
    nameCtrl.text = data["name"] ?? "";
    addressCtrl.text = data["address"] ?? "";
  }

  Future<void> _save() async {
    final resp = await ApiService.updatePoint(
      id: pointId,
      name: nameCtrl.text,
      address: addressCtrl.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(resp)),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Ponto")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Nome")),
            const SizedBox(height: 12),
            TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: "Endereço")),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text("Salvar Alterações"),
            ),
          ],
        ),
      ),
    );
  }
}
