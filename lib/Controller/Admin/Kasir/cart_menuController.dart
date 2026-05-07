import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/POS/carditem.dart';

class CartController extends GetxController {
  var items = <CartItem>[].obs;
  var paymentMethod = "cash".obs;
  var isOpen = false.obs;

  // ➕ tambah produk
void addItem(String name, int price) {
  final index = items.indexWhere((e) => e.name == name);

  if (index >= 0) {
    items[index].qty++;
    items.refresh();
  } else {
    items.add(CartItem(name: name, price: price));
  }

  // 🔥 munculin cart pertama kali
  if (!isOpen.value) {
    isOpen.value = true;
  }
}
  void _checkCart() {
  if (items.isEmpty) {
    Future.delayed(const Duration(milliseconds: 200), () {
      isOpen.value = false;
    });
  }
}
  // ➕➖ qty
  void increase(int index) {
    items[index].qty++;
    items.refresh();
  }

  void decrease(int index) {
  if (items[index].qty > 1) {
    items[index].qty--;
  } else {
    items.removeAt(index);
  }

  items.refresh();
  _checkCart(); // 🔥 auto close kalau kosong
}

  // 💰 total
  int get total =>
      items.fold(0, (sum, item) => sum + (item.price * item.qty));

  // 🗑️ clear
  void clearCart() {
  items.clear();
  isOpen.value = false; // 🔥 langsung close
}

  void changePayment(String method) {
    paymentMethod.value = method;
  }
}