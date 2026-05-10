import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kawaiii_coffee/Database/SalesSumRes.dart';
import 'package:kawaiii_coffee/Database/TransactionsRes.dart';
import 'package:kawaiii_coffee/Model/TransactionsModel.dart'; 


class DashboardController extends GetxController {
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

  // ==========================================
  // 🔥 LOGIKA UI YANG DIPINDAH DARI PAGE 🔥
  // ==========================================
  
  // 1. Logika Teks & Warna Status Shift
  String get shiftStatusText => isActive.value ? 'AKTIF' : 'NONAKTIF';
  Color get shiftStatusColor => isActive.value ? Colors.green : Colors.red;

  // 2. Logika Warna Label Stok
  Color getStockBgColor(String status) => status == 'AMAN' ? Colors.green[100]! : Colors.red[100]!;
  Color getStockTextColor(String status) => status == 'AMAN' ? Colors.green : Colors.red;

  // 3. Logika Navigasi Pindah Halaman (Sesuaikan nama route-nya dengan milikmu)
  void goToPos() => Get.toNamed('/pos'); 
  void goToInputStok() => Get.toNamed('/input-stok'); 
  void goToRiwayat() => Get.toNamed('/history'); 

  // ==========================================

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    try {
      final List<TransactionModel> data = await _transactionProvider.getTransactions();
      final summaryData = await _summaryProvider.getSalesSummary('daily');

      int totalRevenue = summaryData['total_revenue'] ?? 0;
      totalHariIni.value = NumberFormat.currency(
        locale: 'id', 
        symbol: 'Rp ', 
        decimalDigits: 0
      ).format(totalRevenue);

      var recentData = data.take(3).toList();
      
      transactions.value = recentData.map((trx) {
        return {
          'title': 'Trx #${trx.invoiceNumber}', 
          'time': trx.createdAt != null ? DateFormat('HH:mm').format(trx.createdAt!) : '-',
          'price': NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(trx.total ?? 0)
        };
      }).toList();

    } catch (e) {
      print("Error fetching dashboard data: $e");
      totalHariIni.value = 'Rp 0';
    } finally {
      isLoading.value = false;
    }
  }
}