// lib/Component/Cart/cart_sheet_handle.dart

import 'package:flutter/material.dart';

class CartSheetHandle extends StatelessWidget {
  const CartSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: const Color(0xFFE0D5C5),
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }
}
