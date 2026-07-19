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
  static const String storeName = 'Kawaiii coffee';
  static const String tagline = 'Terima kasih telah berbelanja';

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
    bytes.addAll(generator.row([
      PosColumn(text: 'Invoice', width: 5),
      PosColumn(text: invoiceNumber, width: 7, styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]));
    bytes.addAll(generator.row([
      PosColumn(text: 'Tanggal', width: 5),
      PosColumn(text: transactionDate, width: 7, styles: const PosStyles(align: PosAlign.right)),
    ]));
    bytes.addAll(generator.row([
      PosColumn(text: 'Kasir', width: 5),
      PosColumn(text: cashierName, width: 7, styles: const PosStyles(align: PosAlign.right)),
    ]));
    bytes.addAll(generator.row([
      PosColumn(text: 'Pembayaran', width: 5),
      PosColumn(text: paymentMethod, width: 7, styles: const PosStyles(align: PosAlign.right)),
    ]));
    bytes.addAll(generator.hr());

    // ===== JUDUL KOLOM ITEM =====
    bytes.addAll(generator.row([
      PosColumn(text: 'Item', width: 7),
      PosColumn(text: 'Subtotal', width: 5, styles: const PosStyles(align: PosAlign.right)),
    ]));
    bytes.addAll(generator.feed(1));

    // ===== DAFTAR ITEM =====
    for (final item in items) {
      bytes.addAll(generator.row([
        PosColumn(
          text: item.name,
          width: 7,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: item.subtotalLabel,
          width: 5,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]));
      bytes.addAll(generator.text(
        item.qtyPriceLabel,
        styles: const PosStyles(fontType: PosFontType.fontB),
      ));
    }
    bytes.addAll(generator.hr());

    // ===== RINGKASAN TOTAL =====
    bytes.addAll(generator.row([
      PosColumn(text: 'Total', width: 7, styles: const PosStyles(bold: true)),
      PosColumn(text: totalFormatted, width: 5, styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]));
    bytes.addAll(generator.row([
      PosColumn(text: 'Dibayar', width: 7),
      PosColumn(text: paidFormatted, width: 5, styles: const PosStyles(align: PosAlign.right)),
    ]));
    bytes.addAll(generator.row([
      PosColumn(text: 'Kembalian', width: 7, styles: const PosStyles(bold: true)),
      PosColumn(text: changeFormatted, width: 5, styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]));
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