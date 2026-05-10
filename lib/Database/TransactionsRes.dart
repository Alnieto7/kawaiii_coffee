import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:kawaiii_coffee/Model/SalesSummaryModel.dart';
import 'package:kawaiii_coffee/Model/TransactionsModel.dart';

class TransactionProvider {
  static const String baseUrl = 'http://202.10.48.252/api/transactions';
  final box = GetStorage();

  // Fungsi untuk mengambil list transaksi
  Future<List<TransactionModel>> getTransactions() async {
    // 1. Baca token dari memori HP
    final token = box.read('auth_token');

    // --- TAMBAHKAN BARIS INI UNTUK DEBUGGING ---
    print('=== CEK TOKEN API ===');
    print('Token saat ini: $token');
    print('=====================');

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json', // Tambahan aman untuk Laravel
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Status Code API: ${response.statusCode}'); // Cek status code-nya

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final List dataList = jsonBody['data'];
        return dataList.map((e) => TransactionModel.fromJson(e)).toList();
      } else {
        throw Exception(
          'Gagal mengambil data dari server (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }
}
