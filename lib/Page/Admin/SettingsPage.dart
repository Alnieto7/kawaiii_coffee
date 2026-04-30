import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/AdminComponent/setting_section_card.dart';
import 'package:kawaiii_coffee/Component/AdminComponent/setting_text_field.dart';
import 'package:kawaiii_coffee/Controller/SettingController.dart';


class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      // Tombol FAB Simpan (Pojok Kanan Bawah)
      floatingActionButton: FloatingActionButton(
        onPressed: controller.saveSettings,
        backgroundColor: const Color(0xFFD97217),
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.save_rounded, color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Pengaturan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
                  TextButton(
                    onPressed: controller.saveSettings,
                    child: const Text("Simpan", style: TextStyle(color: Color(0xFFD97217), fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              const SizedBox(height: 20),

              // --- TITLE & SUBTITLE ---
              const Text("Pengaturan Sistem", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFD97217))),
              const SizedBox(height: 8),
              const Text("Kelola operasional dan identitas kedai Anda di sini.", style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 24),

              // --- CARD 1: PROFIL TOKO ---
              SettingSectionCard(
                icon: Icons.storefront_rounded,
                title: "Profil Toko",
                child: Column(
                  children: [
                    // Foto Profil & Tombol Ganti
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              const CircleAvatar(
                                radius: 45,
                                backgroundColor: Color(0xFF5B3E31), // Warna kopi gelap
                                child: Icon(Icons.coffee, color: Colors.white, size: 30), // Placeholder logo
                              ),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(color: Color(0xFFD97217), shape: BoxShape.circle),
                                child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                              )
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text("Ganti Logo Toko", style: TextStyle(color: Color(0xFFD97217), fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Input Fields
                    SettingTextField(
                      label: "NAMA TOKO",
                      controller: controller.storeNameCtrl,
                    ),
                    SettingTextField(
                      label: "ALAMAT LENGKAP",
                      controller: controller.addressCtrl,
                      maxLines: 3, 
                    ),
                  ],
                ),
              ),

              SettingSectionCard(
                icon: Icons.payments_rounded,
                title: "Metode Pembayaran",
                child: Column(
                  children: [
                    _buildSwitchItem("Tunai (Cash)", Icons.money, controller.isCashEnabled),
                    const Divider(height: 24, color: Color(0xFFEEEEEE)),
                    _buildSwitchItem("QRIS / E-Wallet", Icons.qr_code_scanner, controller.isQrisEnabled),
                    const Divider(height: 24, color: Color(0xFFEEEEEE)),
                    _buildSwitchItem("Bank Transfer", Icons.account_balance, controller.isTransferEnabled),
                  ],
                ),
              ),

              SettingSectionCard(
                icon: Icons.security_rounded,
                title: "Pengaturan QRIS",
                child: Column(
                  children: [
                    SettingTextField(
                      label: "MERCHANT ID",
                      controller: controller.merchantIdCtrl,
                    ),
                    Obx(() => SettingTextField(
                      label: "API KEY",
                      controller: controller.apiKeyCtrl,
                      obscureText: !controller.isApiKeyVisible.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isApiKeyVisible.value ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                          size: 18,
                        ),
                        onPressed: controller.toggleApiKeyVisibility,
                      ),
                    )),
                    
                    // Info Box Kuning/Orange
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED), // Orange super muda
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFFEDD5)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_rounded, color: Color(0xFFD97217), size: 16),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Gunakan API Key dari dashboard Payment Gateway Anda untuk mengaktifkan pembayaran QRIS otomatis.",
                              style: TextStyle(color: Colors.orange.shade800, fontSize: 11, height: 1.5),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              
              const SizedBox(height: 60), 
            ],
          ),
        ),
      ),
    );
  }

  // Helper untuk membuat Switch List
  Widget _buildSwitchItem(String title, IconData icon, RxBool rxBool) {
    return Obx(() => Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: const Color(0xFFD97217), size: 16),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF374151))),
        ),
        Switch(
          value: rxBool.value,
          onChanged: (val) => rxBool.value = val,
          activeColor: Colors.white,
          activeTrackColor: const Color(0xFFD97217),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey.shade300,
        )
      ],
    ));
  }
}