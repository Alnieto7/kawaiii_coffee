import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PrinterController extends GetxController {
  final GetStorage _box = GetStorage();
  static const String _storageKey = 'printer_mac_address';
  static const String _storageNameKey = 'printer_name';

  var printers = [].obs;
  var selectedPrinter = Rxn<dynamic>();
  var isMobile = true.obs;
  void updateLayout(BoxConstraints constraints) => isMobile.value = constraints.maxWidth < 600;
  var isConnected = false.obs;
  var isLoading = false.obs;
  var isConnecting = false.obs;

  @override
  void onInit() {
    super.onInit();
    _autoReconnect();
  }

  /// Dipanggil otomatis saat app dibuka (lewat binding).
  /// Coba connect ke printer terakhir yang berhasil, tanpa perlu buka
  /// halaman Settings dulu.
  Future<void> _autoReconnect() async {
    final savedMac = _box.read<String>(_storageKey);
    if (savedMac == null || savedMac.isEmpty) return;

    try {
      isConnecting.value = true;
      final result = await PrintBluetoothThermal.connect(
        macPrinterAddress: savedMac,
      );
      isConnected.value = result;
      if (result) {
        // Buat objek printer minimal dari data tersimpan, supaya UI settings
        // tetap bisa menampilkan info printer yang sedang aktif.
        selectedPrinter.value = _SavedPrinterInfo(
          name: _box.read<String>(_storageNameKey) ?? 'Printer',
          macAdress: savedMac,
        );
      }
    } catch (_) {
      // Diamkan saja kalau gagal auto-connect (misal printer mati/di luar jangkauan);
      // user tetap bisa connect manual lewat halaman Settings.
    } finally {
      isConnecting.value = false;
    }
  }

  // Cari printer yang sudah pernah dipair di HP
  Future<void> scanPrinter() async {
    try {
      isLoading.value = true;

      // Android 12+
      if (await Permission.bluetoothConnect.isDenied) {
        await Permission.bluetoothConnect.request();
      }

      if (await Permission.bluetoothScan.isDenied) {
        await Permission.bluetoothScan.request();
      }

      // Android lama (opsional)
      if (await Permission.location.isDenied) {
        await Permission.location.request();
      }

      final connectPermission = await Permission.bluetoothConnect.isGranted;
      final scanPermission = await Permission.bluetoothScan.isGranted;

      if (!connectPermission || !scanPermission) {
        Get.snackbar(
          "Permission Bluetooth",
          "Aktifkan izin perangkat terdekat",
        );
        return;
      }

      final devices = await PrintBluetoothThermal.pairedBluetooths;

      printers.value = devices;

      if (printers.isEmpty) {
        Get.snackbar(
          "Printer",
          "Tidak ada printer yang sudah dipair",
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> connectPrinter(dynamic printer) async {
    try {
      isConnecting.value = true;

      final result = await PrintBluetoothThermal.connect(
        macPrinterAddress: printer.macAdress,
      );

      if (result) {
        selectedPrinter.value = printer;
        isConnected.value = true;

        // Simpan supaya auto-reconnect jalan di sesi berikutnya.
        await _box.write(_storageKey, printer.macAdress as String);
        await _box.write(_storageNameKey, printer.name as String);

        Get.snackbar(
          "Berhasil",
          "Printer terhubung",
        );
      } else {
        Get.snackbar(
          "Gagal",
          "Tidak bisa terhubung ke printer",
        );
      }
    } catch (e) {
      Get.snackbar(
        "Gagal",
        e.toString(),
      );
    } finally {
      isConnecting.value = false;
    }
  }

  Future<void> disconnectPrinter() async {
    await PrintBluetoothThermal.disconnect;
    isConnected.value = false;
    selectedPrinter.value = null;
    await _box.remove(_storageKey);
    await _box.remove(_storageNameKey);
  }

  /// Cek status koneksi real-time — printer Bluetooth generic kadang
  /// disconnect sendiri kalau idle lama, jadi selalu cek ulang sebelum print.
  Future<bool> checkConnection() async {
    final status = await PrintBluetoothThermal.connectionStatus;
    isConnected.value = status;
    return status;
  }

  Future<void> testPrint() async {
    if (!isConnected.value) {
      Get.snackbar(
        "Info",
        "Hubungkan printer dulu",
      );
      return;
    }

    final profile = await CapabilityProfile.load();

    final generator = Generator(
      PaperSize.mm58,
      profile,
    );

    List<int> bytes = [];

    bytes += generator.text(
      "Test Print",
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
      ),
    );

    bytes += generator.text(
      "Printer terhubung dengan baik",
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );

    bytes += generator.feed(3);
    bytes += generator.cut();

    await PrintBluetoothThermal.writeBytes(bytes);
  }
}

/// Model minimal untuk merepresentasikan printer yang di-restore dari
/// penyimpanan lokal (bukan dari hasil scan langsung).
class _SavedPrinterInfo {
  final String name;
  final String macAdress;

  _SavedPrinterInfo({required this.name, required this.macAdress});
}