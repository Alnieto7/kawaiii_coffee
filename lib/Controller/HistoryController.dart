import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kawaiii_coffee/Database/SalesSumRes.dart';
import 'package:kawaiii_coffee/Database/TransactionsRes.dart'; 
import 'package:kawaiii_coffee/Model/TransactionsModel.dart';


class HistoryController extends GetxController {
  // State Loading & Data List
  var isLoading = true.obs;
  var transactions = <TransactionModel>[].obs;

  // State untuk Summary Card
  var isSummaryLoading = false.obs;
  var totalPendapatan = "Rp 0".obs;
  var totalTransaksi = 0.obs;
  var lastUpdated = "Menunggu data...".obs;

  // State untuk Filter
  var selectedFilter = "Hari Ini".obs;

  // PANGGIL KEDUA PROVIDER SECARA TERPISAH
  final TransactionProvider _transactionProvider = TransactionProvider();
  final SalesSummaryProvider _summaryProvider = SalesSummaryProvider();

  @override
  void onInit() {
    super.onInit();
    fetchHistory(); 
    fetchSummaryCard("Hari Ini"); 
  }

  Future<void> fetchHistory() async {
    isLoading.value = true;
    try {
      final data = await _transactionProvider.getTransactions();
      transactions.value = data;
    } catch (e) {
      print('Error fetching history: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- LOGIKA MENGAMBIL KARTU PENDAPATAN ---
  Future<void> fetchSummaryCard(String filterName) async {
    isSummaryLoading.value = true;
    lastUpdated.value = "Memperbarui...";

    String apiPeriod = 'daily';
    if (filterName == 'Seminggu Terakhir') {
      apiPeriod = 'weekly';
    } else if (filterName == 'Bulanan') {
      apiPeriod = 'monthly';
    }

    try {
      // GUNAKAN PROVIDER SUMMARY DI SINI
      final summaryData = await _summaryProvider.getSalesSummary(apiPeriod);

      totalPendapatan.value = formatRupiah(summaryData['total_revenue']);
      totalTransaksi.value = summaryData['total_transactions'];
      lastUpdated.value = "Terakhir diperbarui baru saja";
    } catch (e) {
      print('Error fetching summary card: $e');
      lastUpdated.value = "Gagal memuat data";
      totalPendapatan.value = "Rp 0";
      totalTransaksi.value = 0;
    } finally {
      isSummaryLoading.value = false;
    }
  }

  void changeFilter(String filter) {
    if (selectedFilter.value == filter) return; 
    selectedFilter.value = filter;
    fetchSummaryCard(filter); 
  }

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