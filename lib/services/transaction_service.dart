import 'dart:convert';
import 'package:http/http.dart' as http;

class TransactionService {

  static Future checkout({
    required String token,
    required String paymentMethod,
    required int paidAmount,
    required List items,
  }) async {

    final response = await http.post(

      Uri.parse("http://202.10.48.252/api/transactions"),

      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },

      body: jsonEncode({
        "payment_method": paymentMethod,
        "paid_amount": paidAmount,
        "items": items,
      }),
    );

    return jsonDecode(response.body);
  }
}