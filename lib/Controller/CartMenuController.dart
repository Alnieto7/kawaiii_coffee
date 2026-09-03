import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kawaiii_coffee/Component/CartSheet/cashpaymentsheet.dart';
import 'package:kawaiii_coffee/Component/CartSheet/Cartitem.dart';
import 'package:kawaiii_coffee/Controller/PointOfSaleController.dart';
import 'package:kawaiii_coffee/Provider/TransactionProvider.dart';
import 'package:kawaiii_coffee/services/printerservice.dart';
import 'package:kawaiii_coffee/snackbarhelper.dart';

class CartController extends GetxController {
  var items = <CartItem>[].obs;
  var paymentMethod = 'cash'.obs;
  var isOpen = false.obs;
  var isLoading = false.obs;

  final _transactionProvider = TransactionProvider();
  final _printerService = PrinterService();

  final _currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  var uangDibayar = 0.obs;
  var kembalian = 0.obs;
  final cashController = TextEditingController();

  bool addItem({
    required int id,
    required String name,
    required int price,
    required String image,
    required int stock,
  }) {
    final index = items.indexWhere((e) => e.id == id);
    final posController = Get.isRegistered<PosController>()
        ? Get.find<PosController>()
        : null;

    // Hitung SISA stok secara real-time
    final int remainingStock = posController != null
        ? posController.calculateMaxPortions(id)
        : stock;

    if (index >= 0) {
      if (remainingStock > 0) {
        items[index].qty++;
        items.refresh();
        return true;
      } else {
        SnackbarHelper.error(
          'Stok Terbatas',
          'Bahan baku untuk $name sudah mentok.',
        );
        return false;
      }
    } else {
      if (remainingStock > 0) {
        items.add(
          CartItem(
            id: id,
            name: name,
            price: price,
            image: image,
            stock:
                999, // Parameter ini tidak dipakai lagi karena kita cek real-time
          ),
        );
        return true;
      } else {
        SnackbarHelper.error(
          'Stok Habis',
          'Maaf, bahan baku $name tidak mencukupi.',
        );
        return false;
      }
    }
  }

  void increase(int index) {
    final item = items[index];
    final posController = Get.isRegistered<PosController>()
        ? Get.find<PosController>()
        : null;

    final int remainingStock = posController != null
        ? posController.calculateMaxPortions(item.id)
        : 1;

    // Jika masih ada sisa porsi yang bisa dibuat, izinkan tambah
    if (remainingStock > 0) {
      item.qty++;
      items.refresh();
    } else {
      SnackbarHelper.error(
        'Stok Terbatas',
        'Bahan baku untuk ${item.name} sudah habis terpakai di keranjang.',
      );
    }
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

  // 🔥 UPDATE: Fungsi ini sekarang akan memanggil fetchProducts() untuk menyegarkan data stok
  void resetForNewTransaction() {
    items.clear();
    isOpen.value = false;
    paymentMethod.value = 'cash';
    isLoading.value = false;

    // Tarik data stok terbaru dari database otomatis setelah transaksi selesai!
    if (Get.isRegistered<PosController>()) {
      Get.find<PosController>().fetchProducts();
    }
  }

  void changePayment(String method) => paymentMethod.value = method;

  int get total => items.fold(0, (sum, item) => sum + (item.price * item.qty));

  List<Map<String, dynamic>> _buildItemsPayload() =>
      items.map((e) => {'product_id': e.id, 'quantity': e.qty}).toList();

  void hitungKembalian(String value) {
    int inputCash = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    uangDibayar.value = inputCash;
    kembalian.value = inputCash - total;
  }

  void tampilkanInputCash() {
    if (items.isEmpty) {
      SnackbarHelper.info('Info', 'Keranjang kosong');
      return;
    }
    cashController.clear();
    uangDibayar.value = 0;
    kembalian.value = 0 - total;

    Get.bottomSheet(
      CashPaymentSheet(controller: this),
      isScrollControlled: true,
    );
  }

  Future<void> checkout() async {
    try {
      isLoading.value = true;
      final response = await _transactionProvider.checkout(
        paymentMethod: paymentMethod.value,
        paidAmount: uangDibayar.value,
        items: _buildItemsPayload(),
      );

      if (response['data'] == null) {
        throw Exception(
          response['message'] ?? 'Data transaksi tidak ditemukan',
        );
      }

      final data = response['data'];
      final int transactionId = data['id'];

      final printItems = List<CartItem>.from(items);
      final printTotal = total;
      final printPayment = paymentMethod.value;
      final printPaidAmount = uangDibayar.value;
      final printChangeAmount = kembalian.value;

      Map<String, dynamic> detailData = {};
      try {
        detailData = await _transactionProvider.getTransactionDetail(
          transactionId,
        );
      } catch (fetchError) {
        print('FETCH DETAIL FOR PRINT ERROR = $fetchError');
      }

      final printInvoiceNumber =
          detailData['invoice_number'] ??
          detailData['transaction_code'] ??
          'TRX-$transactionId';
      final printCashierName =
          detailData['cashier_name'] ??
          detailData['cashier']?['name'] ??
          detailData['user']?['name'] ??
          'Kasir';
      final printTransactionDate =
          detailData['transaction_date'] ?? detailData['created_at'];

      try {
        await _printerService.printReceipt(
          invoiceNumber: printInvoiceNumber,
          transactionDate: printTransactionDate != null
              ? DateFormat(
                  'dd MMM yyyy, HH:mm',
                ).format(DateTime.parse(printTransactionDate).toLocal())
              : DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()),
          cashierName: printCashierName,
          paymentMethod: printPayment.toUpperCase(),
          items: printItems.map((item) {
            return ReceiptLineItem(
              name: item.name,
              qtyPriceLabel:
                  '${item.qty} x ${_currencyFormatter.format(item.price)}',
              subtotalLabel: _currencyFormatter.format(item.price * item.qty),
            );
          }).toList(),
          totalFormatted: _currencyFormatter.format(printTotal),
          paidFormatted: _currencyFormatter.format(printPaidAmount),
          changeFormatted: _currencyFormatter.format(printChangeAmount),
        );
      } catch (printError) {
        SnackbarHelper.info(
          'Struk belum tercetak',
          'Transaksi berhasil, tapi gagal cetak otomatis: $printError',
        );
      }

      if (Get.isBottomSheetOpen == true) {
        Get.back();
      }

      resetForNewTransaction();
      Get.offNamed('/receipt', arguments: transactionId);
    } catch (e) {
      SnackbarHelper.error(
        'Transaksi Gagal',
        e.toString().replaceAll('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startMidtransPayment() async {
    if (items.isEmpty) {
      SnackbarHelper.info('Info', 'Keranjang kosong');
      return;
    }
    try {
      isLoading.value = true;
      final response = await _transactionProvider.initiateSnap(
        items: _buildItemsPayload(),
      );
      if (response['snap_token'] == null) {
        throw Exception('Snap token tidak ditemukan');
      }
    } catch (e) {
      SnackbarHelper.error('Midtrans Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startQrisPayment() async {
    if (items.isEmpty) {
      SnackbarHelper.info('Info', 'Keranjang kosong');
      return;
    }
    try {
      isLoading.value = true;
      final response = await _transactionProvider.initiateQris(
        items: _buildItemsPayload(),
      );
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
        throw Exception('QR URL tidak ditemukan');
      }
    } catch (e) {
      SnackbarHelper.error('QRIS Error', e.toString());
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
