import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kawaiii_coffee/Provider/TransactionProvider.dart';
import 'package:kawaiii_coffee/snackbarhelper.dart';
import 'package:kawaiii_coffee/Controller/PrinterController.dart';
import 'package:kawaiii_coffee/services/printerservice.dart';

class TransactionDetailController extends GetxController {
  final TransactionProvider _provider = TransactionProvider();
  
  var isLoading = true.obs;
  var isPrinting = false.obs; // <-- state baru untuk loading di tombol Print
  var detailData = {}.obs;
  // Tambahkan 2 baris ini di dalam TransactionDetailController
  var isMobile = true.obs;
  void updateLayout(BoxConstraints constraints) => isMobile.value = constraints.maxWidth < 800;

  final _currencyFormatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      int id = Get.arguments as int; 
      fetchDetail(id);
    }
  }

  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  String formatRupiah(dynamic amount) {
    if (amount == null) return 'Rp 0';
    return _currencyFormatter.format(amount);
  }

  String get invoiceNumber => detailData['invoice_number'] ?? detailData['transaction_code'] ?? '-';
  
  String get transactionDate {
    final rawDate = detailData['created_at'];
    if (rawDate == null) return '-';
    try {
      final parsed = DateTime.parse(rawDate).toLocal();
      return DateFormat('dd MMM yyyy, HH:mm').format(parsed);
    } catch (e) {
      return rawDate; 
    }
  }

  String get cashierName => detailData['cashier_name'] ?? detailData['cashier']?['name'] ?? detailData['user']?['name'] ?? 'Kasir';
  
  String get paymentMethod => (detailData['payment_method'] ?? 'CASH').toString().toUpperCase();

  double get total => _parseDouble(detailData['total']);
  
  double get paidAmount => _parseDouble(detailData['paid_amount'] ?? detailData['total']);
  
  double get changeAmount => _parseDouble(detailData['change_amount'] ?? (paidAmount - total));

  String get formattedTotal => formatRupiah(total);
  String get formattedPaidAmount => formatRupiah(paidAmount);
  String get formattedChangeAmount => formatRupiah(changeAmount);

  List<dynamic> get items {
    if (detailData['items'] != null) return detailData['items'];
    if (detailData['transaction_details'] != null) return detailData['transaction_details'];
    if (detailData['details'] != null) return detailData['details'];
    return [];
  }

  String getItemName(dynamic item) => item['product_name'] ?? item['product']?['name'] ?? 'Produk';
  
  int getItemQty(dynamic item) => item['quantity'] ?? item['qty'] ?? 1;
  
  double getItemPrice(dynamic item) {
    double price = _parseDouble(item['price'] ?? item['unit_price']);
  
    if (price == 0.0) {
      double subtotal = _parseDouble(item['subtotal']);
      int qty = getItemQty(item);
      
      if (qty > 0 && subtotal > 0) {
        return subtotal / qty;
      }
    }
    
    return price;
  }
  
  double getItemSubtotal(dynamic item) => _parseDouble(item['subtotal'] ?? (getItemPrice(item) * getItemQty(item)));

  String formattedItemPrice(dynamic item) => formatRupiah(getItemPrice(item));
  String formattedItemSubtotal(dynamic item) => formatRupiah(getItemSubtotal(item));

  void fetchDetail(int id) async {
    isLoading.value = true;
    try {
      final data = await _provider.getTransactionDetail(id);
      detailData.value = data;
    } catch (e) {
      SnackbarHelper.error('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // PRINT STRUK (manual, dari halaman History)
  // =========================

  /// Dipanggil dari tombol "Print Nota" di TransactionDetailPage.
  /// Semua logic generate ESC/POS ada di PrinterService (satu sumber),
  /// di sini cuma nyiapin data & handle UI feedback.
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
            qtyPriceLabel: '${getItemQty(item)} x ${formattedItemPrice(item)}',
            subtotalLabel: formattedItemSubtotal(item),
          );
        }).toList(),
        totalFormatted: formattedTotal,
        paidFormatted: formattedPaidAmount,
        changeFormatted: formattedChangeAmount,
      );

      SnackbarHelper.success('Berhasil', 'Struk berhasil dicetak ulang');
    } catch (e) {
      SnackbarHelper.error('Gagal', 'Gagal mencetak struk: $e');
    } finally {
      isPrinting.value = false;
    }
  }
}