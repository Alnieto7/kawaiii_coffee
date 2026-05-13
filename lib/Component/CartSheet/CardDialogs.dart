// lib/Component/Cart/cart_dialogs.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/CartSheet/CartFormatHelper.dart';
import 'package:kawaiii_coffee/Controller/CartMenuController.dart';

class CartDialogs {
  // ── Dialog konfirmasi bayar ──────────────────────────────────────────────
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
                bgColor: const Color(0xFFFEF3E2),
                icon: Icons.receipt_long_rounded,
                iconColor: const Color(0xFFD97706),
              ),
              const SizedBox(height: 16),
              const Text(
                "Konfirmasi Pembayaran",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1008),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Proses pembayaran via $methodLabel\nsebesar",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Color(0xFF9C8A70)),
              ),
              const SizedBox(height: 4),
              Text(
                "Rp ${formatRupiah(cart.total)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFD97706),
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
                      color: const Color(0xFFD97706),
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
      barrierColor: Colors.black54,
    );
  }

  // ── Dialog konfirmasi hapus semua ────────────────────────────────────────
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
                bgColor: const Color(0xFFFEE2E2),
                icon: Icons.delete_forever_rounded,
                iconColor: const Color(0xFFDC2626),
              ),
              const SizedBox(height: 16),
              const Text(
                "Hapus Semua Item?",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1008),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Semua item di keranjang\nakan dihapus.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Color(0xFF9C8A70)),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _CancelButton(onPressed: () => Get.back())),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ConfirmButton(
                      label: "Hapus",
                      color: const Color(0xFFDC2626),
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
      barrierColor: Colors.black54,
    );
  }
}

// ── Shared private widgets ────────────────────────────────────────────────

class _DialogContainer extends StatelessWidget {
  final Widget child;
  const _DialogContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF5),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
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
        side: const BorderSide(color: Color(0xFFE0D5C5)),
        foregroundColor: const Color(0xFF8C7560),
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
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}
