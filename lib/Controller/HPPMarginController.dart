import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HppMarginController extends GetxController {
  // Data Header
  var estLabaHarian = "Rp 1.250.000".obs;
  var trendLabaHarian = "12% dari kemarin".obs;
  var isHarianUp = true.obs;

  var estLabaBulanan = "Rp 34.800.000".obs;
  var targetLabaBulanan = "Target: Rp 40jt (87%)".obs;

  // Data Produk
  // Nanti struktur ini bisa disesuaikan dengan response JSON dari Laravel API-mu
  var products = [
    {"name": "Es Kopi Aren", "sellPrice": 18000, "hpp": 5700},
    {"name": "Caramel Macchiato", "sellPrice": 25000, "hpp": 14200},
    {"name": "Mocha Almond", "sellPrice": 22000, "hpp": 23500}, // Skenario Minus
    {"name": "Americano", "sellPrice": 15000, "hpp": 8000},
    {"name": "Vietnam Drip", "sellPrice": 16000, "hpp": 9200},
  ].obs;

  // Helper Formatter
  String formatRupiah(int amount) {
    return NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(amount);
  }

  // Menghitung % Margin: ((Jual - HPP) / Jual) * 100
  String getMarginPercent(int sellPrice, int hpp) {
    double margin = ((sellPrice - hpp) / sellPrice) * 100;
    return "${margin > 0 ? '' : ''}${margin.toStringAsFixed(1)}%";
  }

  // Menghitung Nilai Margin: Jual - HPP
  String getMarginValue(int sellPrice, int hpp) {
    int margin = sellPrice - hpp;
    if (margin < 0) {
      return "(-${formatRupiah(margin.abs())})";
    }
    return formatRupiah(margin);
  }
}