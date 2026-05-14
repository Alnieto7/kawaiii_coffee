class IngredientModel {
  final int id;
  final String name;
  final int stock;
  final String unit;
  final int minStock;

  IngredientModel({
    required this.id,
    required this.name,
    required this.stock,
    required this.unit,
    required this.minStock,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      // Konversi aman jika server sewaktu-waktu kirim format String atau Double
      stock: int.tryParse(json['stock'].toString()) ?? 0, 
      unit: json['unit'] ?? '',
      minStock: int.tryParse(json['min_stock'].toString()) ?? 0,
    );
  }
}