import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
import 'package:kawaiii_coffee/Component/CartSheet/CartFormatHelper.dart';
import 'package:kawaiii_coffee/Controller/CartMenuController.dart';

class CartDialogs {
  // Dialog konfirmasi bayar
  static void showPayConfirm(CartController cart) {
    final method = cart.paymentMethod.value;
    final methodLabel = method == 'qris' ? 'QRIS' : 'Cash';

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: _DialogContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DialogIcon(
                bgColor: AppColors.warningSurface,
                icon: Icons.receipt_long_rounded,
                iconColor: AppColors.warning,
              ),
              const SizedBox(height: 16),
              const Text(
                "Konfirmasi Pembayaran",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Proses pembayaran via $methodLabel\nsebesar",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                "Rp ${formatRupiah(cart.total)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _CancelButton(onPressed: () => Get.back())),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _ConfirmButton(
                      label: "Ya, Bayar",
                      color: AppColors.primary,
                      onPressed: () {
                        Get.back();
                        if (method == 'qris') {
                          cart.startQrisPayment();
                        } else {
                          cart.checkout();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierColor: AppColors.backgroundOverlay,
    );
  }

  // Dialog konfirmasi hapus semua
  static void showClearConfirm(CartController cart) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: _DialogContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DialogIcon(
                bgColor: AppColors.errorSurface,
                icon: Icons.delete_forever_rounded,
                iconColor: AppColors.error,
              ),
              const SizedBox(height: 16),
              const Text(
                "Hapus Semua Item?",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Semua item di keranjang\nakan dihapus.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _CancelButton(onPressed: () => Get.back())),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ConfirmButton(
                      label: "Hapus",
                      color: AppColors.error,
                      onPressed: () {
                        Get.back();
                        cart.clearCart();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierColor: AppColors.backgroundOverlay,
    );
  }
}

// Shared private widgets

class _DialogContainer extends StatelessWidget {
  final Widget child;
  const _DialogContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _DialogIcon extends StatelessWidget {
  final Color bgColor;
  final IconData icon;
  final Color iconColor;

  const _DialogIcon({
    required this.bgColor,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(icon, color: iconColor, size: 32),
    );
  }
}

class _CancelButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _CancelButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.border),
        foregroundColor: AppColors.textSecondary,
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text("Batal", style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ConfirmButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}