import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class SalesSummaryProvider {
  // Pastikan URL base-nya sesuai dengan servermu
  static const String baseUrl = 'http://202.10.48.252/api';
  final box = GetStorage();

  Future<Map<String, dynamic>> getSalesSummary(String period) async {
    final token = box.read('auth_token');
    
    try {
      final response = await http.get(
     Uri.parse('$baseUrl/reports/sales-summary?period=$period'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        return jsonBody['data']; 
      } else {
        throw Exception('Gagal memuat summary dari server (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Kesalahan API Summary: $e');
    }
  }
}