import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kawaiii_coffee/Model/ProductModel.dart';
import 'package:kawaiii_coffee/services/baseUrl.dart';

class ProductProvider {
  // Sesuaikan nama kelas dengan pemanggilan di Controller
  static Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.products),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Sesuai JSON: data ada di dalam key 'data'
        if (responseData['success'] == true) {
          final List listData = responseData['data'];
          return listData.map((e) => ProductModel.fromJson(e)).toList();
        } else {
          throw Exception(responseData['message'] ?? 'Gagal memuat data');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal mengambil produk: $e');
    }
  }
}
