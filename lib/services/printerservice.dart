import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

/// Representasi 1 baris item di struk, sudah dalam bentuk string yang siap
/// ditampilkan (formatting currency dilakukan di controller pemanggil,
/// bukan di sini) supaya PrinterService gak perlu tau format Rupiah dsb.
class ReceiptLineItem {
  final String name;
  final String qtyPriceLabel; // contoh: "1 x Rp 18.000"
  final String subtotalLabel; // contoh: "Rp 18.000"

  ReceiptLineItem({
    required this.name,
    required this.qtyPriceLabel,
    required this.subtotalLabel,
  });
}

/// Satu-satunya sumber format & proses cetak struk di seluruh app.
/// Dipakai oleh: auto-print saat checkout, tombol Print di ReceiptPage,
/// dan tombol Print Nota di History > Detail Transaksi.
class PrinterService {
  static const String storeName = 'kawaii coffee';
  static const String tagline = 'Terima kasih telah berbelanja';

  // Lebar kertas 58mm — angka ini menentukan berapa banyak spasi yang
  // ditambahin sebelum value supaya rata kanan. Kalau value masih
  // menjorok ke kiri (belum nyampe ke tepi kanan kertas), NAIKKAN angka
  // ini. Kalau value malah kepotong/ke-wrap ke baris baru, TURUNKAN.
  static const int _lineWidth = 42;

  /// Bikin 1 baris "label ....... value" manual pakai padding spasi,
  /// bukan generator.row(). Ini buat menghindari bug alignment kolom
  /// yang muncul di beberapa printer generic waktu pakai fitur row()
  /// bawaan esc_pos_utils_plus.
  String _twoColumnLine(String label, String value) {
    final totalTextLength = label.length + value.length;
    final spaceCount = _lineWidth - totalTextLength;

    if (spaceCount < 1) {
      // Kalau kepanjangan, kasih 1 spasi minimal biar gak nempel
      return '$label $value';
    }

    return label + (' ' * spaceCount) + value;
  }

  Future<void> printReceipt({
    required String invoiceNumber,
    required String transactionDate,
    required String cashierName,
    required String paymentMethod,
    required List<ReceiptLineItem> items,
    required String totalFormatted,
    required String paidFormatted,
    required String changeFormatted,
  }) async {
    final connected = await PrintBluetoothThermal.connectionStatus;

    if (!connected) {
      throw Exception('Printer belum terhubung');
    }

    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    final bytes = <int>[];

    // ===== HEADER =====
    bytes.addAll(generator.text(
      storeName,
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    ));
    bytes.addAll(generator.text(
      tagline,
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(generator.feed(1));

    // ===== STATUS =====
    bytes.addAll(generator.text(
      '* Pembayaran Berhasil *',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    ));
    bytes.addAll(generator.feed(1));

    // ===== INFO TRANSAKSI =====
    bytes.addAll(generator.text(
      _twoColumnLine('Invoice', invoiceNumber),
      styles: const PosStyles(bold: true),
    ));
    bytes.addAll(generator.text(
      _twoColumnLine('Tanggal', transactionDate),
    ));
    bytes.addAll(generator.text(
      _twoColumnLine('Kasir', cashierName),
    ));
    bytes.addAll(generator.text(
      _twoColumnLine('Pembayaran', paymentMethod),
    ));
    bytes.addAll(generator.hr());

    // ===== JUDUL KOLOM ITEM =====
    bytes.addAll(generator.text(
      _twoColumnLine('Item', 'Subtotal'),
    ));
    bytes.addAll(generator.feed(1));

    // ===== DAFTAR ITEM =====
    for (final item in items) {
      bytes.addAll(generator.text(
        _twoColumnLine(item.name, item.subtotalLabel),
        styles: const PosStyles(bold: true),
      ));
      bytes.addAll(generator.text(
        item.qtyPriceLabel,
        styles: const PosStyles(fontType: PosFontType.fontB),
      ));
    }
    bytes.addAll(generator.hr());

    // ===== RINGKASAN TOTAL =====
    bytes.addAll(generator.text(
      _twoColumnLine('Total', totalFormatted),
      styles: const PosStyles(bold: true),
    ));
    bytes.addAll(generator.text(
      _twoColumnLine('Dibayar', paidFormatted),
    ));
    bytes.addAll(generator.text(
      _twoColumnLine('Kembalian', changeFormatted),
      styles: const PosStyles(bold: true),
    ));
    bytes.addAll(generator.feed(1));

    // ===== FOOTER =====
    bytes.addAll(generator.text(
      tagline,
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(generator.text(
      'di $storeName',
      styles: const PosStyles(align: PosAlign.center),
    ));

    // Printer 58mm generic biasanya tidak punya cutter otomatis
    bytes.addAll(generator.feed(3));

    final result = await PrintBluetoothThermal.writeBytes(bytes);
    if (!result) {
      throw Exception('Printer menolak perintah cetak');
    }
  }
}