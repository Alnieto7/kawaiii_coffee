import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kawaiii_coffee/Model/LoginModel.dart';
import 'package:kawaiii_coffee/services/baseUrl.dart';


class AuthProvider {
  Future<LoginResponse> login(String name, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.login),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'name': name, 'password': password}),
      );

      if (response.body.trim().startsWith('<')) {
        throw Exception('Server error (Status: ${response.statusCode})');
      }

      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(decodedData);
      } else {
        throw Exception(decodedData['message'] ?? 'Gagal melakukan login');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
