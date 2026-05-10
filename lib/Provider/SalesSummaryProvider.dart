import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:kawaiii_coffee/services/baseUrl.dart';

class SalesSummaryProvider {
  final _box = GetStorage();

  String get _token => _box.read('auth_token') ?? '';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $_token',
  };

  Future<Map<String, dynamic>> getSalesSummary(String period) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.salesSummary}?period=$period'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        return jsonBody['data'];
      } else {
        throw Exception(
          'Gagal memuat summary (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Kesalahan API Summary: $e');
    }
  }
}
