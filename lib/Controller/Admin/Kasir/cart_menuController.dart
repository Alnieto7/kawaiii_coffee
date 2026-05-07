import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/POS/carditem.dart';

class CartController extends GetxController {

  var items = <CartItem>[].obs;

  var paymentMethod = "cash".obs;

  var isOpen = false.obs;

  // ➕ tambah produk
  void addItem({
    required int id,
    required String name,
    required int price,
    required String image,
  }) {

    final index = items.indexWhere(
      (e) => e.id == id,
    );

    if (index >= 0) {

      items[index].qty++;

      items.refresh();

    } else {

      items.add(
        CartItem(
          id: id,
          name: name,
          price: price,
          image: image,
        ),
      );
    }

    // 🔥 munculin cart pertama kali
    if (!isOpen.value) {
      isOpen.value = true;
    }
  }

  // 🔥 auto close kalau kosong
  void _checkCart() {

    if (items.isEmpty) {

      Future.delayed(
        const Duration(milliseconds: 200),
        () {
          isOpen.value = false;
        },
      );
    }
  }

  // ➕ qty
  void increase(int index) {

    items[index].qty++;

    items.refresh();
  }

  // ➖ qty
  void decrease(int index) {

    if (items[index].qty > 1) {

      items[index].qty--;

    } else {

      items.removeAt(index);
    }

    items.refresh();

    _checkCart();
  }

  // 💰 total
  int get total =>
      items.fold(
        0,
        (sum, item) => sum + (item.price * item.qty),
      );

  // 🗑️ clear cart
  void clearCart() {

    items.clear();

    isOpen.value = false;
  }

  // 💳 payment
  void changePayment(String method) {

    paymentMethod.value = method;
  }
}