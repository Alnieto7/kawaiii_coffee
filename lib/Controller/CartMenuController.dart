import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/POS/carditem.dart';
import 'package:kawaiii_coffee/Provider/TransactionProvider.dart';

class CartController extends GetxController {
  var items = <CartItem>[].obs;
  var paymentMethod = 'cash'.obs;
  var isOpen = false.obs;
  var isLoading = false.obs;

  final _transactionProvider = TransactionProvider();

  // ── State Tambahan untuk Pembayaran Cash ───────────────────────────────
  var uangDibayar = 0.obs;
  var kembalian = 0.obs;
  final cashController = TextEditingController();

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

  void resetForNewTransaction() {
    items.clear();
    isOpen.value = false;
    paymentMethod.value = 'cash';
    isLoading.value = false;
  }

  void changePayment(String method) => paymentMethod.value = method;

  int get total => items.fold(0, (sum, item) => sum + (item.price * item.qty));

  List<Map<String, dynamic>> _buildItemsPayload() =>
      items.map((e) => {'product_id': e.id, 'quantity': e.qty}).toList();

  // ── Cash Checkout & Bottom Sheet ───────────────────────────────────────

  void hitungKembalian(String value) {
    // Bersihkan inputan dari titik/koma/Rp agar murni angka
    int inputCash = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    uangDibayar.value = inputCash;
    kembalian.value = inputCash - total;
  }

  void tampilkanInputCash() {
    if (items.isEmpty) {
      Get.snackbar('Info', 'Keranjang kosong');
      return;
    }

    // Reset nilai form tiap pop-up dibuka
    cashController.clear();
    uangDibayar.value = 0;
    kembalian.value = 0 - total;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pembayaran Tunai',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Info Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Tagihan:'),
                Text(
                  'Rp $total',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD97706),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Form Input Uang Pelanggan
            const Text(
              'Uang Diterima:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: cashController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                prefixText: 'Rp ',
                hintText: '0',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => hitungKembalian(value),
            ),
            const SizedBox(height: 16),

            // Tampilan Kembalian / Kekurangan
            Obx(() {
              bool isKurang = kembalian.value < 0;
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isKurang ? Colors.red[50] : Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isKurang ? 'Kekurangan:' : 'Kembalian:',
                      style: TextStyle(
                        color: isKurang ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rp ${kembalian.value.abs()}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isKurang ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 24),

            // Tombol Konfirmasi (Hanya aktif jika uang cukup)
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: (uangDibayar.value >= total && !isLoading.value)
                      ? () =>
                            checkout() // Lanjut tembak API
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD97706),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading.value
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          'Konfirmasi Pembayaran',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> checkout() async {
    try {
      isLoading.value = true;

      final response = await _transactionProvider.checkout(
        paymentMethod: paymentMethod.value,
        paidAmount: uangDibayar.value, // ✅ Menggunakan inputan uang pelanggan
        items: _buildItemsPayload(),
      );

      print('CHECKOUT RESPONSE = $response');

      // VALIDASI
      if (response['data'] == null) {
        throw Exception(
          response['message'] ?? 'Data transaksi tidak ditemukan',
        );
      }

      final int transactionId = response['data']['id'];
      print('TRANSACTION ID = $transactionId');

      // ✅ Tutup Pop-up Input Cash jika sedang terbuka
      if (Get.isBottomSheetOpen == true) {
        Get.back();
      }

      resetForNewTransaction();

      Get.offNamed('/receipt', arguments: transactionId);
    } catch (e) {
      print('CHECKOUT ERROR = $e');
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
      print('START QRIS');

      final response = await _transactionProvider.initiateQris(
        items: _buildItemsPayload(),
      );
      print(response);
      print('QRIS RESPONSE = $response');

      if (response['qr_url'] != null) {
        final int currentTotal = total;

        resetForNewTransaction();

        Get.toNamed(
          '/qrisDisplayPage',
          arguments: {
            'qr_url': response['qr_url'],
            'total': currentTotal,
            'transaction_code': response['transaction_code'],
          },
        );
      } else {
        print('QR URL NULL');
        throw Exception('QR URL tidak ditemukan');
      }
    } catch (e) {
      print('QRIS ERROR = $e');
      Get.snackbar('QRIS Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    cashController.dispose();
    super.onClose();
  }
}
