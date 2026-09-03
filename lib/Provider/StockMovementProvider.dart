import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:kawaiii_coffee/services/baseUrl.dart';

class StockMovementProvider {
  final box = GetStorage();

  Future<bool> createMovement({
    required int ingredientId,
    required String type,
    required int quantity,
    required String reference,
    required String notes,
  }) async {
    final token = box.read('auth_token');

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.adjustStock), 
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'ingredient_id': ingredientId,
          'type': type, 
          'quantity': quantity,
          'reference': reference,
          'description': notes,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true; 
      } else {
        final error = jsonDecode(response.body);

        // 👇 BONGKAR ERROR VALIDASI LARAVEL DI SINI 👇
        if (error['errors'] != null) {
          List<String> errorList = [];
          // Looping semua error yang dikirim server
          (error['errors'] as Map<String, dynamic>).forEach((key, value) {
            // value biasanya berbentuk list, kita ambil pesan pertamanya (value[0])
            errorList.add('$key: ${value[0]}'); 
          });
          
          // Lemparkan semua pesan error agar muncul di Snackbar
          throw Exception(errorList.join('\n'));
        }

        // Jika bukan error validasi, lempar pesan default
        throw Exception(error['message'] ?? 'Gagal menyimpan data');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}