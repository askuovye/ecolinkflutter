import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  /// GET /api/points — lista todos os pontos
  static Future<List<dynamic>> getAllPoints() async {
    final uri = Uri.parse("$baseUrl/points");
    final res = await http.get(uri);

    if (res.statusCode != 200) return [];
    return jsonDecode(res.body);
  }

  /// GET /api/nearby — buscar pontos próximos (Google Places + salva no banco)
  static Future<List<dynamic>> getNearbyPoints(double lat, double lng) async {
    final uri = Uri.parse("$baseUrl/nearby?lat=$lat&lng=$lng");
    final res = await http.get(uri);

    if (res.statusCode != 200) return [];
    return jsonDecode(res.body);
  }

  /// POST /api/points — cria um ponto
  static Future<String> createPoint({
    required String name,
    required String address,
    required double lat,
    required double lng,
  }) async {
    final uri = Uri.parse("$baseUrl/points");

    final res = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "address": address,
        "latitude": lat,
        "longitude": lng,
      }),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return "Ponto criado com sucesso!";
    }

    return "Erro: ${res.body}";
  }

  /// PUT /api/points/{id}
  static Future<String> updatePoint({
    required int id,
    required String name,
    required String address,
  }) async {
    final uri = Uri.parse("$baseUrl/points/$id");

    final res = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "address": address,
      }),
    );

    return res.statusCode == 200 ? "Ponto atualizado!" : "Erro: ${res.body}";
  }

  /// DELETE /api/points/{id}
  static Future<String> deletePoint(int id) async {
    final uri = Uri.parse("$baseUrl/points/$id");
    final res = await http.delete(uri);

    return res.statusCode == 200 ? "Ponto deletado!" : "Erro: ${res.body}";
  }
}
