import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
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
        final loginResponse = LoginResponse.fromJson(decodedData);

        // Kirim FCM token ke backend setelah login
        await _saveFcmToken(loginResponse.token ?? '');

        return loginResponse;
      } else {
        throw Exception(decodedData['message'] ?? 'Gagal melakukan login');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<void> _saveFcmToken(String authToken) async {
    try {
      final fcmToken = GetStorage().read('fcm_token');

      print('=== SAVE FCM TOKEN ===');
      print('FCM Token: $fcmToken');
      print('Auth Token: $authToken');

      if (fcmToken == null || fcmToken.isEmpty) {
        print('FCM token kosong, skip');
        return;
      }

      final response = await http.post(
        Uri.parse(ApiConfig.saveToken),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({'fcm_token': fcmToken}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print('Gagal kirim FCM token: $e');
    }
  }
}
