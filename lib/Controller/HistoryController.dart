import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kawaiii_coffee/Database/TransactionsRes.dart';
import 'package:kawaiii_coffee/Model/TransactionsModel.dart';

class HistoryController extends GetxController {
  // State Loading & Data
  var isLoading = true.obs;
  var transactions = <TransactionModel>[].obs;

  // State untuk Summary Card
  var totalPendapatan = "Rp 0".obs;
  var totalTransaksi = 0.obs;
  var lastUpdated = "Menunggu data...".obs;

  // State untuk Filter
  var selectedFilter = "Hari Ini".obs;

  final TransactionProvider _transactionProvider = TransactionProvider();

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  // --- LOGIKA MENGAMBIL DATA API ---
  Future<void> fetchHistory() async {
    isLoading.value = true;
    try {
      final data = await _transactionProvider.getTransactions();
      transactions.value = data;

      // Hitung Kalkulasi Summary Card (KHUSUS HARI INI)
      int totalUangHariIni = 0;
      int jumlahTransaksiHariIni = 0;
      final now = DateTime.now();

      for (var trx in data) {
        // Pastikan tanggal tidak null
        if (trx.createdAt != null) {
          // Cek apakah tahun, bulan, dan hari sama dengan hari ini
          bool isToday =
              trx.createdAt!.year == now.year &&
              trx.createdAt!.month == now.month &&
              trx.createdAt!.day == now.day;

          if (isToday) {
            totalUangHariIni += (trx.total ?? 0);
            jumlahTransaksiHariIni++;
          }
        }
      }

      // Masukkan hasil hitungan ke variabel UI
      totalPendapatan.value = formatRupiah(totalUangHariIni);
      totalTransaksi.value = jumlahTransaksiHariIni;
      lastUpdated.value = "Terakhir diperbarui baru saja";
    } catch (e) {
      print('Error fetching history: $e');
      lastUpdated.value = "Gagal memuat data";
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk mengganti filter (Bisa dikembangkan nanti untuk nembak API lagi)
  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  // --- HELPER FORMATTER ---
  String formatRupiah(int amount) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
}
