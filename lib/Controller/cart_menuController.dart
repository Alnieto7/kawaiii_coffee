import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/POS/carditem.dart';
import 'package:kawaiii_coffee/services/transaction_service.dart';
import 'package:get_storage/get_storage.dart';

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
    final index = items.indexWhere((e) => e.id == id);

    if (index >= 0) {
      items[index].qty++;
      items.refresh();
    } else {
      items.add(CartItem(id: id, name: name, price: price, image: image));
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
  int get total => items.fold(0, (sum, item) => sum + (item.price * item.qty));

  // 🗑️ clear
  void clearCart() {
    items.clear();
    isOpen.value = false; // 🔥 langsung close
  }

  void changePayment(String method) {
    paymentMethod.value = method;
  }

  Future<void> checkout() async {
    final box = GetStorage();
  try {

    // 🔥 token login
    final token = box.read('auth_token');

    // 🔥 payload items
    final itemsPayload = items.map((e) {

      return {
        "product_id": e.id,
        "quantity": e.qty,
      };

    }).toList();

    final response = await TransactionService.checkout(

      token: token,

      paymentMethod: paymentMethod.value,

      paidAmount: total,

      items: itemsPayload,
    );

    // ✅ SUCCESS
    Get.snackbar(
      "Sukses",
      response["message"],
    );

    // 🔥 kosongin cart
    clearCart();

  } catch (e) {

    Get.snackbar(
      "Error",
      e.toString(),
    );
  }
}

}
