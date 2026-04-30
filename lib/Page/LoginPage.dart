import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/AdminComponent/CustomPrimaryButton.dart';
import 'package:kawaiii_coffee/Component/AdminComponent/CustomTextField.dart';
import 'package:kawaiii_coffee/Controller/LoginController.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- HEADER / LOGO AREA ---
              Container(
                height: 70,
                width: 70,
                decoration: const BoxDecoration(
                  color: Color(0xFFFCECDD), // Warna orange muda background logo
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.coffee, color: Color(0xFFD97217), size: 30),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Coffee Street',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Manajemen Operasional UMKM',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 50),

              // --- FORM AREA ---
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Masuk ke Akun',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Memanggil Reusable Widget CustomTextField
              CustomTextField(
                label: 'NAMA PENGGUNA',
                hint: 'Masukkan nama pengguna',
                prefixIcon: Icons.person_outline,
                controller: controller.nameController, // Hubungkan dengan controllermu
              ),
              const SizedBox(height: 16),
              
              // Memanggil Reusable Widget CustomTextField untuk Password
              Obx(() => CustomTextField(
                label: 'KATA SANDI',
                hint: '••••••••',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                obscureText: controller.isPasswordHidden.value,
                controller: controller.passwordController,
                onSuffixTap: () => controller.isPasswordHidden.toggle(),
              )),
              
              const SizedBox(height: 32),

              // --- ACTION AREA ---
              // Memanggil Reusable Widget CustomPrimaryButton
              Obx(() => CustomPrimaryButton(
                text: 'Masuk',
                isLoading: controller.isLoading.value,
                onPressed: () => controller.doLogin(),
              )),
              
              const SizedBox(height: 24),
              
              TextButton(
                onPressed: () {
                  // Aksi lupa password
                },
                child: const Text(
                  'Lupa Kata Sandi?',
                  style: TextStyle(
                    color: Color(0xFFD97217),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // --- FOOTER AREA ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB), // Abu-abu sangat muda
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Akses khusus untuk Internal Coffee Street.\n(Owner, Kasir, & Staff)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}