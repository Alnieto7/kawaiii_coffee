import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kawaiii_coffee/Model/product_model.dart';

class ProductService {

  static Future<List<ProductModel>> fetchProducts() async {

    final response = await http.get(
      Uri.parse("http://202.10.48.252/api/products"),
    );

    if (response.statusCode == 200) {

      final json = jsonDecode(response.body);

      final List data = json["data"];

      return data
          .map((e) => ProductModel.fromJson(e))
          .toList();
  
    } else {
      throw Exception("Gagal mengambil produk");
    }
  }
}