import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/POS/carditem.dart';
import 'package:kawaiii_coffee/Provider/TransactionProvider.dart';
import 'package:kawaiii_coffee/Routes/Routes.dart';

// 🔥 Uncomment kalau file udah ada
// import 'package:kawaiii_coffee/View/midtrans_webview.dart';

class CartController extends GetxController {

  // 🛒 CART ITEMS
  var items = <CartItem>[].obs;

  // 💳 PAYMENT METHOD
  var paymentMethod = 'cash'.obs;

  // 🔥 PANEL STATE
  var isOpen = false.obs;

  // ⏳ LOADING
  var isLoading = false.obs;

  final _transactionProvider =
      TransactionProvider();

  // ==========================================
  // ➕ ADD ITEM
  // ==========================================
  void addItem({

    required int id,

    required String name,

    required int price,

    required String image,
  }) {

    final index =
        items.indexWhere(
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

    if (!isOpen.value) {

      isOpen.value = true;
    }
  }

  // ==========================================
  // ➕ INCREASE QTY
  // ==========================================
  void increase(int index) {

    items[index].qty++;

    items.refresh();
  }

  // ==========================================
  // ➖ DECREASE QTY
  // ==========================================
  void decrease(int index) {

    if (items[index].qty > 1) {

      items[index].qty--;

    } else {

      items.removeAt(index);
    }

    items.refresh();

    _checkCart();
  }

  // ==========================================
  // 🔥 AUTO CLOSE CART
  // ==========================================
  void _checkCart() {

    if (items.isEmpty) {

      Future.delayed(

        const Duration(
          milliseconds: 200,
        ),

        () {

          isOpen.value = false;
        },
      );
    }
  }

  // ==========================================
  // 💰 TOTAL
  // ==========================================
  int get total {

    return items.fold(

      0,

      (sum, item) =>
          sum +
          (item.price * item.qty),
    );
  }

  // ==========================================
  // 🗑 CLEAR CART
  // ==========================================
  void clearCart() {

    items.clear();

    isOpen.value = false;
  }

  // ==========================================
  // 💳 CHANGE PAYMENT METHOD
  // ==========================================
  void changePayment(
    String method,
  ) {

    paymentMethod.value = method;
  }

  // ==========================================
  // 📦 ITEMS PAYLOAD
  // ==========================================
  List<Map<String, dynamic>>
      _generateItemsPayload() {

    return items.map((e) {

      return {

        "product_id": e.id,

        "quantity": e.qty,
      };

    }).toList();
  }

  // ==========================================
  // 💵 CASH CHECKOUT
  // ==========================================
  Future<void> checkout() async {

    if (items.isEmpty) {

      Get.snackbar(
        "Info",
        "Keranjang kosong",
      );

      return;
    }

    try {

      isLoading.value = true;

      final response =
          await _transactionProvider
              .checkout(

        paymentMethod:
            paymentMethod.value,

        paidAmount:
            total,

        items:
            _generateItemsPayload(),
      );

      Get.snackbar(

        "Sukses",

        response['message'] ??
            "Transaksi berhasil",
      );

      clearCart();

      Get.offAllNamed('/main');

    } catch (e) {

      print(e);

      Get.snackbar(
        "Error",
        e.toString(),
      );

    } finally {

      isLoading.value = false;
    }
  }

  // ==========================================
  // 💳 MIDTRANS SNAP
  // ==========================================
  Future<void>
      startMidtransPayment() async {

    if (items.isEmpty) {

      Get.snackbar(
        "Info",
        "Keranjang kosong",
      );

      return;
    }

    try {

      isLoading.value = true;

      final response =
          await _transactionProvider
              .initiateSnap(

        items:
            _generateItemsPayload(),
      );

      if (response != null &&
          response['snap_token'] != null) {

        final token =
            response['snap_token'];

        final redirectUrl =
            "https://app.sandbox.midtrans.com/snap/v2/vtweb/$token";

        print(
          "MIDTRANS URL: $redirectUrl",
        );

        // 🔥 Uncomment kalau page webview udah ada
        // Get.to(
        //   () => MidtransWebViewPage(
        //     url: redirectUrl,
        //   ),
        // );

      } else {

        throw Exception(
          "Snap token tidak ditemukan",
        );
      }

    } catch (e) {

      print(e);

      Get.snackbar(
        "Midtrans Error",
        e.toString(),
      );

    } finally {

      isLoading.value = false;
    }
  }

  // ==========================================
  // 🔳 QRIS PAYMENT
  // ==========================================
  Future<void>
      startQrisPayment() async {

    if (items.isEmpty) {

      Get.snackbar(
        "Info",
        "Keranjang kosong",
      );

      return;
    }

    try {

      isLoading.value = true;

      final response =
          await _transactionProvider
              .initiateQris(

        items:
            _generateItemsPayload(),
      );

      print(response);

      if (response != null &&
          response['qr_url'] != null) {

        Get.toNamed(

          AppRoutes.QrisDisplayPage,

          arguments: {

            'qr_url':
                response['qr_url'],

            'total':
                total,
          },
        );

      } else {

        throw Exception(
          "QR URL tidak ditemukan",
        );
      }

    } catch (e) {

      print(e);

      Get.snackbar(
        "QRIS Error",
        e.toString(),
      );

    } finally {

      isLoading.value = false;
    }
  }
}