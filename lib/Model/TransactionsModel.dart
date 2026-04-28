class TransactionModel {
  final int? id;
  final String? invoiceNumber;
  final int? total;
  final String? cashierName;
  final DateTime? createdAt;

  TransactionModel({
    this.id,
    this.invoiceNumber,
    this.total,
    this.cashierName,
    this.createdAt,
  });

  // Fungsi untuk mengubah JSON dari API (Postman) menjadi Object Dart
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      
      // Mengambil nomor struk. Jika dari backend namanya 'invoice', akan tetap terbaca.
      // Jika kosong, kita buatkan default "CS-{id}"
      invoiceNumber: json['invoice_number'] ?? json['invoice'] ?? "CS-${json['id'] ?? '000'}",
      
      // Mengambil total harga. Backend biasanya pakai 'total' atau 'total_price'
      total: json['total'] ?? json['total_price'] ?? 0,
      
      // Mengambil nama kasir.
      // Kadang backend mengirimnya di dalam object relasi: user -> name
      // Kadang langsung: cashier_name
      cashierName: json['user']?['name'] ?? json['cashier_name'] ?? "Kasir Kamo",
      
      // Mengubah string tanggal dari database menjadi tipe DateTime di Flutter
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString()) 
          : DateTime.now(),
    );
  }
}