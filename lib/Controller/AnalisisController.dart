import 'package:get/get.dart';
class AnalisisController extends GetxController {
  // --- FILTER STATE ---
  var selectedFilter = "7 Hari Terakhir".obs;

  // --- DATA RINGKASAN (SUMMARY) ---
  var totalPenjualan = "Rp 12.450k".obs;
  var trendPenjualan = "+12.5%".obs;
  var isPenjualanUp = true.obs;

  var totalHpp = "Rp 4.210k".obs;
  var statusHpp = "Stabil".obs;

  var labaKotor = "Rp 8.240k".obs;
  var trendLaba = "+8.2%".obs;
  var isLabaUp = true.obs;

  var rataMargin = "66.2%".obs;
  var targetMargin = "Target: 60%".obs;

  // --- DATA GRAFIK (DUMMY 1-100) ---
  // Mewakili tinggi bar chart dari Senin - Minggu
  var chartBars = [40, 60, 45, 75, 60, 100, 70].obs; 
  var chartDays = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'].obs;

  // --- DATA TOP PRODUK ---
  var topProducts = [
    {"name": "Es Kopi Susu Aren", "qty": 142, "progress": 0.9},
    {"name": "Cafe Latte", "qty": 98, "progress": 0.6},
    {"name": "Americano Ice", "qty": 76, "progress": 0.45},
    {"name": "Caramel Macchiato", "qty": 45, "progress": 0.25},
  ].obs;

  // --- DATA METRIK PERFORMA ---
  var metrics = [
    {"name": "Kopi Susu Aren", "terjual": 142, "pendapatan": "2.8M", "laba": "1.8M", "labaColor": true},
    {"name": "Cafe Latte", "terjual": 98, "pendapatan": "2.4M", "laba": "1.2M", "labaColor": true},
    {"name": "Matcha Latte", "terjual": 54, "pendapatan": "1.3M", "laba": "0.7M", "labaColor": true},
  ].obs;

  // --- FUNGSI LOGIKA ---
  void changeFilter(String filter) {
    selectedFilter.value = filter;
    // Nanti panggil API update data di sini berdasarkan filter
  }

  void downloadReport() {
    Get.snackbar("Download", "Laporan sedang diunduh...", snackPosition: SnackPosition.TOP);
  }
}