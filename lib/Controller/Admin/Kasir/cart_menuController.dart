import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kawaiii_coffee/Component/POS/carditem.dart';

class CartController extends GetxController {

  final box = GetStorage();

  // 🛒 LIST ITEM
  var items = <CartItem>[].obs;

  // 💳 PAYMENT
  var paymentMethod = "cash".obs;

  // 🔥 LOADING CHECKOUT
  var isCheckoutLoading = false.obs;

  // ➕ TAMBAH PRODUK
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
  }

  // ➕ TAMBAH QTY
  void increase(int index) {

    items[index].qty++;

    items.refresh();
  }

  // ➖ KURANG QTY
  void decrease(int index) {

    if (items[index].qty > 1) {

      items[index].qty--;

    } else {

      items.removeAt(index);
    }

    items.refresh();
  }

  // 💰 TOTAL
  int get total {

    return items.fold(
      0,
      (sum, item) =>
          sum + (item.price * item.qty),
    );
  }

  // 🗑 CLEAR CART
  void clearCart() {

    items.clear();
  }

  // 💳 GANTI PAYMENT
  void changePayment(String method) {

    paymentMethod.value = method;
  }

  // ✅ CHECKOUT
  Future<void> checkout() async {

    try {

      isCheckoutLoading.value = true;

      final token =
          box.read("auth_token");

      if (token == null) {

        Get.snackbar(
          "Error",
          "Silakan login ulang",
        );

        return;
      }

      // 📦 PAYLOAD ITEM
      final itemsPayload =
          items.map((e) {

        return {

          "product_id": e.id,

          "quantity": e.qty,
        };

      }).toList();

      final response =
          await http.post(

        Uri.parse(
          "http://202.10.48.252/api/transactions",
        ),

        headers: {

          "Authorization":
              "Bearer $token",

          "Accept":
              "application/json",

          "Content-Type":
              "application/json",
        },

        body: jsonEncode({

          "payment_method":
              paymentMethod.value,

          "paid_amount":
              total,

          "items":
              itemsPayload,
        }),
      );

      final json =
          jsonDecode(response.body);

      print(response.statusCode);
      print(response.body);

      // ✅ SUCCESS
      if (response.statusCode == 200 ||
          response.statusCode == 201) {

        Get.snackbar(
          "Sukses",
          "Transaksi berhasil",
        );

        clearCart();

        Get.back();

      } else {

        Get.snackbar(
          "Error",
          json["message"]
              .toString(),
        );
      }

    } catch (e) {

      Get.snackbar(
        "Error",
        e.toString(),
      );

    } finally {

      isCheckoutLoading.value = false;
    }
  }
}