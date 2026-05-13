import 'dart:ui';

import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/POS/carditem.dart';
import 'package:kawaiii_coffee/Provider/TransactionProvider.dart';

class CartController extends GetxController {
  var items = <CartItem>[].obs;
  var paymentMethod = 'cash'.obs;
  var isOpen = false.obs;
  var isLoading = false.obs;

  final _transactionProvider = TransactionProvider();

  // ── Cart Operations ────────────────────────────────────────────────────

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
    // Sheet TIDAK dibuka otomatis — user buka lewat FAB
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
    _checkIfEmpty();
  }

  void _checkIfEmpty() {
    if (items.isEmpty) {
      Future.delayed(
        const Duration(milliseconds: 200),
        () => isOpen.value = false,
      );
    }
  }

  void clearCart() {
    items.clear();
    isOpen.value = false;
  }

  void changePayment(String method) => paymentMethod.value = method;

  int get total => items.fold(0, (sum, item) => sum + (item.price * item.qty));

  List<Map<String, dynamic>> _buildItemsPayload() =>
      items.map((e) => {'product_id': e.id, 'quantity': e.qty}).toList();

  // ── Cash Checkout ──────────────────────────────────────────────────────

  Future<void> checkout() async {
    if (items.isEmpty) {
      Get.snackbar('Info', 'Keranjang kosong');
      return;
    }
    try {
      isLoading.value = true;
      final response = await _transactionProvider.checkout(
        paymentMethod: paymentMethod.value,
        paidAmount: total,
        items: _buildItemsPayload(),
      );
      clearCart();
      Get.snackbar(
        'Sukses 🎉',
        response['message'] ?? 'Transaksi berhasil',
        backgroundColor: const Color(0xFFD97706),
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 3),
      );
      Get.offAllNamed('/main');
    } catch (e) {
      Get.snackbar('Transaksi Gagal', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ── Midtrans Snap (E-Wallet) ───────────────────────────────────────────

  Future<void> startMidtransPayment() async {
    if (items.isEmpty) {
      Get.snackbar('Info', 'Keranjang kosong');
      return;
    }
    try {
      isLoading.value = true;
      final response = await _transactionProvider.initiateSnap(
        items: _buildItemsPayload(),
      );
      if (response['snap_token'] != null) {
        final redirectUrl =
            'https://app.sandbox.midtrans.com/snap/v2/vtweb/${response['snap_token']}';
        // TODO: Navigasi ke MidtransWebViewPage
        // Get.to(() => MidtransWebViewPage(url: redirectUrl));
      } else {
        throw Exception('Snap token tidak ditemukan');
      }
    } catch (e) {
      Get.snackbar('Midtrans Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ── QRIS Dynamic ──────────────────────────────────────────────────────

  Future<void> startQrisPayment() async {
    if (items.isEmpty) {
      Get.snackbar('Info', 'Keranjang kosong');
      return;
    }
    try {
      isLoading.value = true;
      final response = await _transactionProvider.initiateQris(
        items: _buildItemsPayload(),
      );
      if (response['qr_url'] != null) {
        final int currentTotal = total;
        clearCart();
        Get.toNamed(
          '/qrisDisplayPage',
          arguments: {
            'qr_url': response['qr_url'],
            'total': currentTotal,
            'transaction_code': response['transaction_code'],
          },
        );
      } else {
        throw Exception('QR URL tidak ditemukan');
      }
    } catch (e) {
      Get.snackbar('QRIS Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
