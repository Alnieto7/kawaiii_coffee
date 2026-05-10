class ProductModel {
  final int id;
  final String name;
  final String categoryName;
  final int sellingPrice;
  final int costPrice;
  final int profit;
  final String image;

  ProductModel({
    required this.id,
    required this.name,
    required this.categoryName,
    required this.sellingPrice,
    required this.costPrice,
    required this.profit,
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"] is int ? json["id"] : int.parse(json["id"].toString()),
      name: json["name"] ?? "",
      categoryName: json["category_name"] ?? "",
      // Trik aman: Ubah ke num dulu baru ke int untuk menangani double/int
      sellingPrice: (json["selling_price"] as num? ?? 0).toInt(),
      costPrice: (json["cost_price"] as num? ?? 0).toInt(),
      profit: (json["profit"] as num? ?? 0).toInt(),
      image: json["image"] ?? "",
    );
  }
}
