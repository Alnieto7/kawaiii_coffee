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
  // GET — Detail Transaksi (UNTUK STRUK)
  // =========================
  Future<Map<String, dynamic>> getTransactionDetail(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.transactions}/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);

        // 👇 CEK BUNGKUS DATA: Jika ada key 'data', ambil isinya. Jika tidak, ambil jsonBody langsung.
        if (jsonBody.containsKey('data') && jsonBody['data'] != null) {
          return jsonBody['data'] as Map<String, dynamic>;
        }

        return jsonBody; // Mengembalikan data flat
      } else {
        throw Exception(
          'Gagal mengambil detail (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }

  Future<Map<String, dynamic>> checkout({
    required String paymentMethod,
    required int paidAmount,
    required List items,
  }) async {
    final body = {
      'payment_method': paymentMethod,
      'paid_amount': paidAmount,
      'items': items,
    };

    print('REQUEST BODY = $body');

    final response = await http.post(
      Uri.parse(ApiConfig.transactions),
      headers: _headers,
      body: jsonEncode(body),
    );

    print('STATUS CODE = ${response.statusCode}');
    print('RAW RESPONSE = ${response.body}');

    return jsonDecode(response.body);
  }
    
  Future<Map<String, dynamic>> initiateSnap({required List items}) async {
    final response = await http.post(
      Uri.parse(ApiConfig.initiateSnap),
      headers: _headers,
      body: jsonEncode({'items': items}),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> initiateQris({required List items}) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.initiateQris),
        headers: _headers,
        body: jsonEncode({'items': items}),
      );

      final Map<String, dynamic> jsonBody = jsonDecode(response.body);
      print("Respons Backend: $jsonBody");
      print("Status Code: ${response.statusCode}"); // ✅ tambah ini

      // ✅ Cek status code dulu
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          jsonBody['message'] ?? 'Server error (${response.statusCode})',
        );
      }

      // ✅ Cek qr_url ada atau tidak sebelum return
      if (jsonBody['qr_url'] == null) {
        throw Exception(
          jsonBody['message'] ?? 'QR URL tidak ditemukan dari server',
        );
      }

      return {
        'qr_url': jsonBody['qr_url'],
        'total': jsonBody['total'],
        'transaction_code': jsonBody['transaction_code'],
      };
    } catch (e) {
      print("Provider Error: $e");
      rethrow; 
    }
  }
}
