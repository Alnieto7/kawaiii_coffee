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
      id: json["id"],
      name: json["name"] ?? "",
      categoryName: json["category_name"] ?? "",
      sellingPrice: json["selling_price"] ?? 0,
      costPrice: json["cost_price"] ?? 0,
      profit: json["profit"] ?? 0,
      image: json["image"] ?? "",
    );
  }
}