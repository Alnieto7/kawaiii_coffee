import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kawaiii_coffee/Provider/TransactionProvider.dart';
import 'package:kawaiii_coffee/Model/TransactionsModel.dart';

class HppMarginController extends GetxController {
  // Data Header (Reaktif)
  var estLabaHarian = "Rp 0".obs;
  var trendLabaHarian = "Mengambil data...".obs;
  var isHarianUp = true.obs;

  var estLabaBulanan = "Rp 34.800.000".obs; // Masih statis untuk bulanan
  var targetLabaBulanan = "Target: Rp 40jt (87%)".obs;

  var isLoading = true.obs;

  // Injeksi Provider Transaksi
  final TransactionProvider _transactionProvider = TransactionProvider();

  // Data Produk (Tetap statis karena belum ada API khusus /products)
  var products = [
    {"name": "Es Kopi Aren", "sellPrice": 18000, "hpp": 5700},
    {"name": "Caramel Macchiato", "sellPrice": 25000, "hpp": 14200},
    {
      "name": "Mocha Almond",
      "sellPrice": 22000,
      "hpp": 23500,
    }, // Skenario Minus
    {"name": "Americano", "sellPrice": 15000, "hpp": 8000},
    {"name": "Vietnam Drip", "sellPrice": 16000, "hpp": 9200},
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // Panggil API saat halaman HPP dibuka
    fetchLabaHarian();
  }

  // --- LOGIKA MENGAMBIL DATA API TRANSAKSI ---
  Future<void> fetchLabaHarian() async {
    isLoading.value = true;
    try {
      // Menarik data transaksi menggunakan Provider yang sudah kita buat
      final List<TransactionModel> transactions = await _transactionProvider
          .getTransactions();

      // 1. Hitung Total Omzet/Pendapatan dari seluruh transaksi yang masuk
      double totalOmzet = 0;
      for (var trx in transactions) {
        totalOmzet += (trx.total ?? 0);
      }

      // 2. Hitung Estimasi Laba
      // Karena API belum mengembalikan modal(HPP) per transaksi, kita simulasikan
      // rata-rata margin laba kotor kedai kopi adalah 40% dari omzet.
      double estimasiLaba = totalOmzet * 0.4;

      // 3. Masukkan ke UI
      estLabaHarian.value = formatRupiah(estimasiLaba.toInt());

      // Atur status indikator hijau/merah
      if (transactions.isNotEmpty) {
        isHarianUp.value = true;
        trendLabaHarian.value = "Berdasarkan data API terkini";
      } else {
        isHarianUp.value = false;
        trendLabaHarian.value = "Belum ada transaksi hari ini";
      }
    } catch (e) {
      print('Error mengambil data transaksi untuk HPP: $e');
      trendLabaHarian.value = "Gagal memuat data";
      isHarianUp.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  // --- HELPER FORMATTER ---
  String formatRupiah(int amount) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  // Menghitung % Margin: ((Jual - HPP) / Jual) * 100
  String getMarginPercent(int sellPrice, int hpp) {
    double margin = ((sellPrice - hpp) / sellPrice) * 100;
    return "${margin > 0 ? '' : ''}${margin.toStringAsFixed(1)}%";
  }

  // Menghitung Nilai Margin: Jual - HPP
  String getMarginValue(int sellPrice, int hpp) {
    int margin = sellPrice - hpp;
    if (margin < 0) {
      return "(-${formatRupiah(margin.abs())})";
    }
    return formatRupiah(margin);
  }
}
