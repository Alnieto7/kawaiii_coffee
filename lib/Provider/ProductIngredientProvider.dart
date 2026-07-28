import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:kawaiii_coffee/Model/productingredient.dart';
import 'package:kawaiii_coffee/services/baseUrl.dart';

class ProductIngredientProvider {
  static Future<List<ProductIngredientModel>> fetchByProduct(int productId) async {
    final box = GetStorage();
    final token = box.read('auth_token');

    try {
      final response = await http.get(
        Uri.parse(ApiConfig.productIngredients(productId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List listData = body['ingredients'] ?? [];
        return listData.map((e) => ProductIngredientModel.fromJson(e)).toList();
      } else {
        throw Exception('Gagal memuat resep produk (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Kesalahan API Product Ingredient: $e');
    }
  }
}