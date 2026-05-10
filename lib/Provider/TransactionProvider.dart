import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:kawaiii_coffee/Model/TransactionsModel.dart';
import 'package:kawaiii_coffee/services/baseUrl.dart';

class TransactionProvider {
  final _box = GetStorage();

  String get _token => _box.read('auth_token') ?? '';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $_token',
  };

  // =========================
  // GET — List Transaksi
  // =========================
  Future<List<TransactionModel>> getTransactions() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.transactions),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final List dataList = jsonBody['data'];
        return dataList.map((e) => TransactionModel.fromJson(e)).toList();
      } else {
        throw Exception(
          'Gagal mengambil data (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }

  // =========================
  // POST — Checkout (Cash/QRIS/Transfer)
  // =========================
  Future<Map<String, dynamic>> checkout({
    required String paymentMethod,
    required int paidAmount,
    required List items,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConfig.transactions),
      headers: _headers,
      body: jsonEncode({
        'payment_method': paymentMethod,
        'paid_amount': paidAmount,
        'items': items,
      }),
    );

    return jsonDecode(response.body);
  }

  // =========================
  // POST — Initiate Midtrans Snap
  // =========================
  Future<Map<String, dynamic>> initiateSnap({required List items}) async {
    final response = await http.post(
      Uri.parse(ApiConfig.initiateSnap),
      headers: _headers,
      body: jsonEncode({'items': items}),
    );

    return jsonDecode(response.body);
  }

  // =========================
  // POST — Initiate QRIS Dynamic
  // =========================
  Future<Map<String, dynamic>> initiateQris({required List items}) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.initiateQris),
        headers: _headers,
        body: jsonEncode({'items': items}),
      );

      // Decode response body
      final Map<String, dynamic> jsonBody = jsonDecode(response.body);

      // Debug untuk memastikan data masuk di console
      print("Respons Backend: $jsonBody");

      // Karena respons backend kamu flat, langsung ambil key-nya
      return {
        'qr_url':
            jsonBody['qr_url'], // Mengambil https://api.sandbox.midtrans.com/...
        'total': jsonBody['total'], // Mengambil 25000
      };
    } catch (e) {
      print("Provider Error: $e");
      throw Exception('Gagal inisialisasi QRIS: $e');
    }
  }
}
