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
  int? pointId;
  bool saving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      final data = args;
      final idVal = data['id'];
      pointId = idVal is int ? idVal : int.tryParse(idVal.toString());
      nameCtrl.text = data['name'] ?? '';
      addressCtrl.text = data['address'] ?? '';
    }
  }

  Future<void> _save() async {
    if (pointId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ID do ponto inválido")));
      return;
    }
    setState(() => saving = true);
    try {
      final resp = await ApiService.updatePoint(id: pointId!, name: nameCtrl.text, address: addressCtrl.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resp)));
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro: $e")));
    } finally {
      setState(() => saving = false);
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
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
              onPressed: saving ? null : _save,
              icon: const Icon(Icons.save),
              label: Text(saving ? "Salvando..." : "Salvar Alterações"),
            ),
          ],
        ),
      ),
    );
  }
}
