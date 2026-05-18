import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
import 'package:kawaiii_coffee/Component/CartSheet/CartFormatHelper.dart';
import 'package:kawaiii_coffee/Controller/CartMenuController.dart';

class CartItemList extends StatelessWidget {
  final CartController cart;
  const CartItemList({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Obx(() => cart.items.isEmpty ? _buildEmpty() : _buildList());
  }

  Widget _buildEmpty() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.coffee_outlined, size: 48, color: AppColors.textDisabled),
          SizedBox(height: 8),
          Text(
            "Keranjang masih kosong",
            style: TextStyle(color: AppColors.textHint, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shrinkWrap: true,
      itemCount: cart.items.length,
      separatorBuilder: (_, __) => const Divider(color: AppColors.divider),
      itemBuilder: (context, i) {
        final item = cart.items[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              // Avatar icon produk
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.coffee_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),

              // Nama & harga
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Rp ${formatRupiah(item.price)}",
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // Kontrol qty
              Container(
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _QtyButton(icon: Icons.remove_rounded, onTap: () => cart.decrease(i)),
                    SizedBox(
                      width: 28,
                      child: Text(
                        "${item.qty}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    _QtyButton(icon: Icons.add_rounded, onTap: () => cart.increase(i), isAdd: true),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isAdd;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    this.isAdd = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18,
          color: isAdd ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }
}