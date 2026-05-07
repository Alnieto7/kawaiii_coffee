class CartItem {

  int id;
  String name;
  int price;
  int qty;
  String image;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.qty = 1,
  });
}