import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kawaiii_coffee/Provider/TransactionProvider.dart';
import 'package:kawaiii_coffee/snackbarhelper.dart';
import 'package:kawaiii_coffee/Controller/PrinterController.dart';
import 'package:kawaiii_coffee/services/printerservice.dart';

class ReceiptController extends GetxController {
  final TransactionProvider _provider = TransactionProvider();

  var isLoading = true.obs;
  var isPrinting = false.obs; // <-- state baru untuk loading di tombol Print
  var detailData = <String, dynamic>{}.obs;

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      fetchReceipt(Get.arguments as int);
    }
  }

  // =========================
  // FETCH RECEIPT
  // =========================
  Future<void> fetchReceipt(int id) async {
    isLoading.value = true;

    try {
      final result = await _provider.getTransactionDetail(id);

      detailData.value = result;
    } catch (e) {
     SnackbarHelper.error(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // PARSE DOUBLE SAFE
  // =========================
  double _parseDouble(dynamic value) {
    if (value == null) return 0;

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? 0;
  }

  // =========================
  // TRANSACTION INFO
  // =========================
  String get invoiceNumber =>
      detailData['invoice_number'] ??
      detailData['transaction_code'] ??
      '-';

String get cashierName =>
    detailData['cashier_name'] ??
    detailData['cashier']?['name'] ??
    detailData['user']?['name'] ??
    'Kasir';

  String get paymentMethod =>
      (detailData['payment_method'] ?? 'CASH')
          .toString()
          .toUpperCase();

  String get transactionDate {
    final rawDate =
    detailData['transaction_date'] ??
    detailData['created_at'];

    if (rawDate == null) return '-';

    try {
      final parsed = DateTime.parse(rawDate).toLocal();

      return DateFormat(
        'dd MMM yyyy, HH:mm',
      ).format(parsed);
    } catch (e) {
      return rawDate;
    }
  }

  // =========================
  // PAYMENT INFO
  // =========================
  double get total =>
      _parseDouble(detailData['total']);

  double get paidAmount =>
      _parseDouble(
        detailData['paid_amount'] ??
        detailData['total'],
      );

  double get changeAmount =>
      _parseDouble(
        detailData['change_amount'] ??
        (paidAmount - total),
      );

  // =========================
  // ITEMS
  // =========================
  List<dynamic> get items {
    if (detailData['items'] != null) {
      return detailData['items'];
    }

    if (detailData['transaction_details'] != null) {
      return detailData['transaction_details'];
    }

    if (detailData['details'] != null) {
      return detailData['details'];
    }

    return [];
  }

  // =========================
  // ITEM HELPERS
  // =========================
  String getItemName(dynamic item) =>
      item['product_name'] ??
      item['product']?['name'] ??
      'Produk';

  int getItemQty(dynamic item) =>
      item['quantity'] ??
      item['qty'] ??
      1;

double getItemPrice(dynamic item) =>
    _parseDouble(
      item['price'] ??
      item['unit_price'],
    );

  double getItemSubtotal(dynamic item) =>
      _parseDouble(
        item['subtotal'] ??
        (getItemPrice(item) * getItemQty(item)),
      );

  // =========================
  // PRINT STRUK
  // =========================

  /// Dipanggil dari tombol Print di ReceiptPage.
  /// Semua logic generate ESC/POS ada di PrinterService (satu sumber),
  /// di sini cuma nyiapin data & handle UI feedback (snackbar, loading, redirect).
  Future<void> printStruk() async {
    if (isPrinting.value) return; // cegah double-tap

    final printerController = Get.put(PrinterController());
    final connected = await printerController.checkConnection();

    if (!connected) {
      SnackbarHelper.info(
        'Printer belum terhubung',
        'Silakan hubungkan printer terlebih dahulu',
      );
      Get.toNamed('/printer-settings'); // sesuaikan dengan nama route kamu
      return;
    }

    isPrinting.value = true;

    try {
      await PrinterService().printReceipt(
        invoiceNumber: invoiceNumber,
        transactionDate: transactionDate,
        cashierName: cashierName,
        paymentMethod: paymentMethod,
        items: items.map((item) {
          return ReceiptLineItem(
            name: getItemName(item),
            qtyPriceLabel: '${getItemQty(item)} x ${currencyFormatter.format(getItemPrice(item))}',
            subtotalLabel: currencyFormatter.format(getItemSubtotal(item)),
          );
        }).toList(),
        totalFormatted: currencyFormatter.format(total),
        paidFormatted: currencyFormatter.format(paidAmount),
        changeFormatted: currencyFormatter.format(changeAmount),
      );

      SnackbarHelper.success('Berhasil', 'Struk berhasil dicetak');
    } catch (e) {
      SnackbarHelper.error('Gagal', 'Gagal mencetak struk: $e');
    } finally {
      isPrinting.value = false;
    }
  }
}