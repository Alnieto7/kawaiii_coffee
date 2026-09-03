import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart'; // Pastikan import warna
import 'package:kawaiii_coffee/Model/TransactionsModel.dart'; 
import 'package:kawaiii_coffee/Model/IngredientModel.dart';
import 'package:kawaiii_coffee/Provider/IngredientsProvider.dart';
import 'package:kawaiii_coffee/Provider/SalesSummaryProvider.dart';
import 'package:kawaiii_coffee/Provider/TransactionProvider.dart';
import 'package:kawaiii_coffee/Routes/Routes.dart'; 

class DashboardKasirController extends GetxController {
  // --- STATE VARIABEL LAYOUT ---
  var isMobile = true.obs;

  // --- STATE VARIABEL DATA ---
  var totalHariIni = 'Rp 0'.obs; 
  var totalTransaksi = '0 Struk'.obs; 
  var itemTerjual = '0 Pcs'.obs;      
  var isLoading = true.obs;

  var stocks = <Map<String, String>>[].obs;
  var transactions = <Map<String, dynamic>>[].obs;

  final TransactionProvider _transactionProvider = TransactionProvider();
  final SalesSummaryProvider _summaryProvider = SalesSummaryProvider();
  final IngredientProvider _ingredientProvider = IngredientProvider();
  final _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData(); 
  }

  // ==========================================
  // 🔥 LOGIKA UI & LAYOUT 🔥
  // ==========================================
  
  void updateLayout(BoxConstraints constraints) {
    isMobile.value = constraints.maxWidth < 600;
  }

  Color getStockBgColor(String status) => status == 'AMAN' ? Colors.green[100]! : Colors.red[100]!;
  Color getStockTextColor(String status) => status == 'AMAN' ? Colors.green : Colors.red;

  // Dialog Logout dipindah ke sini
  void confirmLogout() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal', style: TextStyle(color: AppColors.textHint)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Get.back();
              logout();
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void logout() {
    _box.erase();
    Get.offAllNamed(AppRoutes.loginPage);
  }

  // ==========================================
  // 🔥 NAVIGASI & DATA 🔥
  // ==========================================

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

      int totalRevenue = summaryData['total_revenue'] ?? 0;
      int trxCount = summaryData['total_transactions'] ?? data.length; 
      int itemsCount = summaryData['total_items'] ?? summaryData['total_items_sold'] ?? 0; 

      totalHariIni.value = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(totalRevenue);
      totalTransaksi.value = '$trxCount Struk';
      itemTerjual.value = '$itemsCount Pcs';

      var recentData = data.take(3).toList();
      transactions.value = recentData.map((trx) {
        return {
          'title': 'Trx #${trx.invoiceNumber}', 
          'time': trx.createdAt != null ? DateFormat('HH:mm').format(trx.createdAt!) : '-',
          'price': NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(trx.total ?? 0)
        };
      }).toList();

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