import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kawaiii_coffee/Database/TransactionsRes.dart';
import 'package:kawaiii_coffee/Model/TransactionsModel.dart'; 

class DashboardController extends GetxController {
  var isActive = true.obs;
  var duration = '04:25:12'.obs;
  
  // Variabel reaktif untuk Total Hari Ini
  var totalHariIni = 'Rp 0'.obs; 
  var isLoading = true.obs;

  // Data Stok (Masih statis)
  var stocks = [
    {'name': 'Biji Kopi', 'value': '12.5 kg', 'status': 'AMAN'},
    {'name': 'Susu UHT', 'value': '4.2 L', 'status': 'RENDAH'},
  ].obs;

  // Data Transaksi Terakhir (Sekarang kosong, akan diisi dari API)
  var transactions = <Map<String, dynamic>>[].obs;

  // Panggil Provider API
  final TransactionProvider _transactionProvider = TransactionProvider();

  @override
  void onInit() {
    super.onInit();
    // Panggil API saat dashboard dibuka
    fetchDashboardData(); 
  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    try {
      final List<TransactionModel> data = await _transactionProvider.getTransactions();
      
      // 1. HITUNG TOTAL PENDAPATAN HARI INI
      double total = 0;
      final now = DateTime.now();

      for (var trx in data) {
        if (trx.createdAt != null) {
          // Cek apakah tanggal transaksi sama dengan tanggal hari ini
          bool isToday = trx.createdAt!.year == now.year && 
                         trx.createdAt!.month == now.month && 
                         trx.createdAt!.day == now.day;
                         
          if (isToday) {
            total += (trx.total ?? 0); // Tambahkan ke total hari ini
          }
        }
      }

      // Format ke Rupiah dan update UI
      totalHariIni.value = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(total);

      // 2. ISI DAFTAR TRANSAKSI TERAKHIR (Ambil maksimal 3 data terbaru)
      var recentData = data.take(3).toList();
      
      transactions.value = recentData.map((trx) {
        return {
          'title': 'Trx #${trx.invoiceNumber}', // Nama transaksi
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