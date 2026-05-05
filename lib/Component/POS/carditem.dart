class CartItem {
  String name;
  int price;
  int qty;

  CartItem({
    required this.name,
    required this.price,
    this.qty = 1,
  });
}