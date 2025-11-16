import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl = "http://127.0.0.1:8000/api";

  static Future<List<dynamic>> getNearbyPoints(double lat, double lng) async {
    final uri = Uri.parse("$baseUrl/nearby?lat=$lat&lng=$lng");

    final response = await http.get(
      uri,
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao buscar locais: ${response.statusCode} ${response.body}");
    }

    final decoded = jsonDecode(response.body);

    if (decoded is List) return decoded;

    if (decoded is Map && decoded["results"] is List) {
      return decoded["results"];
    }

    for (final entry in (decoded as Map).entries) {
      if (entry.value is List) return entry.value;
    }

    return [];
  }

  static Future<List<dynamic>> getAllPoints() async {
    final uri = Uri.parse("$baseUrl/points");

    final response = await http.get(
      uri,
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao buscar pontos: ${response.statusCode}");
    }

    final decoded = jsonDecode(response.body);

    if (decoded is List) return decoded;

    if (decoded is Map && decoded["data"] is List) return decoded["data"];

    return [];
  }

  static Future<String> createPoint({
    required String name,
    required String address,
    required double lat,
    required double lng,
  }) async {
    final uri = Uri.parse("$baseUrl/points");

    final response = await http.post(
      uri,
      headers: {"Accept": "application/json"},
      body: {
        "name": name,
        "address": address,
        "latitude": lat.toString(),
        "longitude": lng.toString(),
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      return "Erro ao salvar ponto: ${response.body}";
    }

    return "Ponto cadastrado com sucesso!";
  }

  static Future<String> updatePoint({
    required int id,
    required String name,
    required String address,
  }) async {
    final uri = Uri.parse("$baseUrl/points/$id");

    final response = await http.put(
      uri,
      headers: {"Accept": "application/json"},
      body: {
        "name": name,
        "address": address,
      },
    );

    if (response.statusCode == 200) {
      return "Ponto atualizado!";
    }

    return "Erro ao atualizar: ${response.body}";
  }

  static Future<String> deletePoint(int id) async {
    final uri = Uri.parse("$baseUrl/points/$id");

    final response = await http.delete(
      uri,
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      return "Ponto deletado!";
    }

    return "Erro ao deletar ponto: ${response.body}";
  }
}
