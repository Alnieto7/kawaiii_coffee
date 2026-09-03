import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subValue;
  final bool isGreen;
  final bool isNeutral;
  final IconData? trailingIcon;
  final Color? trailingIconColor;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.subValue,
    this.isGreen = false,
    this.isNeutral = false,
    this.trailingIcon,
    this.trailingIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180, // Diberi width agar bisa di-scroll horizontal
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
              if (trailingIcon != null) 
                Icon(trailingIcon, size: 16, color: trailingIconColor ?? Colors.grey),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
          const SizedBox(height: 8),
          Row(
            children: [
              if (!isNeutral) 
                Icon(isGreen ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded, 
                     size: 14, color: isGreen ? Colors.green : Colors.red),
              if (!isNeutral) const SizedBox(width: 4),
              Expanded(
                child: Text(
                  subValue, 
                  style: TextStyle(fontSize: 10, color: isNeutral ? Colors.grey : (isGreen ? Colors.green : Colors.red)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}