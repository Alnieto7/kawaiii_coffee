import 'package:flutter/material.dart';

class FilterChipItem extends StatelessWidget {
  final String label;
  final bool selected;

  const FilterChipItem({
    super.key,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFD97706) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}