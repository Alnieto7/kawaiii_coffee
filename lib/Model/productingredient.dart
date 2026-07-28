import 'package:kawaiii_coffee/Model/IngredientModel.dart';

class ProductIngredientModel {
  final int id;
  final int productId;
  final int ingredientId;
  final double quantity; // jumlah bahan baku yang dibutuhkan per 1 produk
  final IngredientModel ingredient;

  ProductIngredientModel({
    required this.id,
    required this.productId,
    required this.ingredientId,
    required this.quantity,
    required this.ingredient,
  });

  factory ProductIngredientModel.fromJson(Map<String, dynamic> json) {
    return ProductIngredientModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      ingredientId: json['ingredient_id'] ?? 0,
      quantity: double.tryParse(json['quantity'].toString()) ?? 0,
      ingredient: IngredientModel.fromJson(json['ingredient']),
    );
  }
}