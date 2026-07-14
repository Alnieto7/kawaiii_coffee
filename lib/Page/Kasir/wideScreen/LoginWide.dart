import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
import 'package:kawaiii_coffee/Component/AdminComponent/CustomPrimaryButton.dart';
import 'package:kawaiii_coffee/Component/AdminComponent/CustomTextField.dart';
import 'package:kawaiii_coffee/Controller/LoginController.dart';

class LoginWide extends GetView<LoginController> {
  const LoginWide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight, // Background sedikit berbeda agar form menonjol
      body: Row(
        children: [
          // ==============================
          // KOLOM KIRI (BRANDING & LOGO)
          // ==============================
          Expanded(
            flex: 1,
            child: Container(
              color: AppColors.primarySurface, // Warna latar brand
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.coffee, color: AppColors.primary, size: 60),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Coffee Street',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Sistem Manajemen Operasional UMKM',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ==============================
          // KOLOM KANAN (FORM LOGIN)
          // ==============================
          Expanded(
            flex: 1,
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: 450, // Batasi lebar maksimum form agar tidak kepanjangan
                  padding: const EdgeInsets.all(40.0),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Masuk ke Akun',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Silakan masukkan kredensial Anda.',
                        style: TextStyle(color: AppColors.textHint, fontSize: 14),
                      ),
                      const SizedBox(height: 40),

                      CustomTextField(
                        label: 'NAMA PENGGUNA',
                        hint: 'Masukkan nama pengguna',
                        prefixIcon: Icons.person_outline,
                        controller: controller.nameController,
                      ),
                      const SizedBox(height: 24),

                      Obx(() => CustomTextField(
                            label: 'KATA SANDI',
                            hint: '••••••••',
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                            obscureText: controller.isPasswordHidden.value,
                            controller: controller.passwordController,
                            onSuffixTap: () => controller.isPasswordHidden.toggle(),
                          )),
                      const SizedBox(height: 40),

                      Obx(() => CustomPrimaryButton(
                            text: 'Masuk',
                            isLoading: controller.isLoading.value,
                            onPressed: () => controller.doLogin(),
                          )),
                      const SizedBox(height: 32),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Akses khusus untuk Internal Coffee Street.\n(Owner, Kasir, & Staff)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textHint,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}