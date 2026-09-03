import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:kawaiii_coffee/Model/IngredientModel.dart'; 
import 'package:kawaiii_coffee/services/baseUrl.dart'; 

class IngredientProvider {
  final box = GetStorage();

  Future<List<IngredientModel>> getIngredients() async {
    final token = box.read('auth_token');
    
    try {
      final response = await http.get(
        // 👇 Langsung pakai ApiConfig di sini
        Uri.parse(ApiConfig.ingredients), 
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonBody = jsonDecode(response.body); 
        return jsonBody.map((e) => IngredientModel.fromJson(e)).toList();
      } else {
        throw Exception('Gagal memuat bahan baku (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Kesalahan API Ingredient: $e');
    }
  }
}