import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/POS/carditem.dart';
import 'package:kawaiii_coffee/Provider/TransactionProvider.dart';
import 'package:kawaiii_coffee/Routes/Routes.dart';
// 🔻 PASTIKAN IMPORT INI AKTIF (Sesuaikan path filenya)
// import 'package:kawaiii_coffee/View/midtrans_webview.dart';
// import 'package:kawaiii_coffee/View/qris_display_page.dart';

class CartController extends GetxController {
  var items = <CartItem>[].obs;
  var paymentMethod = 'cash'.obs;
  var isOpen = false.obs;
  var isLoading = false.obs;

  final _transactionProvider = TransactionProvider();

  // ➕ TAMBAH PRODUK
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
    if (!isOpen.value) isOpen.value = true;
  }

  void _checkCart() {
    if (items.isEmpty) {
      Future.delayed(const Duration(milliseconds: 200), () {
        isOpen.value = false;
      });
    }
  }

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
    _checkCart();
  }

  int get total => items.fold(0, (sum, item) => sum + (item.price * item.qty));

  void clearCart() {
    items.clear();
    isOpen.value = false;
  }

  void changePayment(String method) {
    paymentMethod.value = method;
  }

  List<Map<String, dynamic>> _generateItemsPayload() {
    return items.map((e) => {'product_id': e.id, 'quantity': e.qty}).toList();
  }

  // ==========================================
  // METODE 1: CASH
  // ==========================================
  Future<void> checkout() async {
    if (items.isEmpty) return;
    try {
      isLoading.value = true;
      final response = await _transactionProvider.checkout(
        paymentMethod: paymentMethod.value,
        paidAmount: total,
        items: _generateItemsPayload(),
      );

      Get.snackbar('Sukses', response['message'] ?? 'Transaksi berhasil');
      clearCart();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memproses transaksi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================================
  // METODE 2: MIDTRANS SNAP (E-Wallet)
  // ==========================================
  Future<void> startMidtransPayment() async {
    if (items.isEmpty) return;
    try {
      isLoading.value = true;
      final response = await _transactionProvider.initiateSnap(
        items: _generateItemsPayload(),
      );

      if (response != null && response['snap_token'] != null) {
        String token = response['snap_token'];
        String redirectUrl =
            "https://app.sandbox.midtrans.com/snap/v2/vtweb/$token";

        // 🔻 PINDAH KE HALALMAN WEBVIEW
        // Get.to(() => MidtransWebViewPage(url: redirectUrl));

        print("Membuka Midtrans: $redirectUrl");
      } else {
        throw 'Token pembayaran tidak ditemukan';
      }
    } catch (e) {
      Get.snackbar('Midtrans Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================================
  // METODE 3: QRIS DYNAMIC
  // ==========================================
  Future<void> startQrisPayment() async {
    try {
      isLoading.value = true;
      final response = await _transactionProvider.initiateQris(
        items: _generateItemsPayload(),
      );

      // Pastikan 'qr_url' menggunakan huruf kecil semua
      if (response != null && response['qr_url'] != null) {
        Get.toNamed(
          AppRoutes.QrisDisplayPage,
          arguments: {'qr_url': response['qr_url'], 'total': total},
        );
      } else {
        Get.snackbar("Gagal", "QR URL tidak ditemukan dalam respon server");
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
