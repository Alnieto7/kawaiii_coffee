import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kawaiii_coffee/Provider/TransactionProvider.dart';
import 'package:kawaiii_coffee/Provider/SalesSummaryProvider.dart';
import 'package:kawaiii_coffee/Model/TransactionsModel.dart';

class DashboardKasirController extends GetxController {
  var isActive = true.obs;
  var duration = '04:25:12'.obs;
  var totalHariIni = 'Rp 0'.obs;
  var isLoading = true.obs;

  var stocks = [
    {'name': 'Biji Kopi', 'value': '12.5 kg', 'status': 'AMAN'},
    {'name': 'Susu UHT', 'value': '4.2 L', 'status': 'RENDAH'},
  ].obs;

  var transactions = <Map<String, dynamic>>[].obs;

  final TransactionProvider _transactionProvider = TransactionProvider();
  final SalesSummaryProvider _summaryProvider = SalesSummaryProvider();

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  // =========================
  // Logika UI
  // =========================
  String get shiftStatusText => isActive.value ? 'AKTIF' : 'NONAKTIF';
  Color get shiftStatusColor => isActive.value ? Colors.green : Colors.red;

  Color getStockBgColor(String status) =>
      status == 'AMAN' ? Colors.green[100]! : Colors.red[100]!;

  Color getStockTextColor(String status) =>
      status == 'AMAN' ? Colors.green : Colors.red;

  void goToPos() => Get.toNamed('/pos');
  void goToInputStok() => Get.toNamed('/input-stok');
  void goToRiwayat() => Get.toNamed('/history');

  // =========================
  // Fetch Data Dashboard
  // =========================
  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    try {
      // Ambil transaksi & summary secara paralel
      final results = await Future.wait([
        _transactionProvider.getTransactions(),
        _summaryProvider.getSalesSummary('daily'),
      ]);

      final List<TransactionModel> data = results[0] as List<TransactionModel>;
      final Map<String, dynamic> summaryData =
          results[1] as Map<String, dynamic>;

      // Total dari API summary (lebih akurat)
      final int totalRevenue = summaryData['total_revenue'] ?? 0;
      totalHariIni.value = NumberFormat.currency(
        locale: 'id',
        symbol: 'Rp ',
        decimalDigits: 0,
      ).format(totalRevenue);

      // 3 transaksi terbaru
      transactions.value = data.take(3).map((trx) {
        return {
          'title': 'Trx #${trx.invoiceNumber}',
          'time': trx.createdAt != null
              ? DateFormat('HH:mm').format(trx.createdAt!)
              : '-',
          'price': NumberFormat.currency(
            locale: 'id',
            symbol: '',
            decimalDigits: 0,
          ).format(trx.total ?? 0),
        };
      }).toList();
    } catch (e) {
      print('Error fetching dashboard data: $e');
      totalHariIni.value = 'Rp 0';
    } finally {
      isLoading.value = false;
    }
  }
}
