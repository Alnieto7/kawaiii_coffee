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
  var totalHariIni = 'Rp 0'.obs; 
  var totalTransaksi = '0 Struk'.obs; // Pengganti status shift
  var itemTerjual = '0 Pcs'.obs;      // Pengganti durasi
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
  
  Color getStockBgColor(String status) => status == 'AMAN' ? Colors.green[100]! : Colors.red[100]!;
  Color getStockTextColor(String status) => status == 'AMAN' ? Colors.green : Colors.red;

  // Navigasi dengan Auto-Refresh
  void goToInputStok() async {
    await Get.toNamed(AppRoutes.InputStock); 
    fetchDashboardData(); 
  }

  void goToAllStock() async {
    await Get.toNamed(AppRoutes.AllStock); 
    fetchDashboardData(); 
  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    try {
      final List<TransactionModel> data = await _transactionProvider.getTransactions();
      final summaryData = await _summaryProvider.getSalesSummary('daily');
      final List<IngredientModel> ingredientData = await _ingredientProvider.getIngredients(); 

      // 1. Olah Data Summary (Total Rp, Total Trx, Total Item)
      int totalRevenue = summaryData['total_revenue'] ?? 0;
      
      // Mengambil data dari backend, jika backend belum sedia, kita hitung manual dari list data
      int trxCount = summaryData['total_transactions'] ?? data.length; 
      int itemsCount = summaryData['total_items'] ?? summaryData['total_items_sold'] ?? 0; 

      totalHariIni.value = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(totalRevenue);
      totalTransaksi.value = '$trxCount Struk';
      itemTerjual.value = '$itemsCount Pcs';

      // 2. Olah Data Transaksi (Ambil 3 Teratas)
      var recentData = data.take(3).toList();
      transactions.value = recentData.map((trx) {
        return {
          'title': 'Trx #${trx.invoiceNumber}', 
          'time': trx.createdAt != null ? DateFormat('HH:mm').format(trx.createdAt!) : '-',
          'price': NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(trx.total ?? 0)
        };
      }).toList();

      // 3. Olah Data Stok Bahan Baku (Ambil 2 Teratas)
      var topIngredients = ingredientData.take(2).toList();
      stocks.value = topIngredients.map((item) {
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
      totalTransaksi.value = '0 Struk';
      itemTerjual.value = '0 Pcs';
    } finally {
      isLoading.value = false;
    }
  }
}