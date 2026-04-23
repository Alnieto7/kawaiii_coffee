import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kawaiii_coffee/Model/LoginModel.dart';
// Import Model

class AuthProvider {
  static const String baseUrl = 'http://202.10.48.252/api/auth';

  // Return typenya diganti menjadi Future<LoginResponse>
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Parsing JSON mentah menjadi Object Model
        return LoginResponse.fromJson(decodedData);
      } else {
        throw Exception(decodedData['message'] ?? 'Gagal melakukan login');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}