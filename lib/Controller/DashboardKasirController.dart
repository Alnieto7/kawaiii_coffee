import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kawaiii_coffee/Model/TransactionsModel.dart'; 
import 'package:kawaiii_coffee/Model/IngredientModel.dart';
import 'package:kawaiii_coffee/Provider/IngredientsProvider.dart';
import 'package:kawaiii_coffee/Provider/SalesSummaryProvider.dart';
import 'package:kawaiii_coffee/Provider/TransactionProvider.dart';
import 'package:kawaiii_coffee/Routes/Routes.dart'; 

class DashboardKasirController extends GetxController {
  // --- STATE VARIABEL ---
  var isActive = true.obs;
  var duration = '04:25:12'.obs;
  var totalHariIni = 'Rp 0'.obs; 
  var isLoading = true.obs;

  var stocks = <Map<String, String>>[].obs;
  var transactions = <Map<String, dynamic>>[].obs;

  final TransactionProvider _transactionProvider = TransactionProvider();
  final SalesSummaryProvider _summaryProvider = SalesSummaryProvider();
  final IngredientProvider _ingredientProvider = IngredientProvider();

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData(); 
  }

  // ==========================================
  // 🔥 LOGIKA UI 🔥
  // ==========================================
  
  // 1. Logika Teks & Warna Status Shift
  String get shiftStatusText => isActive.value ? 'AKTIF' : 'NONAKTIF';
  Color get shiftStatusColor => isActive.value ? Colors.green : Colors.red;

  // 2. Logika Warna Label Stok
  Color getStockBgColor(String status) => status == 'AMAN' ? Colors.green[100]! : Colors.red[100]!;
  Color getStockTextColor(String status) => status == 'AMAN' ? Colors.green : Colors.red;

  void goToInputStok() async {
    await Get.toNamed(AppRoutes.InputStock); 
    fetchDashboardData(); // Tarik data ulang setelah halaman input ditutup
  }

  void goToAllStock() async {
    await Get.toNamed(AppRoutes.AllStock); 
    fetchDashboardData(); // Tarik data ulang setelah halaman list stok ditutup
  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    try {
      // 1. Tarik semua API secara paralel/bersamaan agar loading lebih cepat
      final List<TransactionModel> data = await _transactionProvider.getTransactions();
      final summaryData = await _summaryProvider.getSalesSummary('daily');
      final List<IngredientModel> ingredientData = await _ingredientProvider.getIngredients(); 

      // 2. Olah Data Summary (Total Hari Ini)
      int totalRevenue = summaryData['total_revenue'] ?? 0;
      totalHariIni.value = NumberFormat.currency(
        locale: 'id', 
        symbol: 'Rp ', 
        decimalDigits: 0
      ).format(totalRevenue);

      // 3. Olah Data Transaksi (Ambil 3 Teratas)
      var recentData = data.take(3).toList();
      transactions.value = recentData.map((trx) {
        return {
          'title': 'Trx #${trx.invoiceNumber}', 
          'time': trx.createdAt != null ? DateFormat('HH:mm').format(trx.createdAt!) : '-',
          'price': NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(trx.total ?? 0)
        };
      }).toList();

      // 4. Olah Data Stok Bahan Baku (Ambil 2 Teratas)
      var topIngredients = ingredientData.take(2).toList();
      stocks.value = topIngredients.map((item) {
        // Logika penentuan status AMAN / RENDAH menggunakan Model
        String status = item.stock > item.minStock ? 'AMAN' : 'RENDAH';

        return {
          'name': item.name,
          'value': '${item.stock} ${item.unit}', 
          'status': status,
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