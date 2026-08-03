class CartItem {
  final int id;
  final String name;
  final int price;
  final String image;
  int qty;
  final int stock; // 🔥 1. TAMBAHKAN BARIS INI

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.qty = 1,
    required this.stock, // 🔥 2. TAMBAHKAN BARIS INI JUGA
  });
}
