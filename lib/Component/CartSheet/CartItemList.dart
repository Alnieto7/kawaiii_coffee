// lib/Component/Cart/cart_item_list.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/CartSheet/CartFormatHelper.dart';
import 'package:kawaiii_coffee/Controller/CartMenuController.dart';

class CartItemList extends StatelessWidget {
  final CartController cart;
  const CartItemList({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    // ConstrainedBox dihapus, biarkan Flexible di CartSheetPage yang atur ukurannya
    return Obx(() => cart.items.isEmpty ? _buildEmpty() : _buildList());
  }

  Widget _buildEmpty() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Agar tidak makan ruang berlebih saat kosong
        children: [
          Icon(Icons.coffee_outlined, size: 48, color: Color(0xFFD4C4A8)),
          SizedBox(height: 8),
          Text(
            "Keranjang masih kosong",
            style: TextStyle(color: Color(0xFFB0A090), fontSize: 14),
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
      separatorBuilder: (_, __) => const Divider(color: Color(0xFFEDE8DF)),
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
                  color: const Color(0xFFFEF3E2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.coffee_rounded,
                  color: Color(0xFFD97706),
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
                        color: Color(0xFF1A1008),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Rp ${formatRupiah(item.price)}",
                      style: const TextStyle(
                        color: Color(0xFFB08040),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // Kontrol qty
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EFE6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _QtyButton(
                      icon: Icons.remove_rounded,
                      onTap: () => cart.decrease(i),
                    ),
                    SizedBox(
                      width: 28,
                      child: Text(
                        "${item.qty}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xFF1A1008),
                        ),
                      ),
                    ),
                    _QtyButton(
                      icon: Icons.add_rounded,
                      onTap: () => cart.increase(i),
                      isAdd: true,
                    ),
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

// ── Private: tombol +/- qty ────────────────────────────────────────────────
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
          color: isAdd ? const Color(0xFFD97706) : const Color(0xFF8C7560),
        ),
      ),
    );
  }
}
