class SalesSummaryModel {
  final String period;
  final int totalRevenue;
  final int totalTransactions;

  SalesSummaryModel({
    required this.period,
    required this.totalRevenue,
    required this.totalTransactions,
  });

  factory SalesSummaryModel.fromJson(Map<String, dynamic> json) {
    return SalesSummaryModel(
      period: json['period'] ?? '',
      // Parsing aman: ubah ke double dulu baru toInt() kalau server kirim desimal
      totalRevenue: (json['total_revenue'] ?? 0).toDouble().toInt(),
      totalTransactions: json['total_transactions'] ?? 0,
    );
  }
}