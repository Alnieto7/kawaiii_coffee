import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
import 'package:kawaiii_coffee/Component/POS/DotIndicator.dart';
import 'package:kawaiii_coffee/Controller/PaymentSuccess.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<PaymentSuccessController>();

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, value, child) => Transform.scale(
                scale: value,
                child: child,
              ),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowDark,
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.primaryDark,
                  size: 70,
                ),
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'Pembayaran Berhasil!',
              style: TextStyle(
                color: AppColors.textOnPrimary,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Terima kasih telah berbelanja\ndi Kawaiii Coffee',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryLight,
                fontSize: 15,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 48),

            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DotIndicator(delay: 0),
                SizedBox(width: 8),
                DotIndicator(delay: 200),
                SizedBox(width: 8),
                DotIndicator(delay: 400),
              ],
            ),

            const SizedBox(height: 16),

            const Text(
              'Menyiapkan struk...',
              style: TextStyle(color: AppColors.secondaryLight, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}