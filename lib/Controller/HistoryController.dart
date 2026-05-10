import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kawaiii_coffee/Provider/TransactionProvider.dart';
import 'package:kawaiii_coffee/Provider/SalesSummaryProvider.dart';
import 'package:kawaiii_coffee/Model/TransactionsModel.dart';

class HistoryController extends GetxController {
  // State Loading & Data
  var isLoading = true.obs;
  var isSummaryLoading = false.obs;
  var transactions = <TransactionModel>[].obs;

  // State Summary Card
  var totalPendapatan = 'Rp 0'.obs;
  var totalTransaksi = 0.obs;
  var lastUpdated = 'Menunggu data...'.obs;

  // State Filter
  var selectedFilter = 'Hari Ini'.obs;

  final TransactionProvider _transactionProvider = TransactionProvider();
  final SalesSummaryProvider _summaryProvider = SalesSummaryProvider();

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
    fetchSummaryCard('Hari Ini');
  }

  // =========================
  // Fetch List Transaksi
  // =========================
  Future<void> fetchHistory() async {
    isLoading.value = true;
    try {
      final data = await _transactionProvider.getTransactions();
      transactions.value = data;
    } catch (e) {
      print('Error fetching history: $e');
      lastUpdated.value = 'Gagal memuat data';
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // Fetch Summary Card dari API
  // =========================
  Future<void> fetchSummaryCard(String filterName) async {
    isSummaryLoading.value = true;
    lastUpdated.value = 'Memperbarui...';

    final apiPeriod = switch (filterName) {
      'Seminggu Terakhir' => 'weekly',
      'Bulanan' => 'monthly',
      _ => 'daily',
    };

    try {
      final summaryData = await _summaryProvider.getSalesSummary(apiPeriod);
      totalPendapatan.value = formatRupiah(summaryData['total_revenue'] ?? 0);
      totalTransaksi.value = summaryData['total_transactions'] ?? 0;
      lastUpdated.value = 'Terakhir diperbarui baru saja';
    } catch (e) {
      print('Error fetching summary: $e');
      lastUpdated.value = 'Gagal memuat data';
      totalPendapatan.value = 'Rp 0';
      totalTransaksi.value = 0;
    } finally {
      isSummaryLoading.value = false;
    }
  }

  // =========================
  // Ganti Filter
  // =========================
  void changeFilter(String filter) {
    if (selectedFilter.value == filter) return;
    selectedFilter.value = filter;
    fetchSummaryCard(filter);
  }

  // =========================
  // Helper Formatter
  // =========================
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
