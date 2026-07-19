import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kawaiii_coffee/Component/CartSheet/cashpaymentsheet.dart';
import 'package:kawaiii_coffee/Component/POS/carditem.dart';
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

  void changePayment(String method) =>
      paymentMethod.value = method;

  int get total => items.fold(
        0,
        (sum, item) => sum + (item.price * item.qty),
      );

  List<Map<String, dynamic>> _buildItemsPayload() =>
      items
          .map(
            (e) => {
              'product_id': e.id,
              'quantity': e.qty,
            },
          )
          .toList();

  // ── Cash Checkout ───────────────────────────────────────

  void hitungKembalian(String value) {
    int inputCash = int.tryParse(
          value.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;

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

      final response =
          await _transactionProvider.checkout(
        paymentMethod: paymentMethod.value,
        paidAmount: uangDibayar.value,
        items: _buildItemsPayload(),
      );

      print('CHECKOUT RESPONSE = $response');

      if (response['data'] == null) {
        throw Exception(
          response['message'] ??
              'Data transaksi tidak ditemukan',
        );
      }

        final data = response['data'];
        final int transactionId = data['id'];

        print('TRANSACTION ID = $transactionId');


        // Simpan data untuk print sebelum cart dikosongkan
        final printItems = List<CartItem>.from(items);
        final printTotal = total;
        final printPayment = paymentMethod.value;
        final printPaidAmount = uangDibayar.value;
        final printChangeAmount = kembalian.value;


        // Ambil detail transaksi lengkap (endpoint yang sama dipakai ReceiptPage),
        // supaya cashier_name & data lain konsisten dengan yang tampil di struk digital.
        Map<String, dynamic> detailData = {};
        try {
          detailData = await _transactionProvider.getTransactionDetail(transactionId);
        } catch (fetchError) {
          print('FETCH DETAIL FOR PRINT ERROR = $fetchError');
          // Kalau gagal fetch detail, tetap lanjut print pakai fallback di bawah.
        }

        final printInvoiceNumber = detailData['invoice_number'] ??
            detailData['transaction_code'] ??
            'TRX-$transactionId';
        final printCashierName = detailData['cashier_name'] ??
            detailData['cashier']?['name'] ??
            detailData['user']?['name'] ??
            'Kasir';
        final printTransactionDate = detailData['transaction_date'] ??
            detailData['created_at'];


        // Cetak struk (satu sumber format: PrinterService)
        try {
          await _printerService.printReceipt(
            invoiceNumber: printInvoiceNumber,
            transactionDate: printTransactionDate != null
                ? DateFormat('dd MMM yyyy, HH:mm')
                    .format(DateTime.parse(printTransactionDate).toLocal())
                : DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()),
            cashierName: printCashierName,
            paymentMethod: printPayment.toUpperCase(),
            items: printItems.map((item) {
              return ReceiptLineItem(
                name: item.name,
                qtyPriceLabel:
                    '${item.qty} x ${_currencyFormatter.format(item.price)}',
                subtotalLabel: _currencyFormatter
                    .format(item.price * item.qty),
              );
            }).toList(),
            totalFormatted:
                _currencyFormatter.format(printTotal),
            paidFormatted:
                _currencyFormatter.format(printPaidAmount),
            changeFormatted:
                _currencyFormatter.format(printChangeAmount),
          );
        } catch (printError) {
          // Checkout tetap dianggap berhasil walau print gagal
          // (misal printer belum connect) — jangan blok alur transaksi.
          print('AUTO-PRINT ERROR = $printError');
          SnackbarHelper.info(
            'Struk belum tercetak',
            'Transaksi berhasil, tapi gagal cetak otomatis: $printError',
          );
        }


        if (Get.isBottomSheetOpen == true) {
          Get.back();
        }


        resetForNewTransaction();


        Get.offNamed(
          '/receipt',
          arguments: transactionId,
        );
    } catch (e) {
      print('CHECKOUT ERROR = $e');

      SnackbarHelper.error(
        'Transaksi Gagal',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ── Midtrans Snap ───────────────────────────────────────────

  Future<void> startMidtransPayment() async {
    if (items.isEmpty) {
      SnackbarHelper.info('Info', 'Keranjang kosong');
      return;
    }

    try {
      isLoading.value = true;

      final response =
          await _transactionProvider.initiateSnap(
        items: _buildItemsPayload(),
      );

      if (response['snap_token'] != null) {
        final redirectUrl =
            'https://app.sandbox.midtrans.com/snap/v2/vtweb/${response['snap_token']}';

        // TODO: Navigasi ke MidtransWebViewPage
      } else {
        throw Exception(
          'Snap token tidak ditemukan',
        );
      }
    } catch (e) {
      SnackbarHelper.error(
        'Midtrans Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ── QRIS Dynamic ──────────────────────────────────────

  Future<void> startQrisPayment() async {
    if (items.isEmpty) {
      SnackbarHelper.info('Info', 'Keranjang kosong');
      return;
    }

    try {
      isLoading.value = true;

      print('START QRIS');

      final response =
          await _transactionProvider.initiateQris(
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
            'transaction_code':
                response['transaction_code'],
          },
        );
      } else {
        print('QR URL NULL');

        throw Exception(
          'QR URL tidak ditemukan',
        );
      }
    } catch (e) {
      print('QRIS ERROR = $e');

      SnackbarHelper.error(
        'QRIS Error',
        e.toString(),
      );
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