import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kawaiii_coffee/Database/TransactionsRes.dart';
import 'package:kawaiii_coffee/Model/TransactionsModel.dart';
 // Import Provider-nya

class DashboardAdminController extends GetxController {
  // Variabel Dashboard Utama
  var userName = "Owner".obs;
  var currentDate = "Sabtu, 24 Mei 2024".obs;
  var totalOmzet = "2.450.000".obs;
  var omzetGrowth = 12.obs;
  var jumlahTransaksi = 42.obs;
  var stokMenipis = 5.obs;

  // Variabel untuk Aktivitas Terkini
  var isLoadingActivities = true.obs;
  var recentTransactions = <TransactionModel>[].obs;

  // Injeksi Provider
  final TransactionProvider _transactionProvider = TransactionProvider();

  @override
  void onInit() {
    super.onInit();
    fetchRecentActivities();
  }

  // Logika menjadi jauh lebih bersih!
  Future<void> fetchRecentActivities() async {
    isLoadingActivities.value = true;
    try {
      // Panggil provider
      final data = await _transactionProvider.getTransactions();
      recentTransactions.value = data;
    } catch (e) {
      print('Error di Dashboard: $e');
      // Jika butuh menampilkan notifikasi error ke user, bisa pakai Get.snackbar di sini
    } finally {
      isLoadingActivities.value = false;
    }
  }

  // Format Rupiah (contoh: Rp 45k atau Rp 45.000)
  String formatCurrency(int amount) {
    if (amount >= 1000 && amount < 1000000) {
      return "Rp ${amount ~/ 1000}k";
    }
    return NumberFormat.simpleCurrency(locale: 'id', name: 'Rp ', decimalDigits: 0).format(amount);
  }

  // Format Waktu (contoh: 2 menit yang lalu)
  String formatTime(DateTime date) {
    Duration diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return "${diff.inMinutes} menit yang lalu";
    if (diff.inHours < 24) return "${diff.inHours} jam yang lalu";
    return DateFormat('dd MMM yyyy').format(date);
  }
}