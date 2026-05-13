import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kawaiii_coffee/Routes/Routes.dart';
import 'package:kawaiii_coffee/services/baseUrl.dart';

class QrisController extends GetxController {
  var qrUrl = ''.obs;
  var total = 0.obs;
  var transactionCode = ''.obs;
  var isChecking = false.obs;

  Timer? _pollingTimer;
  final _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic> data = Get.arguments ?? {};
    qrUrl.value = data['qr_url']?.toString() ?? '';
    total.value = data['total'] ?? 0;
    transactionCode.value = data['transaction_code']?.toString() ?? '';
    _startPolling();
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _checkPaymentStatus();
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
  }

  Future<void> _checkPaymentStatus() async {
    if (isChecking.value) return;
    isChecking.value = true;

    try {
      final token = _box.read('auth_token') ?? '';

      print('=== POLLING ===');
      print('Token: $token');
      print('Code: ${transactionCode.value}');
      print('URL: ${ApiConfig.transactions}/${transactionCode.value}/status');

      final response = await http.get(
        Uri.parse('${ApiConfig.transactions}/${transactionCode.value}/status'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final status = body['data']?['status'] ?? '';

        if (status == 'paid') {
          _pollingTimer?.cancel();
          Get.offNamed(AppRoutes.PaymentSuccess);
        }
      }
    } catch (e) {
      print('Polling error: $e');
    } finally {
      isChecking.value = false;
    }
  }

  String get formattedTotal => total.value
      .toString()
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );
}