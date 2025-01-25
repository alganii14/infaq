import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/infaq_models.dart';

class ApiService {
  final String baseUrl = 'http://192.168.71.231:8000/api/infaqs';

  Future<List<Infaq>> fetchInfaq() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((e) => Infaq.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> createInfaq(Infaq infaq) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: json.encode(infaq.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create data');
    }
  }

  Future<void> updateInfaq(Infaq infaq) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${infaq.id}'),
      body: json.encode(infaq.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update data');
    }
  }

  Future<void> deleteInfaq(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete data');
    }
  }
}
