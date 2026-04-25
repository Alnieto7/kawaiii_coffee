import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kawaiii_coffee/Model/LoginModel.dart';

class AuthProvider {
  static const String baseUrl = 'http://202.10.48.252/api/auth';

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json', // <-- TAMBAHAN 1: Wajib agar server tidak membalas pakai HTML
        },
        body: jsonEncode({
          'name': email,
          'password': password,
        }),
      );

      // <-- TAMBAHAN 2: Print ke terminal untuk mengecek balasan asli dari server
      print('=== DEBUG API LOGIN ===');
      print('Status Code: ${response.statusCode}');
      print('Body Balasan: ${response.body}');
      print('=======================');

      // <-- TAMBAHAN 3: Mencegah error "Unexpected character" jika server ngeyel kirim HTML
      if (response.body.trim().startsWith('<')) {
         throw Exception('Server mengalami masalah dan mengirim HTML (Status: ${response.statusCode}). Cek Terminal/Console untuk detailnya.');
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