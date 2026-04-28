import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:kawaiii_coffee/Model/TransactionsModel.dart'; // Pastikan path ini sesuai

class TransactionProvider {
  static const String baseUrl = 'http://202.10.48.252/api/transactions';
  final box = GetStorage();

  // Fungsi untuk mengambil list transaksi
  Future<List<TransactionModel>> getTransactions() async {
    final token = box.read('auth_token');
    
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        
        // Mengambil array dari dalam key 'data' (Sesuai paginasi Laravel)
        final List dataList = jsonBody['data']; 
        
        // Mengubah list Map/JSON mentah menjadi List of Object (Model)
        return dataList.map((e) => TransactionModel.fromJson(e)).toList();
      } else {
        throw Exception('Gagal mengambil data dari server (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }
}