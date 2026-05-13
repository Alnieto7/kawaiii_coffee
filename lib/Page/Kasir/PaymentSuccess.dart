import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/POS/DotIndicator.dart';
import 'package:kawaiii_coffee/Controller/PaymentSuccess.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<PaymentSuccessController>();

    return Scaffold(
      backgroundColor: const Color(0xFF1a6b45),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon centang
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
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Color(0xFF1a6b45),
                  size: 70,
                ),
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'Pembayaran Berhasil!',
              style: TextStyle(
                color: Colors.white,
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
                color: Colors.white70,
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
              style: TextStyle(color: Colors.white60, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
