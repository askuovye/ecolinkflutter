import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UserPointsListPage extends StatefulWidget {
  const UserPointsListPage({super.key});

  @override
  State<UserPointsListPage> createState() => _UserPointsListPageState();
}

class _UserPointsListPageState extends State<UserPointsListPage> {
  List<dynamic> points = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await ApiService.getAllPoints();
    setState(() {
      points = list;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pontos Registrados")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: points.length,
              itemBuilder: (context, i) {
                final p = points[i];
                return ListTile(
                  title: Text(p["name"]),
                  subtitle: Text(p["address"] ?? ""),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.pushNamed(context, "/edit-point", arguments: p)
                          .then((_) => _load());
                    },
                  ),
                );
              },
            ),
    );
  }
}
